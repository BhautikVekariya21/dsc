# Linear Algebra - Session 1 Notes

## Introduction

Linear algebra is a branch of mathematics that deals with the study of linear systems, which are sets of equations involving linear functions of variables. It is a foundational subject in mathematics and has applications in many areas, including computer science, engineering, physics, economics, and more.

## What are Vectors

Vectors are mathematical objects that have both magnitude and direction. They can be represented as ordered lists of numbers and are fundamental building blocks in linear algebra.

**Vector Notation:**

- Vector: **v** = [v₁, v₂, v₃, ..., vₙ]
- In column form: **v** = $\begin{bmatrix} v_1 \\ v_2 \\ v_3 \\ \vdots \\ v_n \end{bmatrix}$

## Vector Applications in Machine Learning

Vectors play a crucial role in machine learning, representing data points, features, and model parameters. They enable efficient computation and mathematical operations on datasets.

## Row and Column Vectors

- **Row Vector**: A vector arranged horizontally (1 × n matrix)

  - **a** = [a₁, a₂, a₃, ..., aₙ]

- **Column Vector**: A vector arranged vertically (n × 1 matrix)
  - **b** = $\begin{bmatrix} b_1 \\ b_2 \\ b_3 \\ \vdots \\ b_n \end{bmatrix}$

## Distance From Origin ||A||

The distance from the origin (also called the norm or magnitude of a vector) represents how far a vector extends from the zero point in the coordinate system.

**Formula:**

- ||**A**|| = √(a₁² + a₂² + a₃² + ... + aₙ²)
- For vector **A** = [a₁, a₂, a₃, ..., aₙ]

## Euclidean Distance

The Euclidean distance is the straight-line distance between two points in space, calculated using the Pythagorean theorem extended to multiple dimensions.

**Formula:**

- Distance between points **A** and **B**: d(**A**, **B**) = ||**A** - **B**||
- d(**A**, **B**) = √[(a₁-b₁)² + (a₂-b₂)² + (a₃-b₃)² + ... + (aₙ-bₙ)²]

## Mean Centering

Mean centering is a useful pre-processing technique in various machine learning applications. It can improve the performance, convergence, and interpretability of the model.

**Formula:**

- Mean-centered vector: **x̄** = **x** - μ
- Where μ = (1/n) Σᵢ₌₁ⁿ xᵢ (mean of the dataset)
- For dataset X = {x₁, x₂, ..., xₙ}

### Practical Applications of Mean Centering:

1. **Principal Component Analysis (PCA)**: PCA is a dimensionality reduction technique that transforms the data into a new coordinate system by identifying the directions (principal components) with the highest variance. Before applying PCA, it is essential to mean center the data to ensure that the first principal component represents the direction with the highest variance in the dataset, rather than being influenced by the location of the data in the coordinate system.

2. **Linear Regression**: In linear regression, mean centering can help improve the interpretability of the model coefficients by making them directly comparable. When the features are mean-centered, the intercept term represents the expected value of the dependent variable when all independent variables are at their mean values. Additionally, mean centering can help with multicollinearity issues, especially when there are interaction terms in the model.

3. **Gradient-based Optimization Algorithms**: Some machine learning algorithms, such as gradient descent, can converge faster when the input features are mean-centered. This is because mean centering can lead to better conditioning of the optimization problem, allowing the gradient descent algorithm to take larger, more consistent steps towards the optimal solution.

4. **Clustering Algorithms**: Mean centering can help improve the performance of clustering algorithms like k-means by ensuring that the initial cluster centroids are not heavily influenced by the location of the data in the coordinate system. This can lead to faster convergence and better clustering results.

5. **Regularization**: In machine learning models that use regularization techniques, such as ridge regression or LASSO, mean centering can help ensure that the regularization term has a consistent effect across all features. By mean centering the features, the model is less likely to penalize the intercept term, which can lead to better generalization.

## Vector Operations

### Scalar Addition/Subtraction (Shifting)

Operations that involve adding or subtracting a scalar value to/from each component of a vector, effectively shifting the vector in space.

**Formulas:**

- **Addition**: **v** + c = [v₁ + c, v₂ + c, v₃ + c, ..., vₙ + c]
- **Subtraction**: **v** - c = [v₁ - c, v₂ - c, v₃ - c, ..., vₙ - c]
- Where c is a scalar value

