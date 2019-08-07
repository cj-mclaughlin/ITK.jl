### Dev Build Instructions

ITK.jl makes use of a shared library (.so) and header file based from ITK.

If you want to install the base ITK C++ library, see [here](https://itk.org/Wiki/Getting_Started_Build/Linux).

To build the shared libraries for a ITK C++ file, see the makefile below.

```
cmake_minimum_required(VERSION 2.8)

project(ITKLib)

set(USE_ITK_MODULES ITKCommon ITKIOImageBase ITKOptimizers ITKRegistrationCommon ITKTransform ITKImageIO )

# Find ITK.
find_package(ITK COMPONENTS ${USE_ITK_MODULES})
include(${ITK_USE_FILE})

# Replace with desired name and your own C++ file name
add_library(JuliaCxx SHARED JuliaCxx.cxx)
target_link_libraries(JuliaCxx ${ITK_LIBRARIES})
```
