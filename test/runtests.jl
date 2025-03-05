using Test
using ConvolutionMatrix

@testset "ConvolutionMatrix Tests" begin
    # sprint(greet) calls greet(io::IOBuffer) behind the scenes
    result = sprint(ConvolutionMatrix.greet)
    @test result == "Hello World!"
end