### Scalar Multiplication/Division (Scaling)

Operations that involve multiplying or dividing each component of a vector by a scalar value, changing the magnitude of the vector while preserving its direction.

**Formulas:**

- **Multiplication**: c · **v** = [c·v₁, c·v₂, c·v₃, ..., c·vₙ]
- **Division**: **v** / c = [v₁/c, v₂/c, v₃/c, ..., vₙ/c]
- Where c is a non-zero scalar value

### Vector Addition/Subtraction

Operations performed component-wise between two vectors of the same dimension, resulting in a new vector.

**Formulas:**

- **Addition**: **u** + **v** = [u₁ + v₁, u₂ + v₂, u₃ + v₃, ..., uₙ + vₙ]
- **Subtraction**: **u** - **v** = [u₁ - v₁, u₂ - v₂, u₃ - v₃, ..., uₙ - vₙ]

## Dot Product

The dot product is a scalar value obtained by multiplying corresponding components of two vectors and summing the results. It has geometric significance and is used in many applications.

**Formula:**

- **u** · **v** = u₁v₁ + u₂v₂ + u₃v₃ + ... + uₙvₙ
- **u** · **v** = Σᵢ₌₁ⁿ uᵢvᵢ
- **u** · **v** = ||**u**|| ||**v**|| cos(θ)

## Angle Between Two Vectors

The angle between two vectors can be calculated using the dot product formula and the magnitudes of the vectors. This is useful for measuring similarity and orientation.

**Formula:**

- cos(θ) = (**u** · **v**) / (||**u**|| ||**v**||)
- θ = arccos[(**u** · **v**) / (||**u**|| ||**v**||)]
- Where θ is the angle between vectors **u** and **v**

## Unit Vector

A unit vector is a vector with a magnitude of 1. It represents direction without magnitude and is obtained by dividing a vector by its norm.

**Formula:**

- Unit vector: **û** = **v** / ||**v**||
- Where ||**û**|| = 1
- **û** = [v₁/||**v**||, v₂/||**v**||, v₃/||**v**||, ..., vₙ/||**v**||]

## Projection of a Vector

Vector projection involves finding the component of one vector in the direction of another vector. This is useful in many geometric and optimization problems.

**Formulas:**

- **Scalar projection** of **u** onto **v**: comp\_**v**(**u**) = (**u** · **v**) / ||**v**||
- **Vector projection** of **u** onto **v**: proj\_**v**(**u**) = [(**u** · **v**) / ||**v**||²] **v**
- proj\_**v**(**u**) = [(**u** · **v**) / (**v** · **v**)] **v**

## Equation of Line in n-D

The equation of a line in n-dimensional space can be expressed using vectors, typically in parametric form using a point on the line and a direction vector.

**Parametric Form:**

- **L**(t) = **P₀** + t**d**
- Where:
  - **P₀** is a point on the line
  - **d** is the direction vector
  - t is a parameter (scalar)
- **L**(t) = [x₀ + td₁, y₀ + td₂, z₀ + td₃, ..., w₀ + tdₙ]

## Vector Norms

Vector norms are functions that assign a positive scalar value to vectors, representing their "size" or "length." Common norms include:

**L₁ Norm (Manhattan Distance):**

- ||**v**||₁ = |v₁| + |v₂| + |v₃| + ... + |vₙ|
- ||**v**||₁ = Σᵢ₌₁ⁿ |vᵢ|

**L₂ Norm (Euclidean Distance):**

- ||**v**||₂ = √(v₁² + v₂² + v₃² + ... + vₙ²)
- ||**v**||₂ = √(Σᵢ₌₁ⁿ vᵢ²)

**L∞ Norm (Maximum Norm):**

- ||**v**||∞ = max(|v₁|, |v₂|, |v₃|, ..., |vₙ|)

**General Lₚ Norm:**

- ||**v**||ₚ = (|v₁|ᵖ + |v₂|ᵖ + |v₃|ᵖ + ... + |vₙ|ᵖ)^(1/p)
- ||**v**||ₚ = (Σᵢ₌₁ⁿ |vᵢ|ᵖ)^(1/p)

---

_Date: April 11, 2023_  
_Session: Linear Algebra Fundamentals_
