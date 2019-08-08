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
    register_gradient_optimizer(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool) = @cxx test_registration1(fix, moving, output, write)
    register_amoeba_optimizer(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}, write::Bool) = @cxx test_registration1(fix, moving, output, write)
    if optimizer == "Amoeba"
        result = register_amoeba_optimizer(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage)
    else
        result = register_gradient_optimizer(pointer(fixedImage), pointer(movingImage), pointer(outputImage), writeImage)
    end
    x, y, metric = unsafe_load(result,1), unsafe_load(result,2), unsafe_load(result,3)
    return x, y, metric
end

export registerframe

end # module ITK
