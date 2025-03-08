using FFTW: fft, ifft
using FFTViews: FFTView
using DSP: conv
using LinearMapsAA

"""
    create_convolution_matrix_full(psf::Vector{<:Number}, N::Integer)

Create a 'full' convolution matrix for zero end conditions.
Output signal length is M = N + K - 1, where K is the length of psf.

# Arguments
- `psf`: Point spread function (filter impulse response)
- `N`: Length of the input signal

# Returns
- The full convolution matrix as a Matrix{Int}

# Notes
The 'full' convolution includes all points where the shifted impulse 
response overlaps with the input signal, including at the edges.
This results in a matrix with more rows than columns.
"""
function create_convolution_matrix_full(psf::Vector{<:Number}, N::Integer)
    # Create a linear map that performs convolution
    K = length(psf)
    Az = LinearMapAA(x -> conv(x, psf), (N+K-1, N))
    
    # Convert to matrix and round to integers
    Az = Matrix(Az)
    Az = round.(Int, Az)  # because `conv` apparently uses `fft`
    
    return Az
end

"""
    create_convolution_matrix_circ(psf::Vector{<:Number}, N::Integer)

Create a 'circ' (circular) convolution matrix for periodic end conditions.
Output signal length is M = N.

# Arguments
- `psf`: Point spread function (filter impulse response)
- `N`: Length of the input signal

# Returns
- The circular convolution matrix as a Matrix{Int}

# Notes
The 'circ' mode treats the signal as periodic, wrapping around at the edges.
This is efficiently implemented using FFTs, as convolution in time domain
equals multiplication in frequency domain. The resulting matrix is square.
"""
function create_convolution_matrix_circ(psf::Vector{<:Number}, N::Integer)
    # Create kernel with FFTView
    K = length(psf)
    hp = Int((K-1)/2)  # half width
    
    # Create the FFT kernel
    kernel = FFTView(zeros(Int, N))
    kernel[-hp:hp] = psf
    
    # Create circular convolution as linear map using FFT
    Ac = LinearMapAA(x -> ifft(fft(x) .* fft(kernel)), (N,N); T = ComplexF64)
    
    # Convert to matrix, take real part and round to integers
    Ac = Matrix(Ac)
    Ac = round.(Int, real(Ac))
    
    return Ac
end

"""
    create_convolution_matrix_same(psf::Vector{<:Number}, N::Integer)

Create a 'same' convolution matrix where output length matches input length.
Output signal length is M = N.

# Arguments
- `psf`: Point spread function (filter impulse response)
- `N`: Length of the input signal

# Returns
- The 'same' convolution matrix as a Matrix{Int}

# Notes
The 'same' convolution returns an output with the same length as the input.
It is derived from the 'full' convolution by keeping only the central portion.
This is typically used in deep learning when you want feature maps to
maintain the same dimensions as the input.
"""
function create_convolution_matrix_same(psf::Vector{<:Number}, N::Integer)
    # First create the full convolution matrix
    Az = create_convolution_matrix_full(psf, N)
    
    # Extract the central part
    K = length(psf)
    hp = Int((K-1)/2)  # half width
    As = Az[hp .+ (1:N),:]
    
    return As
end

"""
    create_convolution_matrix_valid(psf::Vector{<:Number}, N::Integer)

Create a 'valid' convolution matrix where output includes only fully overlapped positions.
Output signal length is M = N - K + 1, where K is the length of psf.

# Arguments
- `psf`: Point spread function (filter impulse response)
- `N`: Length of the input signal

# Returns
- The 'valid' convolution matrix as a Matrix{Int}

# Notes
The 'valid' convolution includes only positions where the filter
completely overlaps with the input signal (no padding at edges).
The output is shorter than the input, containing only "fully valid" 
convolution results. This is useful when you want to ensure all output
values are computed from complete data without artificial padding.
"""
function create_convolution_matrix_valid(psf::Vector{<:Number}, N::Integer)
    # First create the full convolution matrix
    Az = create_convolution_matrix_full(psf, N)
    
    # Extract the valid part
    K = length(psf)
    Av = Az[(K-1) .+ (1:(N-(K-1))),:]
    
    return Av
end

"""
    create_all_convolution_matrices(psf::Vector{<:Number}, N::Integer)

Create all four types of convolution matrices: 'full', 'circ', 'same', and 'valid'.

# Arguments
- `psf`: Point spread function (filter impulse response)
- `N`: Length of the input signal

# Returns
- A tuple (Az, Ac, As, Av) containing all four convolution matrices
"""
function create_all_convolution_matrices(psf::Vector{<:Number}, N::Integer)
    Az = create_convolution_matrix_full(psf, N)
    Ac = create_convolution_matrix_circ(psf, N)
    As = create_convolution_matrix_same(psf, N)
    Av = create_convolution_matrix_valid(psf, N)
    
    return (Az, Ac, As, Av)
end

# Export the functions
export create_convolution_matrix_full
export create_convolution_matrix_circ
export create_convolution_matrix_same
export create_convolution_matrix_valid
export create_all_convolution_matrices 