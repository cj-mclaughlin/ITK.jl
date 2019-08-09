# ITK.jl

[![Build Status](https://travis-ci.com/cj-mclaughlin/ITK.jl.svg?branch=master)](https://travis-ci.com/cj-mclaughlin/ITK.jl)
[![Codecov](https://codecov.io/gh/cj-mclaughlin/ITK.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/cj-mclaughlin/ITK.jl)

## Install
```
]add https://github.com/cj-mclaughlin/ITK.jl
using ITK
```

## Current Development Notes
There is currently one working image registration function, which performs translation registration with Mattes Mutual Information metric, and either an Amoeba optimizer or a Gradient Descent optimizer. I am currently working on a more parameterized set registration functions, as well as the ability to register images saved in memory as Julia arrays, as opposed to only images saved to disk.

## Docs
Currently unavailable. For now, see comments on source wrappers at src/ITK.jl.

## Build Issues
Currently working on Ubuntu 18.04. Looking to compile for backwards and multi-platform in the future.