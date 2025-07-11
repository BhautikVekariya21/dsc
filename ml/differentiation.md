# Session on Differentiation

_Date: 22 April 2023_

## 1. What is Differentiation?

Differentiation is the process of finding the derivative of a function. The derivative of a function represents the instantaneous rate of change of the function with respect to its variable, typically denoted as 'x'.

### Key Concepts:

- **Why instantaneous?** The derivative gives us the rate of change at a specific point, not over an interval
- **Relation with slope** The derivative at any point equals the slope of the tangent line to the function at that point
- **Maxima and Minima** Critical points where the derivative equals zero often correspond to local maxima or minima
- **How to calculate derivative** Using various differentiation rules and techniques
- **Intuition** Understanding the geometric and physical meaning of derivatives
- **Derivative in ML** Essential for optimization algorithms like gradient descent

## 2. Derivative of a Constant

The derivative of any constant is zero.

**Rule:** If f(x) = c (where c is a constant), then f'(x) = 0

**Example:**

- f(x) = 5 → f'(x) = 0
- f(x) = π → f'(x) = 0

## 3. Differentiation Rules Cheatsheet

### Power Rule

For any function of the form f(x) = xⁿ:

**Rule:** d/dx(xⁿ) = n·xⁿ⁻¹

**Examples:**

- f(x) = x³ → f'(x) = 3x²
- f(x) = x² → f'(x) = 2x
- f(x) = x → f'(x) = 1
- f(x) = x⁻¹ → f'(x) = -x⁻²

### Sum Rule

The derivative of a sum is the sum of the derivatives.

**Rule:** d/dx[f(x) + g(x)] = f'(x) + g'(x)

**Example:**

- f(x) = x² + 3x + 5 → f'(x) = 2x + 3 + 0 = 2x + 3

### Product Rule

For the product of two functions:

**Rule:** d/dx[f(x)·g(x)] = f'(x)·g(x) + f(x)·g'(x)

**Example:**

- f(x) = x²·sin(x) → f'(x) = 2x·sin(x) + x²·cos(x)

### Quotient Rule

For the quotient of two functions:

**Rule:** d/dx[f(x)/g(x)] = [f'(x)·g(x) - f(x)·g'(x)] / [g(x)]²

**Example:**

- f(x) = x²/(x+1) → f'(x) = [2x(x+1) - x²(1)] / (x+1)²

### Chain Rule

For composite functions:

**Rule:** d/dx[f(g(x))] = f'(g(x))·g'(x)

**Example:**

- f(x) = sin(x²) → f'(x) = cos(x²)·2x

## 4. Partial Differentiation

Partial differentiation deals with functions of multiple variables, where we find the derivative with respect to one variable while treating others as constants.

**Notation:** ∂f/∂x (partial derivative of f with respect to x)

**Example:**

- f(x,y) = x²y + 3xy² → ∂f/∂x = 2xy + 3y², ∂f/∂y = x² + 6xy

**Applications in ML:**

- Computing gradients in multivariable loss functions
- Backpropagation in neural networks
- Optimization with multiple parameters

## 5. Higher Order Derivatives

Higher order derivatives are derivatives of derivatives.

**Notation:**

- First derivative: f'(x) or df/dx
- Second derivative: f''(x) or d²f/dx²
- Third derivative: f'''(x) or d³f/dx³
- nth derivative: f⁽ⁿ⁾(x) or dⁿf/dxⁿ

**Physical Interpretation:**

- First derivative: velocity (rate of change of position)
- Second derivative: acceleration (rate of change of velocity)

**Example:**

- f(x) = x⁴ → f'(x) = 4x³ → f''(x) = 12x² → f'''(x) = 24x

## 6. Matrix Differentiation

Matrix differentiation extends differentiation concepts to matrices and vectors, crucial for machine learning and optimization.

**Key Concepts:**

- **Gradient:** Vector of partial derivatives
- **Jacobian Matrix:** Matrix of first-order partial derivatives
- **Hessian Matrix:** Matrix of second-order partial derivatives

**Applications:**

- Gradient descent algorithms
- Newton's method for optimization
- Backpropagation in neural networks

### Common Matrix Derivative Rules:

