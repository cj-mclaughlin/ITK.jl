using ITK
using Test

@testset "Sanity Check" begin
    @test verifycxx(0) == 0
    @test verifycxx(100) == 100
end
