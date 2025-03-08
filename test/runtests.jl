using Test
using ConvolutionMatrix
using Plots
using LinearAlgebra

@testset "plot_psf Tests" begin
    @testset "Basic Functionality" begin
        # Test with basic PSF
        psf = [1, 3, 5, 4, 2]
        p = plot_psf(psf)
        @test p isa Plots.Plot  # Verify return type
        @test length(p.subplots) > 0  # Verify plot has content
        @test Plots.get_size(p) == (600, 250)  # Default size
    end

    @testset "Custom Parameters" begin
        psf = [1, 2, 1]
        # Test custom x_range
        p1 = plot_psf(psf, x_range=6)
        xlims = Plots.xlims(p1)
        # Allow for some padding in the plot limits
        @test xlims[1] <= -6 && xlims[2] >= 6
        # Make sure limits are approximately symmetrical
        @test isapprox(abs(xlims[1]), abs(xlims[2]), rtol=0.2)

        # Test custom plot size
        p2 = plot_psf(psf, plot_size=(800, 400))
        @test Plots.get_size(p2) == (800, 400)
    end

    @testset "Input Validation" begin
        # Test empty PSF
        @test_throws ArgumentError plot_psf(Float64[])
        
        # Test negative x_range
        @test_throws ArgumentError plot_psf([1,2,3], x_range=-1)
        
        # Test invalid plot size
        @test_throws ArgumentError plot_psf([1,2,3], plot_size=(0, 100))
    end

    @testset "PSF Types" begin
        # Test with different numeric types
        @test plot_psf(Float64[1, 2, 3]) isa Plots.Plot
        @test plot_psf(Int64[1, 2, 3]) isa Plots.Plot
        @test plot_psf([1.5, 2.5, 3.5]) isa Plots.Plot
    end
end

@testset "Convolution Matrix Tests" begin
    @testset "Matrix Sizes" begin
        psf = [1, 3, 5, 3, 1]
        K = length(psf)
        N = 10
        
        # Test full convolution matrix size
        Az = create_convolution_matrix_full(psf, N)
        @test size(Az) == (N+K-1, N)
        
        # Test circular convolution matrix size
        Ac = create_convolution_matrix_circ(psf, N)
        @test size(Ac) == (N, N)
        
        # Test same convolution matrix size
        As = create_convolution_matrix_same(psf, N)
        @test size(As) == (N, N)
        
        # Test valid convolution matrix size
        Av = create_convolution_matrix_valid(psf, N)
        @test size(Av) == (N-K+1, N)
    end
    
    @testset "Matrix Values" begin
        # Simple test case with a known result
        psf = [1, 2, 1]
        N = 5
        
        # Test create_all_convolution_matrices function
        matrices = create_all_convolution_matrices(psf, N)
        @test length(matrices) == 4
        
        # Test full convolution on a simple vector
        x = [1, 0, 0, 0, 0]  # Unit impulse
        Az = create_convolution_matrix_full(psf, N)
        y = Az * x
        @test y ≈ [1, 2, 1, 0, 0, 0, 0]
        
        # Test circular convolution
        Ac = create_convolution_matrix_circ(psf, N)
        # Updated tests for circular convolution matrix
        @test Ac[1, 1] == 2
        @test Ac[1, 2] == 1
        @test Ac[1, 5] == 1
        
        # Test the circularity property
        x_circ = [1, 0, 0, 0, 0]
        y_circ = Ac * x_circ
        # Test that last element wraps around to affect first element
        @test y_circ[1] == 2 # Result of convolution at first position includes wrap-around
        
        # Test a simple convolution
        simple_psf = [1, 1]
        simple_x = [1, 2, 3]
        simple_Az = create_convolution_matrix_full(simple_psf, 3)
        @test simple_Az * simple_x ≈ [1, 3, 5, 3]
    end
end

@testset "Matrix Visualization Tests" begin
    psf = [1, 2, 3, 2, 1]
    N = 8
    
    # Test horizontal layout visualization
    @testset "Horizontal Layout" begin
        combined, individuals = display_convolution_matrices(psf, N, layout=:horizontal)
        @test combined isa Plots.Plot
        @test length(individuals) == 4
        @test all(p -> p isa Plots.Plot, individuals)
    end
    
    # Test grid layout visualization
    @testset "Grid Layout" begin
        combined, individuals = display_convolution_matrices(psf, N, layout=:grid, plot_size=(600, 600))
        @test combined isa Plots.Plot
        @test length(individuals) == 4
        @test all(p -> p isa Plots.Plot, individuals)
    end
    
    # Test invalid layout option
    @testset "Invalid Layout" begin
        @test_throws ErrorException display_convolution_matrices(psf, N, layout=:invalid)
    end
end
