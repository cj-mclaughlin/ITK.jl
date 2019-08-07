using ITK
using Test

@testset "Sanity Check" begin
    @test ITK.verifycxx(0) == 0
    @test ITK.verifycxx(100) == 100
end
