module ITK
using Cxx, Libdl

const wrapjl_path = joinpath(@__DIR__, "..", "gen", "wrap.jl")

#if !isfile(wrapjl_path)
#    error("ITK not properly installed. Run `] build ITK`, restart Julia and try again")
#end
include(wrapjl_path)

const sharedlib_path = joinpath(@__DIR__, "..", "gen", "libJuliaCxx.so")
const header_dir = joinpath(@__DIR__, "..", "gen")
function __init__()
    loadcxx(sharedlib_path, header_dir)
end

end # module ITK
