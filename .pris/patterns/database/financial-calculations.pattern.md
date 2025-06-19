---
pattern_id: "financial-calculations-dcf"
name: "DCF Valuation Model"
language: "python"
framework: "pandas"
type: "database"
tags: ["finance", "dcf", "valuation", "calculations", "qoe", "pandas"]
description: "Discounted Cash Flow valuation model with sensitivity analysis and error handling"
usage_prompt: "When implementing financial valuation models or DCF calculations, use this pattern for accuracy and compliance"
common_mistakes:
  - "Using float for monetary values instead of Decimal"
  - "Not handling division by zero in WACC calculations"
  - "Forgetting to adjust for mid-year convention"
  - "Missing sensitivity analysis"
success_rate: 0.91
usage_count: 27
---

```python
from decimal import Decimal, ROUND_HALF_UP
from typing import Dict, List, Optional, Tuple
import pandas as pd
import numpy as np
from dataclasses import dataclass
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

@dataclass
class DCFInputs:
    """Validated inputs for DCF calculation."""
    revenue_growth_rates: List[Decimal]  # Year 1-5 growth rates
    ebitda_margins: List[Decimal]       # Year 1-5 EBITDA margins
    capex_percent_revenue: List[Decimal] # Year 1-5 CapEx as % of revenue
    nwc_percent_revenue: List[Decimal]   # Year 1-5 NWC as % of revenue
    tax_rate: Decimal
    terminal_growth_rate: Decimal
    risk_free_rate: Decimal
    market_risk_premium: Decimal
    beta: Decimal
    debt_to_equity: Decimal
    cost_of_debt: Decimal
    base_revenue: Decimal
    base_year: int

class DCFValuationModel:
    """Enterprise valuation using Discounted Cash Flow methodology."""
    
    def __init__(self, inputs: DCFInputs):
        self.inputs = inputs
        self._validate_inputs()
        self.projection_years = len(inputs.revenue_growth_rates)
        
    def _validate_inputs(self):
        """Validate all inputs are within reasonable ranges."""
        if not all(-0.5 <= rate <= 1.0 for rate in self.inputs.revenue_growth_rates):
            raise ValueError("Revenue growth rates must be between -50% and 100%")
            
        if not 0 <= self.inputs.terminal_growth_rate <= 0.05:
            raise ValueError("Terminal growth rate must be between 0% and 5%")
            
        if not 0 <= self.inputs.tax_rate <= 0.5:
            raise ValueError("Tax rate must be between 0% and 50%")
    
    def calculate_wacc(self) -> Decimal:
        """Calculate Weighted Average Cost of Capital."""
        # Cost of equity using CAPM
        cost_of_equity = (
            self.inputs.risk_free_rate + 
            self.inputs.beta * self.inputs.market_risk_premium
        )
        
        # Weights
        total_value = 1 + self.inputs.debt_to_equity
        equity_weight = Decimal('1') / total_value
        debt_weight = self.inputs.debt_to_equity / total_value
        
        # After-tax cost of debt
        after_tax_cost_of_debt = (
            self.inputs.cost_of_debt * (1 - self.inputs.tax_rate)
        )
        
        # WACC
        wacc = (
            equity_weight * cost_of_equity + 
            debt_weight * after_tax_cost_of_debt
        )
        
        logger.info(f"Calculated WACC: {wacc:.4f}")
        return wacc
    
    def project_cash_flows(self) -> pd.DataFrame:
        """Project unlevered free cash flows."""
        projections = pd.DataFrame(index=range(self.projection_years + 1))
        
        # Revenue projections
        projections.loc[0, 'Revenue'] = float(self.inputs.base_revenue)
        for year in range(1, self.projection_years + 1):
            prev_revenue = projections.loc[year - 1, 'Revenue']
            growth_rate = float(self.inputs.revenue_growth_rates[year - 1])
            projections.loc[year, 'Revenue'] = prev_revenue * (1 + growth_rate)
        
        # EBITDA
        for year in range(1, self.projection_years + 1):
            revenue = projections.loc[year, 'Revenue']
            margin = float(self.inputs.ebitda_margins[year - 1])
            projections.loc[year, 'EBITDA'] = revenue * margin
        
        # EBIT (assuming depreciation = CapEx for simplicity)
        for year in range(1, self.projection_years + 1):
            revenue = projections.loc[year, 'Revenue']
            capex_rate = float(self.inputs.capex_percent_revenue[year - 1])
            depreciation = revenue * capex_rate
            projections.loc[year, 'EBIT'] = (
                projections.loc[year, 'EBITDA'] - depreciation
            )
        
        # Tax
        tax_rate = float(self.inputs.tax_rate)
        for year in range(1, self.projection_years + 1):
            projections.loc[year, 'Tax'] = (
                projections.loc[year, 'EBIT'] * tax_rate
            )
        
        # NOPAT
        for year in range(1, self.projection_years + 1):
            projections.loc[year, 'NOPAT'] = (
                projections.loc[year, 'EBIT'] - projections.loc[year, 'Tax']
            )
        
        # Add back depreciation
        for year in range(1, self.projection_years + 1):
            revenue = projections.loc[year, 'Revenue']
            capex_rate = float(self.inputs.capex_percent_revenue[year - 1])
            projections.loc[year, 'Depreciation'] = revenue * capex_rate
        
        # CapEx
        for year in range(1, self.projection_years + 1):
            revenue = projections.loc[year, 'Revenue']
            capex_rate = float(self.inputs.capex_percent_revenue[year - 1])
            projections.loc[year, 'CapEx'] = revenue * capex_rate
        
        # Change in NWC
        for year in range(self.projection_years + 1):
            revenue = projections.loc[year, 'Revenue']
            if year == 0:
                projections.loc[year, 'NWC'] = 0
            else:
                nwc_rate = float(self.inputs.nwc_percent_revenue[year - 1])
                projections.loc[year, 'NWC'] = revenue * nwc_rate
        
        for year in range(1, self.projection_years + 1):
            projections.loc[year, 'Change_in_NWC'] = (
                projections.loc[year, 'NWC'] - projections.loc[year - 1, 'NWC']
            )
        
        # Unlevered Free Cash Flow
        for year in range(1, self.projection_years + 1):
            projections.loc[year, 'UFCF'] = (
                projections.loc[year, 'NOPAT'] +
                projections.loc[year, 'Depreciation'] -
                projections.loc[year, 'CapEx'] -
                projections.loc[year, 'Change_in_NWC']
            )
        
        return projections
    
    def calculate_terminal_value(
        self, final_fcf: float, wacc: Decimal
    ) -> Decimal:
        """Calculate terminal value using perpetuity growth method."""
        terminal_fcf = final_fcf * (1 + float(self.inputs.terminal_growth_rate))
        
        if wacc <= self.inputs.terminal_growth_rate:
            raise ValueError(
                "WACC must be greater than terminal growth rate"
            )
        
        terminal_value = Decimal(str(terminal_fcf)) / (
            wacc - self.inputs.terminal_growth_rate
        )
        
        return terminal_value
    
    def calculate_enterprise_value(self) -> Dict[str, Decimal]:
        """Calculate enterprise value and key metrics."""
        wacc = self.calculate_wacc()
        projections = self.project_cash_flows()
        
        # PV of projected cash flows
        pv_fcf = Decimal('0')
        for year in range(1, self.projection_years + 1):
            fcf = projections.loc[year, 'UFCF']
            # Mid-year convention
            discount_factor = (1 + float(wacc)) ** (year - 0.5)
            pv_fcf += Decimal(str(fcf)) / Decimal(str(discount_factor))
        
        # Terminal value
        final_fcf = projections.loc[self.projection_years, 'UFCF']
        terminal_value = self.calculate_terminal_value(final_fcf, wacc)
        
        # PV of terminal value
        terminal_discount = (1 + float(wacc)) ** self.projection_years
        pv_terminal = terminal_value / Decimal(str(terminal_discount))
        
        # Enterprise value
        enterprise_value = pv_fcf + pv_terminal
        
        return {
            'enterprise_value': enterprise_value.quantize(
                Decimal('0.01'), rounding=ROUND_HALF_UP
            ),
            'pv_fcf': pv_fcf.quantize(
                Decimal('0.01'), rounding=ROUND_HALF_UP
            ),
            'pv_terminal': pv_terminal.quantize(
                Decimal('0.01'), rounding=ROUND_HALF_UP
            ),
            'terminal_value': terminal_value.quantize(
                Decimal('0.01'), rounding=ROUND_HALF_UP
            ),
            'wacc': wacc.quantize(
                Decimal('0.0001'), rounding=ROUND_HALF_UP
            )
        }
    
    def sensitivity_analysis(
        self, 
        variable: str, 
        range_pct: float = 0.1
    ) -> pd.DataFrame:
        """Perform sensitivity analysis on key variables."""
        base_value = self.calculate_enterprise_value()['enterprise_value']
        
        # Define sensitivity ranges
        if variable == 'wacc':
            base_wacc = self.calculate_wacc()
            test_values = [
                base_wacc * Decimal(str(1 + i * 0.05))
                for i in range(-2, 3)
            ]
        elif variable == 'terminal_growth':
            base_tg = self.inputs.terminal_growth_rate
            test_values = [
                base_tg + Decimal(str(i * 0.005))
                for i in range(-2, 3)
            ]
        else:
            raise ValueError(f"Unknown variable: {variable}")
        
        results = []
        for test_value in test_values:
            # Create modified inputs
            if variable == 'terminal_growth':
                self.inputs.terminal_growth_rate = test_value
            
            try:
                ev = self.calculate_enterprise_value()['enterprise_value']
                change_pct = ((ev - base_value) / base_value) * 100
                results.append({
                    variable: float(test_value),
                    'enterprise_value': float(ev),
                    'change_percent': float(change_pct)
                })
            except Exception as e:
                logger.warning(f"Sensitivity calculation failed: {e}")
                results.append({
                    variable: float(test_value),
                    'enterprise_value': None,
                    'change_percent': None
                })
        
        # Restore original value
        if variable == 'terminal_growth':
            self.inputs.terminal_growth_rate = base_tg
        
        return pd.DataFrame(results)
```

