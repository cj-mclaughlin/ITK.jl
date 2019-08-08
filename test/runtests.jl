using ITK
using Test
#using TestImages

@testset "Sanity Check" begin
    @test ITK.verifycxx(0) == 0
    @test ITK.verifycxx(100) == 100
end

# @testset "Registration Control Check" begin
#    testimage_path = string(joinpath(dirname(dirname(pathof(TestImages)))), "/images")
#     lighthouse_path = joinpath(testimg_path, "lighthouse.png")

#     amoeba_control = ITK.registerframe(lighthouse_path, lighthouse_path, "NA", false, "Amoeba")
#     gradient_control = ITK.registerframe(lighthouse_path, lighthouse_path, "NA", false, "Gradient")

#     @test (amoeba_control[1], amoeba_control[2]) == (0, 0)
#     @test (gradient_control[1], gradient_control[2]) == (0, 0)
# end
