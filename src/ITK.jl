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
function MMIGradientRegistration(fixedImage::String, movingImage::String, outputImage::String, writeImage::Bool, learningRate::Float, minStepLength::Float, maxIterations::Int, relaxationFactor::Float)
    register(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool, LR::Float, minStep::Float, maxIter::Int, relaxFactor::Float) = @cxx experimental(fix, moving, output, write, LR, minStep, maxIter, relaxFactor)
    result = register(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage, learningRate, minStep, maxIter, relaxFactor)
    x, y, metric = unsafe_load(result, 1), unsafe_load(result, 2), unsafe_load(result, 3)
    return x, y, metric
end

export registerframe
export MMIGradientRegistration

end # module ITK
