using ITK
using Test
using TestImages

# Test if we can load cxx
@testset "Sanity Check" begin
    @test ITK.verifycxx(0) == 0
    @test ITK.verifycxx(100) == 100
end

# Simple registration check on still image
@testset "Registration Control Check" begin
    testimage_path = string(joinpath(dirname(dirname(pathof(TestImages)))), "/images")
    lighthouse_path = joinpath(testimage_path, "lighthouse.png")

    testreg1 = ITK.registerframe(lighthouse_path, lighthouse_path, "NA", false, "Amoeba")
    testreg2 = ITK.MeanSquaresGradientRegistration(lighthouse_path, lighthouse_path, "NA", false, 5.0, 0.005, 30, 0.5)

    @test (testreg1[1], testreg1[2]) == (0, 0)
    @test (testreg2[1], testreg2[2]) == (0, 0)
end

# TODO registration test case on moving images