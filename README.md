# Convolution Matrix

The `plot_psf` function defines a module that visualizes a filter's impulse response (or PSF), which in linear algebra terms is a vector of coefficients that represents a linear transformation via convolution. 

When you apply convolution in signal processing, you're effectively multiplying the input signal by a convolution matrix constructed from the PSF, where each row shifts the filter's coefficients over the signal. The module validates the input PSF, assigns a color gradient for visual appeal, and then plots the PSF as a stem plot, offering an intuitive look at how the filter will influence the signal. This visualization helps you understand the underlying linear operation—where each coefficient in the PSF contributes to the overall output through linear combinations—by mapping it to a graphical representation.


## Setup

### 1. Activate Your Project Environment

Make sure you’re in the directory of your project, then launch Julia and activate the project environment:

```julia
using Pkg
Pkg.activate(".")
```

This tells Julia to use the `Project.toml` and (if it exists) the `Manifest.toml` in the current directory.

### 2. Install the Packages

The `Pkg.instantiate()` command reads the `Project.toml` (and, if available, the `Manifest.toml`) file and installs all the necessary dependencies for the project into your local environment. 

```julia
Pkg.instantiate()
```

### 3. To Install Packages

You can add packages by using the `Pkg.add` function. Make sure to separate the package names with commas in the array. For example:

```julia
using Pkg
Pkg.add([
    "LinearAlgebra"
])
```

This command will update your `Project.toml` file by adding the packages to the `[deps]` section and generate or update the `Manifest.toml` file with the resolved dependencies.

### 4. Running the Unit Tests

To run your tests, follow these steps:

1. **Activate the Environment:**  
   In the Julia REPL, navigate to your project directory and activate its environment:
   ```julia
   using Pkg
   Pkg.activate(".")
   ```

2. **Run the Tests:**  
   After activation, execute:
   ```julia
   Pkg.test()
   ```
   This command will run the tests defined in `test/runtests.jl`.

Alternatively, you can run the tests from the command line with:
```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```
