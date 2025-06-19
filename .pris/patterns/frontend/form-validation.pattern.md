---
pattern_id: "react-form-validation"
name: "React Form with Validation"
language: "typescript"
framework: "react"
type: "frontend"
tags: ["form", "validation", "react", "typescript", "react-hook-form", "zod"]
description: "Type-safe form with validation using React Hook Form and Zod"
usage_prompt: "When creating forms that need client-side validation, use this pattern for type safety and good UX"
common_mistakes:
  - "Not showing validation errors immediately"
  - "Missing loading states during submission"
  - "Forgetting to disable submit during processing"
  - "Not handling server-side validation errors"
success_rate: 0.92
usage_count: 38
---

```typescript
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription } from '@/components/ui/alert';

// Define validation schema
const formSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  confirmPassword: z.string(),
  acceptTerms: z.boolean().refine(val => val === true, {
    message: 'You must accept the terms and conditions'
  })
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

// Infer TypeScript type from schema
type FormData = z.infer<typeof formSchema>;

export function RegistrationForm() {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [serverError, setServerError] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset
  } = useForm<FormData>({
    resolver: zodResolver(formSchema),
    mode: 'onChange' // Show errors as user types
  });

  const onSubmit = async (data: FormData) => {
    setIsSubmitting(true);
    setServerError(null);

    try {
      const response = await fetch('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Registration failed');
      }

      // Success - reset form
      reset();
      // Redirect or show success message
    } catch (error) {
      setServerError(error instanceof Error ? error.message : 'An error occurred');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      {serverError && (
        <Alert variant="destructive">
          <AlertDescription>{serverError}</AlertDescription>
        </Alert>
      )}

      <div className="space-y-2">
        <Label htmlFor="email">Email</Label>
        <Input
          id="email"
          type="email"
          {...register('email')}
          aria-invalid={!!errors.email}
          aria-describedby="email-error"
        />
        {errors.email && (
          <p id="email-error" className="text-sm text-red-500">
            {errors.email.message}
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="password">Password</Label>
        <Input
          id="password"
          type="password"
          {...register('password')}
          aria-invalid={!!errors.password}
          aria-describedby="password-error"
        />
        {errors.password && (
          <p id="password-error" className="text-sm text-red-500">
            {errors.password.message}
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="confirmPassword">Confirm Password</Label>
        <Input
          id="confirmPassword"
          type="password"
          {...register('confirmPassword')}
          aria-invalid={!!errors.confirmPassword}
          aria-describedby="confirmPassword-error"
        />
        {errors.confirmPassword && (
          <p id="confirmPassword-error" className="text-sm text-red-500">
            {errors.confirmPassword.message}
          </p>
        )}
      </div>

      <div className="flex items-center space-x-2">
        <input
          id="acceptTerms"
          type="checkbox"
          {...register('acceptTerms')}
          aria-invalid={!!errors.acceptTerms}
        />
        <Label htmlFor="acceptTerms">
          I accept the terms and conditions
        </Label>
      </div>
      {errors.acceptTerms && (
        <p className="text-sm text-red-500">
          {errors.acceptTerms.message}
        </p>
      )}

      <Button
        type="submit"
        disabled={isSubmitting}
        className="w-full"
      >
        {isSubmitting ? 'Registering...' : 'Register'}
      </Button>
    </form>
  );
}
```

## Tests

```typescript
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { RegistrationForm } from './RegistrationForm';

// Mock fetch
global.fetch = jest.fn();

describe('RegistrationForm', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('shows validation errors for invalid inputs', async () => {
    render(<RegistrationForm />);
    
    const emailInput = screen.getByLabelText('Email');
    const submitButton = screen.getByRole('button', { name: /register/i });

    // Type invalid email
    await userEvent.type(emailInput, 'invalid-email');
    await userEvent.click(submitButton);

    expect(screen.getByText('Invalid email address')).toBeInTheDocument();
  });

  it('validates password match', async () => {
    render(<RegistrationForm />);
    
    const passwordInput = screen.getByLabelText('Password');
    const confirmInput = screen.getByLabelText('Confirm Password');

    await userEvent.type(passwordInput, 'password123');
    await userEvent.type(confirmInput, 'different123');

    expect(screen.getByText("Passwords don't match")).toBeInTheDocument();
  });

  it('submits form with valid data', async () => {
    (fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      json: async () => ({ success: true })
    });

    render(<RegistrationForm />);
    
    await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
    await userEvent.type(screen.getByLabelText('Password'), 'password123');
    await userEvent.type(screen.getByLabelText('Confirm Password'), 'password123');
    await userEvent.click(screen.getByLabelText('I accept the terms and conditions'));
    
    await userEvent.click(screen.getByRole('button', { name: /register/i }));

    await waitFor(() => {
      expect(fetch).toHaveBeenCalledWith('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          acceptTerms: true
        })
      });
    });
  });
});
```

## Variations

### With Dynamic Fields
```typescript
// Add dynamic field array
const formSchema = z.object({
  // ... other fields
  phoneNumbers: z.array(z.object({
    type: z.enum(['mobile', 'home', 'work']),
    number: z.string().regex(/^\+?[\d\s-()]+$/)
  })).min(1, 'At least one phone number is required')
});

// Use useFieldArray from react-hook-form
const { fields, append, remove } = useFieldArray({
  control,
  name: "phoneNumbers"
});
```

### With File Upload
```typescript
const formSchema = z.object({
  // ... other fields
  avatar: z.instanceof(File).refine(
    file => file.size <= 5 * 1024 * 1024,
    'File size must be less than 5MB'
  )
});

// In the form
<Input
  type="file"
  accept="image/*"
  {...register('avatar')}
/>
```

### With Server-Side Validation
```typescript
// Handle field-specific errors from server
const handleServerErrors = (errors: Record<string, string>) => {
  Object.entries(errors).forEach(([field, message]) => {
    setError(field as keyof FormData, {
      type: 'server',
      message
    });
  });
};
```