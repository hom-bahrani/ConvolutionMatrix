using Test
using ProjectStarter

@testset "ProjectStarter Tests" begin
    # sprint(greet) calls greet(io::IOBuffer) behind the scenes
    result = sprint(ProjectStarter.greet)
    @test result == "Hello World!"
end
