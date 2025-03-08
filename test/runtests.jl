using Test
using ConvolutionMatrix
using Plots

@testset "plot_psf Tests" begin
    @testset "Basic Functionality" begin
        # Test with basic PSF
        psf = [1, 3, 5, 4, 2]
        p = plot_psf(psf)
        @test p isa Plots.Plot  # Verify return type
        @test length(p.series) == length(psf) + 1  # PSF points + 1 x-axis line
        @test p.attr[:size] == (600, 250)  # Default size
    end

    @testset "Custom Parameters" begin
        psf = [1, 2, 1]
        # Test custom x_range
        p1 = plot_psf(psf, x_range=6)
        @test p1.attr[:xaxis].extrema == (-6, 6)

        # Test custom plot size
        p2 = plot_psf(psf, plot_size=(800, 400))
        @test p2.attr[:size] == (800, 400)
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
