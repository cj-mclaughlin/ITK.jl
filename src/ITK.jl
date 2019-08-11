module ITK
using Cxx, Libdl

#if !isfile(wrapjl_path)
#    error("ITK not properly installed. Run `] build ITK`, restart Julia and try again")
#end

include("init.jl")

function __init__()
    loadcxx(libitk, dirname(libitk))
end

# Loads shared library and header file
function loadcxx(libpath::String=libitk, headerdir::String=dirname(libitk))
    addHeaderDir(headerdir, kind=C_System)
    Libdl.dlopen(libpath, Libdl.RTLD_GLOBAL)
    cxxinclude("JuliaWrap.h")
end

# Sanity check. Returns x if able to read C++ files
function verifycxx(x::Int)
    sanity_check(n::Int) = @cxx sanity(n)
    return sanity_check(x)
end

# Initial registration test method - performs translation registration with MattesMutualInformation Metric, and specified optimizer.
# fixedImage -> String path of fixed image file
# movingImage -> String path of moving image file
# outputImage -> String path of desired output image file (can be blank if writeImage=false)
# writeImage -> Boolean, whether or not to save resulting registered image. Default=true.
# optimizer -> String, "Gradient" | "Amoeba". Default="Gradient"
# Return: (x translation, y translation, metric info)
function registerframe(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool=true, optimizer::String="Gradient")
    register_amoeba_optimizer(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool) = @cxx test_registration1(fix, moving, output, write)
    register_gradient_optimizer(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool) = @cxx test_registration2(fix, moving, output, write)
    if optimizer == "Amoeba"
        result = register_amoeba_optimizer(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage)
    else
        result = register_gradient_optimizer(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage)
    end
    x, y, metric = unsafe_load(result,1), unsafe_load(result,2), unsafe_load(result,3)
    return x, y, metric
end

# Another registration method using MattesMutualInformation metric, with Gradient Descent optimizer with specified parameters.
# fixedImage -> String path of fixed image file
# movingImage -> String path of moving image file
# outputImage -> String path of desired output image file (can be blank if writeImage=false)
# writeImage -> Boolean, whether or not to save resulting registered image. 
# learningRate -> Recommended values [1:5], higher values result in quicker but less stable registration
# minStepLength -> Recommended values [0.05], higher values result in quicker but less stable registration
# maxIterations -> Recommended values [100:200], threshold number of iterations before returning translation
# relaxationFactor -> Recommended values [~0.5], factor used to slow down shifts between iterations, higher values result in quicker but potentially divergent registration
function MMIGradientRegistration(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool, learningRate::Float64, minStepLength::Float64, maxIterations::Int64, relaxationFactor::Float64)
    register(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool, LR::Float64, minStep::Float64, maxIter::Int64, relaxFactor::Float64) = @cxx MMIGradientTranslation(fix, moving, output, write, LR, minStep, maxIter, relaxFactor)
    result = register(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage, learningRate, minStepLength, maxIterations, relaxationFactor)
    x, y, metric = unsafe_load(result, 1), unsafe_load(result, 2), unsafe_load(result, 3)
    return x, y, metric
end

# Another registration method using MattesMutualInformation metric, with Amoeba optimizer with specified parameters.
# fixedImage -> String path of fixed image file
# movingImage -> String path of moving image file
# outputImage -> String path of desired output image file (can be blank if writeImage=false)
# writeImage -> Boolean, whether or not to save resulting registered image.
# initialSimplex -> Recommended values [5.0], initial size of simplex moving over cost surface 
# pixelTolerance -> Optimizer convergence tolerance, pixels
# metricTolerance -> Optimizer function convergence tolerance, bits
# maxIterations -> maximum number of iterations
function MMIAmoebaRegistration(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool, initialSimplex::Float64, pixelTolerance::Float64, metricTolerance::Float64, maxIterations::Int64)
    register(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool, simplex::Float64, pixelT::Float64, metricT::Float64, maxIter::Int64) = @cxx MMIAmoebaTranslation(fix, moving, output, write, simplex, pixelT, metricT, maxIter)
    result = register(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage, initialSimplex, pixelTolerance, metricTolerance, maxIterations)
    x, y, metric = unsafe_load(result, 1), unsafe_load(result, 2), unsafe_load(result, 3)
    return x, y, metric
end

# Another registration method using MattesMutualInformation metric, with 1+1 Evolutionary optimizer with specified parameters.
# fixedImage -> String path of fixed image file
# movingImage -> String path of moving image file
# outputImage -> String path of desired output image file (can be blank if writeImage=false)
# writeImage -> Boolean, whether or not to save resulting registered image. 
function MMIOnePlusOneRegistration(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool, initialize::Float64, epsilon::Float64, maxIterations::Int64)
    register(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool, init::Float64, ep::Float64, maxIter::Int64) = @cxx MMIOnePlusOneTranslation(fix, moving, output, write, init, ep, maxIter)
    result = register(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage, initialSimplex, pixelTolerance, metricTolerance, maxIterations)
    x, y, metric = unsafe_load(result, 1), unsafe_load(result, 2), unsafe_load(result, 3)
    return x, y, metric
end

# Another registration method using Mean Squares metric, with Gradient Descent optimizer with specified parameters.
# fixedImage -> String path of fixed image file
# movingImage -> String path of moving image file
# outputImage -> String path of desired output image file (can be blank if writeImage=false)
# writeImage -> Boolean, whether or not to save resulting registered image. 
# learningRate -> Recommended values [1:5], higher values result in quicker but less stable registration
# minStepLength -> Recommended values [0.05], higher values result in quicker but less stable registration
# maxIterations -> Recommended values [100:200], threshold number of iterations before returning translation
# relaxationFactor -> Recommended values [~0.5], factor used to slow down shifts between iterations, higher values result in quicker but potentially divergent registration
function MeanSquaresGradientRegistration(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool, learningRate::Float64, minStepLength::Float64, maxIterations::Int64, relaxationFactor::Float64)
    register(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool, LR::Float64, minStep::Float64, maxIter::Int64, relaxFactor::Float64) = @cxx MeanSquaresGradientTranslation(fix, moving, output, write, LR, minStep, maxIter, relaxFactor)
    result = register(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage, learningRate, minStepLength, maxIterations, relaxationFactor)
    x, y, metric = unsafe_load(result, 1), unsafe_load(result, 2), unsafe_load(result, 3)
    return x, y, metric
end

export registerframe
export MMIGradientRegistration
export MMIAmoebaRegistration
export MMIOnePlusOneRegistration
export MeanSquaresGradientRegistration

end # module ITK
