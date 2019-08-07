# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    println("Deps path: $depsjl_path")
    error("FFMPEG not installed properly, run `] build FFMPEG`, restart Julia and try again")
end

include(depsjl_path)
