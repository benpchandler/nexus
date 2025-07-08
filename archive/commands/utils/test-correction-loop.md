# Test-Driven Correction Loop Utility

## Overview

This utility provides the core logic for the automated test-correction loop used by NEXUS commands. It enables self-healing code generation by iteratively fixing test failures.

## Core Functions

### 1. Test Execution Wrapper

```python
async def execute_tests(cell_id: str, test_type: str = "all") -> TestResult:
    """
    Execute tests and parse results.
    
    Args:
        cell_id: The cell containing code to test
        test_type: Type of tests (unit|integration|e2e|all)
    
    Returns:
        TestResult object with success status and failure details
    """
    # Run 05-verify command
    result = await run_command(f"pris 05-verify --cell-id {cell_id} --test-type {test_type}")
    
    return TestResult(
        success=result.exit_code == 0,
        total_tests=result.data.get("summary", {}).get("total", 0),
        passed=result.data.get("summary", {}).get("passed", 0),
        failed=result.data.get("summary", {}).get("failed", 0),
        failures=result.data.get("failures", []),
        duration=result.data.get("summary", {}).get("duration", 0)
    )
```

### 2. Failure Analysis

```python
def analyze_failure(failure: TestFailure) -> CorrectionStrategy:
    """
    Analyze test failure and determine correction strategy.
    
    Args:
        failure: Test failure details
    
    Returns:
        CorrectionStrategy with fix approach
    """
    # Pattern matching for common failures
    patterns = {
        r"TypeError:.*undefined": FailureType.NULL_REFERENCE,
        r"AssertionError:.*Expected.*Received": FailureType.ASSERTION_MISMATCH,
        r"Cannot find module": FailureType.MISSING_IMPORT,
        r"SyntaxError": FailureType.SYNTAX_ERROR,
        r"timeout.*exceeded": FailureType.TIMEOUT
    }
    
    failure_type = FailureType.UNKNOWN
    for pattern, ftype in patterns.items():
        if re.search(pattern, failure.message):
            failure_type = ftype
            break
    
    # Get appropriate strategy
    strategy = CORRECTION_STRATEGIES.get(
        failure_type,
        DEFAULT_CORRECTION_STRATEGY
    )
    
    return CorrectionStrategy(
        type=failure_type,
        prompt_template=strategy["prompt"],
        focus_areas=strategy["focus"],
        examples=strategy.get("examples", [])
    )
```

### 3. Correction Generation

```python
async def generate_correction(
    cell_id: str,
    failures: List[TestFailure],
    attempt: int,
    max_attempts: int
) -> CorrectionResult:
    """
    Generate code corrections based on test failures.
    
    Args:
        cell_id: Cell containing failing code
        failures: List of test failures
        attempt: Current attempt number
        max_attempts: Maximum attempts allowed
    
    Returns:
        CorrectionResult with fixed code
    """
    # Load current implementation
    implementation = load_cell_implementation(cell_id)
    
    # Analyze each failure
    corrections_needed = []
    for failure in failures:
        strategy = analyze_failure(failure)
        corrections_needed.append({
            "test": failure.test_name,
            "file": failure.file,
            "strategy": strategy,
            "specific_fix": create_specific_fix_prompt(failure, strategy)
        })
    
    # Create correction prompt
    prompt = create_correction_prompt(
        implementation=implementation,
        corrections=corrections_needed,
        attempt=attempt,
        max_attempts=max_attempts,
        previous_attempts=load_previous_attempts(cell_id)
    )
    
    # Generate fixes
    fixed_code = await call_llm_for_corrections(prompt)
    
    return CorrectionResult(
        success=True,
        files_modified=list(fixed_code.keys()),
        corrections_applied=extract_applied_corrections(fixed_code),
        code=fixed_code
    )
```

### 4. Correction Application

```python
def apply_corrections(
    cell_id: str,
    corrections: CorrectionResult,
    backup: bool = True
) -> bool:
    """
    Apply generated corrections to code files.
    
    Args:
        cell_id: Cell to update
        corrections: Generated corrections
        backup: Whether to backup current version
    
    Returns:
        Success status
    """
    if backup:
        backup_current_attempt(cell_id)
    
    try:
        for file_path, new_content in corrections.code.items():
            # Validate syntax before applying
            if not validate_syntax(file_path, new_content):
                raise SyntaxError(f"Invalid syntax in {file_path}")
            
            # Write corrected code
            write_file(file_path, new_content)
        
        return True
    except Exception as e:
        # Rollback on error
        if backup:
            restore_from_backup(cell_id)
        raise
```

### 5. Main Correction Loop

```python
async def test_correction_loop(
    cell_id: str,
    max_attempts: int = 3,
    test_type: str = "all",
    quality_gates: bool = True
) -> BuildResult:
    """
    Main test-driven correction loop.
    
    Args:
        cell_id: Cell containing implementation
        max_attempts: Maximum correction attempts
        test_type: Types of tests to run
        quality_gates: Whether to run quality checks
    
    Returns:
        BuildResult with final status
    """
    build_state = initialize_build_state(cell_id)
    
    for attempt in range(1, max_attempts + 1):
        # Run tests
        test_result = await execute_tests(cell_id, test_type)
        
        # Record attempt
        build_state.record_attempt(
            attempt=attempt,
            test_result=test_result
        )
        
        if test_result.success:
            # Tests passed!
            if quality_gates:
                quality_result = await run_quality_gates(cell_id)
                if not quality_result.passed:
                    # Fix quality issues
                    await fix_quality_issues(cell_id, quality_result)
                    continue
            
            build_state.mark_success()
            return BuildResult(
                success=True,
                attempts=attempt,
                final_state=build_state
            )
        
        # Tests failed - attempt correction
        if attempt < max_attempts:
            correction_result = await generate_correction(
                cell_id=cell_id,
                failures=test_result.failures,
                attempt=attempt,
                max_attempts=max_attempts
            )
            
            if correction_result.success:
                apply_corrections(cell_id, correction_result)
                build_state.record_corrections(
                    attempt, 
                    correction_result.corrections_applied
                )
            else:
                # Correction generation failed
                break
    
    # Max attempts reached or correction failed
    build_state.mark_failure(
        reason="Max attempts exceeded",
        remaining_failures=test_result.failures
    )
    
    return BuildResult(
        success=False,
        attempts=attempt,
        final_state=build_state
    )
```