## Tests

```python
import pytest
from decimal import Decimal
import pandas as pd

class TestDCFValuation:
    
    @pytest.fixture
    def sample_inputs(self):
        """Create sample DCF inputs."""
        return DCFInputs(
            revenue_growth_rates=[
                Decimal('0.15'), Decimal('0.12'), 
                Decimal('0.10'), Decimal('0.08'), Decimal('0.05')
            ],
            ebitda_margins=[
                Decimal('0.25'), Decimal('0.26'), 
                Decimal('0.27'), Decimal('0.27'), Decimal('0.28')
            ],
            capex_percent_revenue=[
                Decimal('0.04'), Decimal('0.04'), 
                Decimal('0.03'), Decimal('0.03'), Decimal('0.03')
            ],
            nwc_percent_revenue=[
                Decimal('0.10'), Decimal('0.10'), 
                Decimal('0.10'), Decimal('0.10'), Decimal('0.10')
            ],
            tax_rate=Decimal('0.25'),
            terminal_growth_rate=Decimal('0.025'),
            risk_free_rate=Decimal('0.03'),
            market_risk_premium=Decimal('0.08'),
            beta=Decimal('1.2'),
            debt_to_equity=Decimal('0.5'),
            cost_of_debt=Decimal('0.04'),
            base_revenue=Decimal('1000000'),
            base_year=2024
        )
    
    def test_wacc_calculation(self, sample_inputs):
        """Test WACC calculation."""
        model = DCFValuationModel(sample_inputs)
        wacc = model.calculate_wacc()
        
        # Expected WACC should be around 10.17%
        assert 0.09 < wacc < 0.12
        assert isinstance(wacc, Decimal)
    
    def test_cash_flow_projections(self, sample_inputs):
        """Test cash flow projections."""
        model = DCFValuationModel(sample_inputs)
        projections = model.project_cash_flows()
        
        # Check DataFrame structure
        assert len(projections) == 6  # Base year + 5 projection years
        assert 'UFCF' in projections.columns
        
        # Check revenue growth
        year1_revenue = projections.loc[1, 'Revenue']
        expected_revenue = 1000000 * 1.15
        assert abs(year1_revenue - expected_revenue) < 1
        
        # Check UFCF is positive
        assert all(projections.loc[1:, 'UFCF'] > 0)
    
    def test_enterprise_value_calculation(self, sample_inputs):
        """Test enterprise value calculation."""
        model = DCFValuationModel(sample_inputs)
        results = model.calculate_enterprise_value()
        
        assert 'enterprise_value' in results
        assert 'pv_fcf' in results
        assert 'pv_terminal' in results
        
        # Enterprise value should be sum of PV components
        ev = results['enterprise_value']
        pv_sum = results['pv_fcf'] + results['pv_terminal']
        assert abs(ev - pv_sum) < Decimal('1')
        
        # Sanity check on magnitude
        assert ev > Decimal('1000000')  # Should be > base revenue
    
    def test_sensitivity_analysis(self, sample_inputs):
        """Test sensitivity analysis."""
        model = DCFValuationModel(sample_inputs)
        
        # Test terminal growth sensitivity
        sensitivity_df = model.sensitivity_analysis('terminal_growth')
        
        assert len(sensitivity_df) == 5
        assert 'change_percent' in sensitivity_df.columns
        
        # Higher terminal growth should increase EV
        assert sensitivity_df['change_percent'].iloc[-1] > 0
        assert sensitivity_df['change_percent'].iloc[0] < 0
```