- d/dx(Ax) = A (where A is a constant matrix)
- d/dx(x^T Ax) = (A + A^T)x (for symmetric A: = 2Ax)
- d/dx(||x||²) = 2x

## 7. Applications in Machine Learning

### Gradient Descent

- Uses derivatives to find the direction of steepest descent
- Updates parameters: θ = θ - α∇J(θ)
- α is learning rate, ∇J(θ) is gradient of cost function

### Backpropagation

- Uses chain rule to compute gradients in neural networks
- Propagates error backwards through network layers
- Essential for training deep learning models

### Optimization

- Finding critical points where derivatives equal zero
- Determining convexity using second derivatives
- Constrained optimization using Lagrange multipliers

## 8. Complete Derivatives Reference

### Basic Functions:

- d/dx(c) = 0 (constant rule)
- d/dx(x) = 1
- d/dx(xⁿ) = nxⁿ⁻¹ (power rule)
- d/dx(√x) = 1/(2√x)
- d/dx(1/x) = -1/x²

### Exponential Functions:

- d/dx(eˣ) = eˣ
- d/dx(aˣ) = aˣ ln a
- d/dx(e^f(x)) = e^f(x) · f'(x)
- d/dx(a^f(x)) = a^f(x) · ln a · f'(x)

### Logarithmic Functions:

- d/dx(ln x) = 1/x
- d/dx(log_a x) = 1/(x ln a)
- d/dx(ln|x|) = 1/x
- d/dx(ln f(x)) = f'(x)/f(x)
- d/dx(log_a f(x)) = f'(x)/(f(x) ln a)

### Trigonometric Functions:

- d/dx(sin x) = cos x
- d/dx(cos x) = -sin x
- d/dx(tan x) = sec²x
- d/dx(cot x) = -csc²x
- d/dx(sec x) = sec x tan x
- d/dx(csc x) = -csc x cot x

### Inverse Trigonometric Functions:

- d/dx(arcsin x) = 1/√(1-x²)
- d/dx(arccos x) = -1/√(1-x²)
- d/dx(arctan x) = 1/(1+x²)
- d/dx(arccot x) = -1/(1+x²)
- d/dx(arcsec x) = 1/(|x|√(x²-1))
- d/dx(arccsc x) = -1/(|x|√(x²-1))

### Hyperbolic Functions:

- d/dx(sinh x) = cosh x
- d/dx(cosh x) = sinh x
- d/dx(tanh x) = sech²x
- d/dx(coth x) = -csch²x
- d/dx(sech x) = -sech x tanh x
- d/dx(csch x) = -csch x coth x

### Inverse Hyperbolic Functions:

- d/dx(sinh⁻¹ x) = 1/√(x²+1)
- d/dx(cosh⁻¹ x) = 1/√(x²-1)
- d/dx(tanh⁻¹ x) = 1/(1-x²)
- d/dx(coth⁻¹ x) = 1/(1-x²)
- d/dx(sech⁻¹ x) = -1/(x√(1-x²))
- d/dx(csch⁻¹ x) = -1/(|x|√(1+x²))

## 9. Advanced Differentiation Techniques

### Logarithmic Differentiation

Used when functions are products, quotients, or powers of functions:

**Steps:**

1. Take the natural logarithm of both sides
2. Differentiate both sides
3. Solve for y'

**Example:**

- f(x) = x^(sin x)
- ln f(x) = sin x · ln x
- f'(x)/f(x) = cos x · ln x + sin x/x
- f'(x) = x^(sin x) · [cos x · ln x + sin x/x]

### Implicit Differentiation

Used when y is not explicitly solved for in terms of x:

**Steps:**

1. Differentiate both sides with respect to x
2. Use chain rule for terms involving y
3. Solve for dy/dx

**Example:**

- x² + y² = 25
- 2x + 2y(dy/dx) = 0
- dy/dx = -x/y

### Parametric Differentiation

For parametric equations x = f(t), y = g(t):

**Formula:** dy/dx = (dy/dt)/(dx/dt)

**Second derivative:** d²y/dx² = d/dx(dy/dx) = [d/dt(dy/dx)]/(dx/dt)

### Vector Differentiation

