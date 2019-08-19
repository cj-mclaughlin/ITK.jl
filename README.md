# ITK.jl

[![Build Status](https://travis-ci.com/cj-mclaughlin/ITK.jl.svg?branch=master)](https://travis-ci.com/cj-mclaughlin/ITK.jl)
[![Codecov](https://codecov.io/gh/cj-mclaughlin/ITK.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/cj-mclaughlin/ITK.jl)

## Install
Currently working on Julia v1.1 and v1.2.
```
]add https://github.com/cj-mclaughlin/ITK.jl
using ITK
```

## Current Development Notes
There is currently four parameterized translation registration functions, and two simple test registration functions. Currently working on an option to pass in Julia image arrays, as opposed to only passing in paths to images saved on disk. If there are any specific functions that you would like ported to Julia, feel free to message me directly or write up an issue.

## Docs
All functions have verbose docstrings. See them at src/ITK.jl or through the Julia REPL by entering `?` followed by the function name.

## Platform Compatibility Issues
Tested on Ubuntu 16.04 as well as 18.04. Mac/Windows compatibility uncertain. Looking to compile backwards and multi-platform in the future.