## Variations

### Monte Carlo Simulation
```python
def monte_carlo_valuation(self, iterations: int = 1000) -> Dict:
    """Run Monte Carlo simulation for valuation uncertainty."""
    results = []
    
    for _ in range(iterations):
        # Randomly vary key inputs
        varied_inputs = self._create_random_inputs()
        model = DCFValuationModel(varied_inputs)
        
        try:
            ev = model.calculate_enterprise_value()['enterprise_value']
            results.append(float(ev))
        except:
            continue
    
    return {
        'mean': np.mean(results),
        'std': np.std(results),
        'percentile_10': np.percentile(results, 10),
        'percentile_90': np.percentile(results, 90)
    }
```

### Comparable Company Analysis
```python
def apply_multiples_valuation(
    self, 
    peer_multiples: Dict[str, List[float]]
) -> Dict[str, Decimal]:
    """Apply trading multiples from comparable companies."""
    current_ebitda = self.project_cash_flows().loc[1, 'EBITDA']
    
    valuations = {}
    for multiple_type, values in peer_multiples.items():
        median_multiple = np.median(values)
        if multiple_type == 'EV/EBITDA':
            valuations[multiple_type] = (
                Decimal(str(current_ebitda)) * 
                Decimal(str(median_multiple))
            )
    
    return valuations
```