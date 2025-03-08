module ConvolutionMatrix

using ColorSchemes
using DSP: conv
using FFTW: fft, ifft
using FFTViews: FFTView
using InteractiveUtils: versioninfo
using LaTeXStrings
using LinearMapsAA
using MIRTjim: jim
using Plots: RGB, default, gui, heatmap, plot, plot!, savefig, scatter!, @layout
using Plots.PlotMeasures: px

# Export the functions we want to make available to users of the package
export plot_psf

# Set default plot parameters
default(markerstrokecolor=:auto, markersize=11, linewidth=5, label="",
 tickfontsize = 11, labelfontsize = 15, titlefontsize=18)

"""
    plot_psf(psf::Vector{<:Number}; 
             x_range::Int=4, 
             plot_size::Tuple{Int,Int}=(600,250))

Plot the impulse response (PSF) of a filter.

# Arguments
- `psf`: Vector containing the filter impulse response
- `x_range`: Range of x-axis (default: ±4)
- `plot_size`: Size of the plot as (width, height) (default: (600,250))

# Returns
- The generated plot object

# Throws
- ArgumentError if psf is empty, x_range is negative, or plot_size dimensions are invalid
"""
function plot_psf(psf::Vector{<:Number}; 
                 x_range::Int=4, 
                 plot_size::Tuple{Int,Int}=(600,250))
    
    # Input validation
    isempty(psf) && throw(ArgumentError("PSF vector cannot be empty"))
    x_range <= 0 && throw(ArgumentError("x_range must be positive"))
    (plot_size[1] <= 0 || plot_size[2] <= 0) && throw(ArgumentError("plot dimensions must be positive"))
    
    K = length(psf)
    hp = Int((K-1)/2)  # half width

    # Create color scheme
    cols = [ColorSchemes.viridis[x] for x in range(0,1,K)]

    # Initialize plot
    pp = plot(widen=true, tickfontsize = 14, labelfontsize = 20,
        xaxis = (L"k", (-1,1) .* x_range, -x_range:x_range),
        yaxis = (L"h[k]", (minimum(psf)-0.2, maximum(psf)+0.2)),
        size = plot_size, left_margin = 15px, bottom_margin = 18px,
    )
    
    # Draw x-axis
    plot!([-x_range-1, x_range+1], [0, 0], color=:black, linewidth=2)
    
    # Plot PSF points
    for k in 1:K
        c = psf[k]
        c = cols[k]  # Use k instead of psf[k] for color indexing
        plot!([k-hp-1], [psf[k]], line=:stem, marker=:circle, color=c)
    end
    
    # Add additional points
    for k in (hp+1):x_range
        scatter!([k], [0], color=:grey)
        scatter!([-k], [0], color=:grey)
    end
    
    return pp
end

function main()
    # Example PSF
    psf = [1, 3, 5, 4, 2]
    
    # Generate and display plot
    p = plot_psf(psf)
    gui()
    
    # save the plot
    savefig(p, "psf.pdf")
end

# Only run main if this file is run directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end # module