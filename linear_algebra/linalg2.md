# Linear Algebra - Session 2 Notes

## What are Matrices?

A **matrix** is a rectangular array of numbers, symbols, or expressions arranged in rows and columns. The numbers, symbols, or expressions are called the **elements** of the matrix.

### Order of a Matrix

The order (or dimension) of a matrix is expressed as m × n, where:

- m = number of rows
- n = number of columns

## Applications of Matrices

### 1. Linear Systems

Matrices can be used to represent and solve systems of linear equations. A system of linear equations can be written in matrix form as:

```
Ax = b
```

Where:

- A is the matrix of coefficients
- x is the column vector of unknowns
- b is the column vector of constants

Methods for solving include:

- Gaussian elimination
- LU decomposition
- Matrix inversion

### 2. Linear Transformations

Matrices represent linear transformations between vector spaces. A matrix can define a linear transformation that maps vectors from one space to another while preserving:

- Vector addition
- Scalar multiplication

Examples: rotation, scaling, and reflection transformations in geometry.

### 3. Eigenvalues and Eigenvectors

Essential in various applications such as:

- Differential equations
- Stability analysis
- Matrix diagonalization

An eigenvalue-eigenvector pair (λ, v) of a square matrix A satisfies:

```
Av = λv
```

### 4. Graph Theory

Matrices represent graphs through:

- Adjacency matrices
- Incidence matrices
- Laplacian matrices

### 5. Markov Chains

Matrices are used in stochastic processes. **Transition matrices** describe the probabilities of transitioning between different states and can analyze long-term system behavior.

### 6. Computer Graphics

Matrices represent transformations such as:

- Translation
- Rotation
- Scaling
- Projection

Applied to 2D or 3D models to manipulate position, orientation, and size.

### 7. Control Theory

Matrices represent and analyze linear systems:

- State-space models
- Transfer functions
- Control strategy design and analysis

### 8. Optimization

Matrices represent:

- Constraints
- Objectives
- Variables

Used in linear programming, quadratic programming, and semidefinite programming.

## Types of Matrices

### Row Matrix

A matrix with only one row (1 × n matrix)

### Column Matrix

A matrix with only one column (m × 1 matrix)

### Square Matrix

A matrix where the number of rows equals the number of columns (n × n matrix)

### Non-Square Matrix

A matrix where the number of rows does not equal the number of columns

### Diagonal Matrix

A square matrix where all non-diagonal elements are zero

### Scalar Matrix

A diagonal matrix where all diagonal elements are equal

### Identity Matrix

A square matrix with ones on the main diagonal and zeros elsewhere

```
I = [1 0 0]
    [0 1 0]
    [0 0 1]
```

### Zero Matrix

A matrix where all elements are zero

## Matrix Operations

### Matrix Equality

Two matrices are equal if:

- They have the same order
- Corresponding elements are equal

### Scalar Operations

#### Scalar Addition

Add a scalar to each element of the matrix

#### Scalar Multiplication

Multiply each element of the matrix by a scalar

#### Negative of a Matrix

Multiply each element by -1

#### Rules for Scalar Operations

- K(A + B) = KA + KB

### Matrix Addition and Subtraction

#### Requirements

- Matrices must have the same order
- Add/subtract corresponding elements

#### Rules

- **Commutative**: A + B = B + A
- **Associative**: (A + B) + C = A + (B + C)
- **Additive Identity**: A + 0 = A
- **Additive Inverse**: A + (-A) = 0

### Matrix Multiplication

#### Rules

- **Not Commutative**: A·B ≠ B·A (in general)
- **Associative**: (AB)C = A(BC)
- **Distributive**: A(B + C) = AB + AC
- **Multiplicative Identity**: AI = IA = A

## Transpose of a Matrix

The **transpose** of matrix A, denoted A^T, is obtained by interchanging rows and columns.

### Symmetric Matrix

A matrix where A = A^T

### Skew-Symmetric Matrix

A matrix where A = -A^T

### Rules for Transpose

- (A^T)^T = A
- (A + B)^T = A^T + B^T
- (AB)^T = B^T A^T

## Determinant

The **determinant** is a scalar value computed from a square matrix that carries important information about the matrix.

### Uses of Determinants

- Determining matrix invertibility
- Finding solutions to systems of linear equations
- Calculating volume scaling factor for linear transformations

### Calculation Methods

- **1×1 matrix**: det(A) = a₁₁
- **2×2 matrix**: det(A) = a₁₁a₂₂ - a₁₂a₂₁
- **3×3 matrix**: Use cofactor expansion

### Rules

- det(A) = det(A^T)

### Singular Matrix

A matrix with determinant equal to zero (det(A) = 0)

## Minor and Cofactor

### Minor

The **minor** of an element aᵢⱼ is the determinant obtained by deleting the i-th row and j-th column. Denoted as Mᵢⱼ.

### Cofactor

The **cofactor** of an element aᵢⱼ is defined by:

```
Aᵢⱼ = (-1)^(i+j) × Mᵢⱼ
```

### Determinant using Cofactors

```
det(A) = Σ(elements of any row/column × their corresponding cofactors)
```

## Adjoint (Adjugate) Matrix

The **adjugate** (or classical adjoint) of matrix A, denoted adj(A), is formed by:

1. Replacing each element with its corresponding cofactor
2. Taking the transpose of the resulting matrix

## Inverse of a Matrix

An **inverse matrix** A⁻¹ is a matrix that, when multiplied by the original matrix A, results in the identity matrix:

```
A × A⁻¹ = A⁻¹ × A = I
```

### Properties of Inverse Matrices

- Only defined for square matrices
- A matrix is invertible if and only if it is non-singular (det(A) ≠ 0)
- If det(A) = 0, the matrix is singular and has no inverse

### Methods for Finding Inverse

- Gaussian elimination
- Adjugate method
- LU decomposition

### Rules

- (AB)⁻¹ = B⁻¹A⁻¹

## Solving Systems of Linear Equations

Matrices provide powerful methods for solving systems of linear equations:

1. **Matrix form**: Ax = b
2. **Solution methods**:
   - Gaussian elimination
   - Matrix inversion: x = A⁻¹b (when A is invertible)
   - LU decomposition
   - Cramer's rule (using determinants)

---

_Notes compiled from Linear Algebra Session 2 - April 14-15, 2023_