## Correction Strategies

```python
CORRECTION_STRATEGIES = {
    FailureType.ASSERTION_MISMATCH: {
        "prompt": "The test expects {expected} but the code returns {actual}. "
                 "Modify the implementation to return the expected value.",
        "focus": ["return_values", "calculations", "data_transformations"],
        "examples": [
            "If expecting array length 3 but getting 2, check array operations",
            "If expecting specific string but getting undefined, check string building"
        ]
    },
    
    FailureType.NULL_REFERENCE: {
        "prompt": "Null/undefined reference error: {details}. "
                 "Add proper null checks and initialization.",
        "focus": ["null_checks", "initialization", "optional_chaining"],
        "examples": [
            "Add: if (!user) return null;",
            "Use optional chaining: user?.profile?.name",
            "Initialize with default: const items = data.items || [];"
        ]
    },
    
    FailureType.MISSING_IMPORT: {
        "prompt": "Module '{module}' not found. Add the required import.",
        "focus": ["imports", "module_resolution"],
        "examples": [
            "import { validateEmail } from './utils/validation';",
            "const jwt = require('jsonwebtoken');"
        ]
    },
    
    FailureType.TYPE_ERROR: {
        "prompt": "Type error: {details}. Fix type annotations or casting.",
        "focus": ["type_annotations", "type_casting", "interfaces"],
        "examples": [
            "Parse string to number: parseInt(value, 10)",
            "Add type annotation: (user: User): string =>",
            "Cast type: response as APIResponse"
        ]
    },
    
    FailureType.ASYNC_ERROR: {
        "prompt": "Async handling issue: {details}. "
                 "Ensure promises are properly awaited.",
        "focus": ["async_await", "promise_handling"],
        "examples": [
            "Add await: const result = await fetchData();",
            "Mark function async: async function processUser()",
            "Handle promise rejection: .catch(error => ...)"
        ]
    }
}
```

## Build State Management

```python
class BuildState:
    """Tracks build progress and attempts."""
    
    def __init__(self, cell_id: str):
        self.cell_id = cell_id
        self.created_at = datetime.now()
        self.attempts = []
        self.status = "in_progress"
        self.final_result = None
    
    def record_attempt(self, attempt: int, test_result: TestResult):
        """Record a test attempt."""
        self.attempts.append({
            "number": attempt,
            "timestamp": datetime.now().isoformat(),
            "success": test_result.success,
            "total_tests": test_result.total_tests,
            "passed": test_result.passed,
            "failed": test_result.failed,
            "duration": test_result.duration,
            "corrections_applied": []
        })
    
    def record_corrections(self, attempt: int, corrections: List[str]):
        """Record corrections applied in an attempt."""
        for a in self.attempts:
            if a["number"] == attempt:
                a["corrections_applied"] = corrections
                break
    
    def mark_success(self):
        """Mark build as successful."""
        self.status = "success"
        self.completed_at = datetime.now()
    
    def mark_failure(self, reason: str, remaining_failures: List[TestFailure]):
        """Mark build as failed."""
        self.status = "failed"
        self.completed_at = datetime.now()
        self.failure_reason = reason
        self.remaining_failures = [
            {
                "test": f.test_name,
                "message": f.message,
                "file": f.file
            }
            for f in remaining_failures
        ]
    
    def save(self):
        """Save state to disk."""
        state_file = f".nexus/history/{self.cell_id}/.build_state.json"
        with open(state_file, 'w') as f:
            json.dump(self.__dict__, f, indent=2, default=str)
    
    @classmethod
    def load(cls, cell_id: str) -> 'BuildState':
        """Load state from disk."""
        state_file = f".nexus/history/{cell_id}/.build_state.json"
        if os.path.exists(state_file):
            with open(state_file, 'r') as f:
                data = json.load(f)
                state = cls(cell_id)
                state.__dict__.update(data)
                return state
        return cls(cell_id)
```

## Usage Example

```python
# From 06-build command
async def build_feature(ticket_id: str):
    # Generate implementation
    cell_id = await run_construct(ticket_id)
    
    # Run test-correction loop
    result = await test_correction_loop(
        cell_id=cell_id,
        max_attempts=3,
        quality_gates=True
    )
    
    if result.success:
        print(f"✅ Build successful after {result.attempts} attempts")
    else:
        print(f"❌ Build failed after {result.attempts} attempts")
        print(f"Remaining failures: {len(result.final_state.remaining_failures)}")
```

## Best Practices

1. **Incremental Fixes**: Fix one type of error at a time
2. **Preserve Working Code**: Don't modify passing tests
3. **Learn from Patterns**: Track common fixes for reuse
4. **Fast Feedback**: Quick test runs for rapid iteration
5. **Clear Logging**: Detailed logs for debugging

---

This utility enables NEXUS to automatically fix common coding errors through intelligent test-driven iteration.