# Convolution Matrix

[![CI](https://github.com/hom-bahrani/ConvolutionMatrix/actions/workflows/ci.yml/badge.svg)](https://github.com/hom-bahrani/ConvolutionMatrix/actions/workflows/ci.yml)

## Introduction

The ConvolutionMatrix package provides tools for visualizing and understanding convolution operations through the lens of linear algebra. Convolution is a fundamental operation in signal processing, image processing, and deep learning that applies a filter (or kernel) to an input signal.

This package offers:

- **PSF Visualization**: Plot point spread functions (PSFs) or filter impulse responses with customizable parameters using `plot_psf`
- **Convolution Matrix Creation**: Generate different types of convolution matrices (`full`, `same`, `valid`, and `circular`) that represent convolution operations as matrix multiplication
- **Matrix Visualization**: Display these matrices with color-coding to understand how filters interact with signals

By representing convolution as matrix multiplication, this package helps bridge the gap between signal processing concepts and linear algebra, making it easier to understand how convolution operations work internally.

### Key Features:

- Create and visualize the four main types of convolution matrices:
  - `full`: Includes all positions where filter and signal overlap
  - `same`: Maintains the same output size as input
  - `valid`: Includes only positions where filter completely overlaps with signal
  - `circular`: Implements periodic boundary conditions

- Visualize these matrices with color schemes that match the filter representation
- Display matrices in different layout options (horizontal or grid)
- Comprehensive test suite ensuring correct functionality

## Setup

### 1. Activate Your Project Environment

Make sure you're in the directory of your project, then launch Julia and activate the project environment:

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
