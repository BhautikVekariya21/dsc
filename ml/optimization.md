# Session on Optimization

_Date: 21 April 2023_

## 1. Functions

A function is a mathematical rule that takes an input value, processes it according to a specific formula or set of instructions, and produces a unique output value. In other words, a function is a relationship between input and output values where each input is connected to exactly one output.

## 2. Multivariable Functions

Functions that take multiple input variables and produce an output based on the relationship between all input variables.

## 3. Parameters in a Function

In mathematics, parameters of a function are the variables that are used to define the behaviour of the function. The parameters influence the function's output by determining how the input values are processed.

The parameters are the constants or coefficients that appear in the function's formula. For example, in the quadratic function `f(x) = ax² + bx + c`, 'a', 'b', and 'c' are the parameters of the function. By changing the values of these parameters, you can modify the shape and position of the parabola represented by the function.

## 4. ML Models as Mathematical Functions

Machine learning models can be viewed as mathematical functions that map input features to output predictions, with parameters that define the model's behavior.

## 5. Parametric vs Non-Parametric ML Models

**Parametric Models**: Have a fixed number of parameters that define the model structure (e.g., linear regression, logistic regression).

**Non-Parametric Models**: The number of parameters can grow with the size of the training data (e.g., k-nearest neighbors, decision trees).

## 6. Linear Regression as a Parametric ML Model

Linear regression is a classic example of a parametric model where the relationship between input features and output is defined by a linear equation with fixed parameters (weights and bias).

## 7. Loss Function

A loss function, also known as a cost function or objective function, is a mathematical function that measures the difference between the predicted output and the actual target values in a machine learning model. The primary goal of training a machine learning model is to minimize the value of the loss function, which corresponds to improving the model's performance on the given task.

Loss functions play a crucial role in the optimization process, guiding the learning algorithm to adjust the model's parameters to achieve better predictions.

## 8. How to Select a Good Loss Function

When choosing a loss function, consider the following factors:

1. **Problem type**: The choice of a loss function depends on the type of problem you are solving. For example, in regression tasks, mean squared error (MSE) or mean absolute error (MAE) are commonly used. For binary classification, cross-entropy loss or hinge loss can be employed. For multi-class classification, categorical cross-entropy or multi-class hinge loss can be used. Choose a loss function that aligns with the objectives of the specific problem you are addressing.

2. **Robustness to outliers**: Some loss functions, like mean squared error, are more sensitive to outliers, which can lead to a model that is overly influenced by extreme values. If your dataset contains outliers or is prone to noise, consider using a loss function that is more robust to outliers, such as mean absolute error (MAE) or Huber loss.

3. **Interpretability and ease of use**: A good loss function should be interpretable and easy to implement. Simple loss functions like mean squared error or cross-entropy loss are widely used because they are easy to understand, compute, and differentiate. When possible, opt for a loss function that is easy to work with and can be easily incorporated into your optimization process.

4. **Differentiability**: Most optimization algorithms, like gradient descent, require the loss function to be differentiable. Choose a loss function that has continuous first-order derivatives, which makes it easier to compute the gradients needed for optimization.

5. **Compatibility with the model**: Ensure that the chosen loss function is compatible with the model architecture you are using. Some models have specific requirements or assumptions about the loss function. For example, linear regression assumes a Gaussian noise distribution, which is why mean squared error is a suitable loss function in that case.

## 9. Calculating Parameters From a Loss Function (The Easy Way and Problems)

The "easy way" to find optimal parameters is to set the gradient of the loss function to zero and solve analytically. However, this approach has several limitations.

### Problems with the Easy Way

1. **Non-convexity**: The loss function may not always be convex, meaning that it might have multiple local minima and maxima. In such cases, setting the gradient to zero might lead to a local minimum or maximum, which is not necessarily the global minimum (the optimal solution).

2. **Complexity**: For some models, the loss function can be highly complex, and finding the analytical solution by setting the gradient to zero might be computationally expensive or even impossible. This is particularly true for deep learning models, where the loss functions involve a large number of parameters and complex relationships between them.

3. **Scalability**: In large-scale machine learning problems with massive amounts of data or high-dimensional feature spaces, computing the analytical solution by setting the gradient to zero can be computationally prohibitive due to the high cost of processing and storing the data.

4. **Online learning and streaming data**: In some applications, the data is not available all at once but arrives in a continuous stream. In these scenarios, models need to be updated incrementally as new data arrives, and an analytical solution would not be practical. Gradient descent and its variants, such as stochastic gradient descent, are well-suited for online learning and handling streaming data.

## 10. Convex and Non-Convex Loss Functions

**Convex Loss Functions**: Have a single global minimum, making optimization easier and guaranteeing convergence to the optimal solution.

**Non-Convex Loss Functions**: Have multiple local minima and maxima, making optimization more challenging as algorithms might get stuck in local optima.

## 11. Gradient Descent

Gradient descent is an iterative optimization algorithm used to find the minimum of a function by moving in the direction of the steepest descent (negative gradient). It's widely used in machine learning to minimize loss functions and find optimal model parameters.

## 12. Gradient Descent with Multiple Parameters

When dealing with multiple parameters, gradient descent computes the partial derivative of the loss function with respect to each parameter and updates all parameters simultaneously in the direction that minimizes the loss.

## 13. Problems Faced in Optimization

1. **Non-convexity**: For many machine learning models, such as artificial neural networks, the loss function is non-convex, which means it has a complex landscape with multiple local minima, maxima, and saddle points. This makes it difficult for optimization algorithms to find the global minimum and can result in suboptimal solutions.

2. **Ill-conditioning**: The loss function may be ill-conditioned, meaning the gradients in some dimensions are much larger than in others. This can cause gradient-based optimization algorithms, such as gradient descent, to oscillate and converge slowly.

3. **Vanishing and exploding gradients**: In deep neural networks, the gradients can become very small (vanish) or very large (explode) as they propagate through the layers. This can lead to slow convergence or unstable training dynamics, making it difficult to optimize the loss function.

4. **Overfitting**: When optimizing the loss function, the algorithm may overfit the training data, resulting in a model that performs poorly on unseen data. This occurs when the model is too complex and learns the noise in the training data instead of the underlying patterns.

5. **Scalability**: For large-scale problems with a high number of features, instances, or model parameters, optimizing the loss function can be computationally expensive and time-consuming. This can limit the applicability of certain optimization techniques or require significant computational resources.

## 14. Other Optimization Techniques

Beyond basic gradient descent, there are various advanced optimization techniques designed to address the challenges mentioned above, including:

- Stochastic Gradient Descent (SGD)
- Mini-batch Gradient Descent
- Momentum-based methods
- Adaptive learning rate methods (AdaGrad, RMSprop, Adam)
- Second-order methods (Newton's method, Quasi-Newton methods)
- Evolutionary algorithms
- Simulated annealing

These techniques offer different approaches to handle non-convexity, improve convergence speed, and adapt to various problem characteristics.
