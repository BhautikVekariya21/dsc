# Linear Algebra - Session 3 Notes

## Basis Vectors

**Basis vectors** are a set of linearly independent vectors that span a vector space. They form the foundation for representing any vector in that space as a linear combination of the basis vectors.

### Key Properties:

- Linearly independent
- Span the entire vector space
- Minimal spanning set
- Any vector in the space can be uniquely expressed as a linear combination of basis vectors

## Linear Transformations

A **linear transformation** is a function between two vector spaces that preserves the operations of vector addition and scalar multiplication.

### Properties of Linear Transformations:

1. **Additivity**: T(u + v) = T(u) + T(v)
2. **Homogeneity**: T(cu) = cT(u)

### Matrix Representation:

Linear transformations can be represented by matrices, where the transformation of a vector is computed by matrix multiplication.

## Linear Transformations in 3D

Linear transformations in three-dimensional space include:

- **Rotation** about an axis
- **Scaling** along coordinate axes
- **Reflection** across planes
- **Shearing** transformations
- **Projection** onto planes or lines

These transformations preserve:

- Lines remain lines
- Parallel lines remain parallel
- The origin remains fixed

## Matrix Multiplication as Composition

Matrix multiplication represents the **composition of linear transformations**. If we have two transformations:

- T₁ represented by matrix A
- T₂ represented by matrix B

Then the composition T₂ ∘ T₁ is represented by the matrix product BA.

### Key Points:

- The order of multiplication matters
- (BA)x = B(Ax) - first apply A, then apply B
- Matrix multiplication is associative but not commutative

## Test of Commutative Law

Matrix multiplication is **generally not commutative**:

```
A × B ≠ B × A (in general)
```

### When Matrices Do Commute:

- Identity matrix: AI = IA = A
- Scalar matrices
- Some special pairs of matrices
- Powers of the same matrix

## Determinant - Advanced Concepts

### Why Determinant is Only for Square Matrices?

The determinant represents a **scaling factor** for transformations. This interpretation is only meaningful for square matrices because:

- Input and output spaces must have the same dimension
- The concept of "scaling" requires comparable dimensions
- Only square matrices can represent bijective transformations

### What Does a Negative Determinant Mean?

A negative determinant indicates that the transformation:

- **Reverses orientation** (e.g., reflection)
- Changes the "handedness" of the coordinate system
- Flips the space "inside out"

### What Happens When a Matrix is Singular?

When det(A) = 0 (singular matrix):

- The transformation **collapses** the space to a lower dimension
- Information is lost in the transformation
- The matrix has **no inverse**
- Linear dependence exists among rows/columns

## Matrix Inverse - Advanced Concepts

### Why A × A⁻¹ = I?

The inverse matrix A⁻¹ represents the **reverse transformation**:

- If A transforms vector x to y, then A⁻¹ transforms y back to x
- Applying both transformations returns to the original state
- Mathematically: A⁻¹(Ax) = x for all x

### Why Inverse is Only Possible for Square Matrices?

Inverse matrices require **bijective transformations**:

1. **Bijective** = both injective (one-to-one) AND surjective (onto)
2. Only square matrices can potentially be bijective
3. Domain and codomain must have the same dimension

## Transformations for Non-Square Matrices

### Tall Matrices (m > n) - "Tall and Wide"

- Transform from **lower-dimensional** to **higher-dimensional** space
- Generally **not surjective** (not onto)
- Some output vectors have no corresponding input
- **No inverse** because not all outputs can be mapped back

### Wide Matrices (m < n)

- Transform from **higher-dimensional** to **lower-dimensional** space
- Represent **dimension reduction**
- Generally **not injective** (not one-to-one)
- Multiple inputs can map to the same output
- **No unique inverse** because mapping back is ambiguous

### Square Matrices (n × n)

- Represent transformations: T: V → V
- Map a vector space onto itself
- Can potentially be bijective
- Only these can have inverses (when non-singular)

## Why Inverse is Only Possible for Non-Singular Matrices

A matrix must be **non-singular** (det(A) ≠ 0) to have an inverse because:

1. **Singular matrices** (det(A) = 0) represent transformations that:

   - Collapse space to lower dimensions
   - Are not bijective
   - Have no unique reverse transformation

2. **Non-singular matrices** represent transformations that:
   - Preserve dimensionality
   - Are bijective
   - Have unique reverse transformations

## Data Matrix Representation

Matrices are used to represent datasets where:

- **Rows** typically represent observations/samples
- **Columns** typically represent features/variables
- Each element represents a specific measurement

### Applications:

- Machine learning datasets
- Image processing (pixel values)
- Statistical analysis
- Data preprocessing and transformation

## Matrix Multiplication (Revisited)

Matrix multiplication has geometric interpretation:

- Represents composition of linear transformations
- Each column of the result represents the transformation of corresponding basis vectors
- The result transforms the coordinate system

## Hadamard Product (Element-wise Product)

The **Hadamard product** (also known as Schur product) is element-wise multiplication of matrices.

### Definition:

For matrices A and B of the same size (m × n):

```
C = A ⊙ B
C[i,j] = A[i,j] × B[i,j]
```

### Properties:

- Requires matrices of **same dimensions**
- **Commutative**: A ⊙ B = B ⊙ A
- **Associative**: (A ⊙ B) ⊙ C = A ⊙ (B ⊙ C)
- Different from standard matrix multiplication

### Applications:

- Element-wise operations in neural networks
- Image processing (pixel-wise operations)
- Probability calculations
- Component-wise scaling

### Visualization Resource:

[Convolution Visualizer](https://ezyang.github.io/convolution-visualizer/) - helpful for understanding element-wise operations

## Key Takeaways

1. **Linear transformations** preserve vector space structure
2. **Matrix multiplication** represents composition of transformations
3. **Determinant** measures scaling and orientation changes
4. **Inverse matrices** represent reverse transformations
5. **Non-square matrices** cannot have inverses due to dimensional constraints
6. **Hadamard product** provides element-wise multiplication alternative

---

_Notes compiled from Linear Algebra Session 3 - April 15, 2023_
