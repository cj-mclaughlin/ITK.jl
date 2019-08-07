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

# Initial registration test method - performs translation registration with MattesMutualInformation Metric and Amoeba Optimizer.
# Takes in paths to a fixed and moving image, as well as the location to save the resulting image.
# Also returns a double array containing the x and y translation information, as well as the metric value generated.
function registerframe(fixedImage::String, movingImage::String, outputImage::String)
    register_frame(fix::Ptr{UInt8}, moving::Ptr{UInt8}, output::Ptr{UInt8}) = @cxx test_registration(fix, moving, output)
    result = register_frame(pointer(fixedImage), pointer(movingImage), pointer(outputImage))
    x, y, metric = unsafe_load(result,1), unsafe_load(result,2), unsafe_load(result,3)
    return x, y, metric
end

export registerframe

end # module ITK