For vector functions r(t) = ⟨f(t), g(t), h(t)⟩:

**Formula:** r'(t) = ⟨f'(t), g'(t), h'(t)⟩

**Rules:**

- d/dt[r(t) + s(t)] = r'(t) + s'(t)
- d/dt[c·r(t)] = c·r'(t)
- d/dt[r(t)·s(t)] = r'(t)·s(t) + r(t)·s'(t)
- d/dt[r(t) × s(t)] = r'(t) × s(t) + r(t) × s'(t)

1. **Identify the rule:** Determine which differentiation rule applies
2. **Simplify first:** Sometimes simplifying the function makes differentiation easier
3. **Check your work:** Verify by differentiating simple cases
4. **Practice chain rule:** Most complex derivatives involve the chain rule
5. **Understand the meaning:** Always interpret what the derivative represents

## 10. Special Derivative Rules

### L'Hôpital's Rule

For indeterminate forms (0/0 or ∞/∞):

**Rule:** If lim[x→a] f(x)/g(x) gives 0/0 or ∞/∞, then:
lim[x→a] f(x)/g(x) = lim[x→a] f'(x)/g'(x)

### Leibniz Rule (Product Rule for nth Derivatives)

For the nth derivative of a product:

**(fg)^(n) = Σ(k=0 to n) C(n,k) · f^(k) · g^(n-k)**

Where C(n,k) is the binomial coefficient.

### Faà di Bruno's Formula (Chain Rule for Higher Derivatives)

For the nth derivative of a composite function:

**(f∘g)^(n) = Σ f^(k)(g(x)) · B\_{n,k}(g'(x), g''(x), ..., g^(n-k+1)(x))**

Where B\_{n,k} are Bell polynomials.

## 11. Tips for Differentiation

1. **Identify the rule:** Determine which differentiation rule applies
2. **Simplify first:** Sometimes simplifying the function makes differentiation easier
3. **Check your work:** Verify by differentiating simple cases
4. **Practice chain rule:** Most complex derivatives involve the chain rule
5. **Understand the meaning:** Always interpret what the derivative represents

6. **Forgetting the chain rule** when dealing with composite functions
7. **Mixing up product and quotient rules**
8. **Not treating constants properly** in partial differentiation
9. **Sign errors** especially with trigonometric functions
10. **Forgetting to simplify** the final answer

## 12. Common Mistakes to Avoid

1. **Forgetting the chain rule** when dealing with composite functions
2. **Mixing up product and quotient rules**
3. **Not treating constants properly** in partial differentiation
4. **Sign errors** especially with trigonometric functions
5. **Forgetting to simplify** the final answer
6. **Confusing d/dx with ∂/∂x** in multivariable calculus
7. **Not applying the chain rule** to exponential and logarithmic functions
8. **Incorrect use of logarithmic differentiation**

## 13. Differentiation in Different Coordinate Systems

### Polar Coordinates

For r = f(θ):

- dr/dθ = f'(θ)
- dx/dθ = dr/dθ · cos θ - r sin θ
- dy/dθ = dr/dθ · sin θ + r cos θ

### Cylindrical Coordinates

For functions in cylindrical coordinates (r, θ, z):

- ∂/∂r, ∂/∂θ, ∂/∂z are the partial derivatives

### Spherical Coordinates

For functions in spherical coordinates (ρ, θ, φ):

- ∂/∂ρ, ∂/∂θ, ∂/∂φ are the partial derivatives

## 14. Applications Beyond Basic Calculus

### Differential Equations

- First-order: dy/dx = f(x,y)
- Second-order: d²y/dx² = f(x,y,dy/dx)
- Partial differential equations involve partial derivatives

### Complex Analysis

- Complex derivative: f'(z) = lim[h→0] [f(z+h) - f(z)]/h
- Cauchy-Riemann equations for differentiability

### Numerical Differentiation

- Forward difference: f'(x) ≈ [f(x+h) - f(x)]/h
- Backward difference: f'(x) ≈ [f(x) - f(x-h)]/h
- Central difference: f'(x) ≈ [f(x+h) - f(x-h)]/(2h)

This comprehensive guide covers all major aspects of differentiation, from basic rules to advanced applications across various mathematical domains.
