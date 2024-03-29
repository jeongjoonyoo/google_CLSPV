# Copyright 2017 The Clspv Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set(SPIRV_C_STRINGS_INPUT_FILE ${SPIRV_HEADERS_SOURCE_DIR}/include/spirv/1.0/spirv.hpp)
set(SPIRV_C_STRINGS_OUTPUT_FILE ${CLSPV_BINARY_DIR}/include/clspv/spirv_c_strings.hpp)
set(SPIRV_C_STRINGS_NAMESPACE spv)
set(SPIRV_C_STRINGS_PYTHON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/spirv_c_strings.py)

file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/include/clspv")

add_custom_target(clspv_c_strings
  DEPENDS ${SPIRV_C_STRINGS_OUTPUT_FILE})

add_custom_command(
  OUTPUT ${SPIRV_C_STRINGS_OUTPUT_FILE}
  COMMAND ${PYTHON_EXECUTABLE} ${SPIRV_C_STRINGS_PYTHON_FILE}
    --input-file=${SPIRV_C_STRINGS_INPUT_FILE}
    --output-file=${SPIRV_C_STRINGS_OUTPUT_FILE}
    --namespace=${SPIRV_C_STRINGS_NAMESPACE}
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  DEPENDS ${SPIRV_C_STRINGS_INPUT_FILE} ${SPIRV_C_STRINGS_PYTHON_FILE})

set(STRIP_BANNED_OPENCL_FEATURES_INPUT_FILE ${CLANG_SOURCE_DIR}/lib/Headers/opencl-c.h)
set(STRIP_BANNED_OPENCL_FEATURES_OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/opencl-c_reduced.h)
set(STRIP_BANNED_OPENCL_FEATURES_PYTHON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/strip_banned_opencl_features.py)

add_custom_command(OUTPUT ${STRIP_BANNED_OPENCL_FEATURES_OUTPUT_FILE}
  COMMAND ${PYTHON_EXECUTABLE} ${STRIP_BANNED_OPENCL_FEATURES_PYTHON_FILE}
    --input-file=${STRIP_BANNED_OPENCL_FEATURES_INPUT_FILE}
    --output-file=${STRIP_BANNED_OPENCL_FEATURES_OUTPUT_FILE}
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  DEPENDS ${STRIP_BANNED_OPENCL_FEATURES_INPUT_FILE} ${STRIP_BANNED_OPENCL_FEATURES_PYTHON_FILE}
)

set(BAKE_FILE_INPUT_FILE ${STRIP_BANNED_OPENCL_FEATURES_OUTPUT_FILE})
set(BAKE_FILE_OUTPUT_FILE ${CLSPV_BINARY_DIR}/include/clspv/opencl_builtins_header.h)
set(BAKE_FILE_BASE_HEADER_FILE ${CLANG_SOURCE_DIR}/lib/Headers/opencl-c-base.h)
set(BAKE_FILE_DATA_VARIABLE_NAME opencl_builtins_header_data)
set(BAKE_FILE_SIZE_VARIABLE_NAME opencl_builtins_header_size)
set(BAKE_FILE_DATA_BASE_VARIABLE_NAME opencl_base_builtins_header_data)
set(BAKE_FILE_SIZE_BASE_VARIABLE_NAME opencl_base_builtins_header_size)
set(BAKE_FILE_PYTHON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bake_file.py)

add_custom_command(OUTPUT ${BAKE_FILE_OUTPUT_FILE}
  COMMAND ${PYTHON_EXECUTABLE} ${BAKE_FILE_PYTHON_FILE}
    --input-header-file=${BAKE_FILE_INPUT_FILE}
    --input-base-file=${BAKE_FILE_BASE_HEADER_FILE}
    --output-file=${BAKE_FILE_OUTPUT_FILE}
    --header-var=${BAKE_FILE_DATA_VARIABLE_NAME}
    --header-size-var=${BAKE_FILE_SIZE_VARIABLE_NAME}
    --base-var=${BAKE_FILE_DATA_BASE_VARIABLE_NAME}
    --base-size-var=${BAKE_FILE_SIZE_BASE_VARIABLE_NAME}
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  DEPENDS ${BAKE_FILE_INPUT_FILE} ${BAKE_FILE_PYTHON_FILE}
)

add_custom_target(clspv_baked_opencl_header
  DEPENDS ${STRIP_BANNED_OPENCL_FEATURES_OUTPUT_FILE} ${BAKE_FILE_OUTPUT_FILE}
)

set(SPIRV_GLSL_INPUT_FILE ${SPIRV_HEADERS_SOURCE_DIR}/include/spirv/1.0/extinst.glsl.std.450.grammar.json)
set(SPIRV_GLSL_OUTPUT_FILE ${CLSPV_BINARY_DIR}/include/clspv/spirv_glsl.hpp)
set(SSPIRV_GLSL_PYTHON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/spirv_glsl.py)

add_custom_target(clspv_glsl
  DEPENDS ${SPIRV_GLSL_OUTPUT_FILE})

add_custom_command(
  OUTPUT ${SPIRV_GLSL_OUTPUT_FILE}
  COMMAND ${PYTHON_EXECUTABLE} ${SSPIRV_GLSL_PYTHON_FILE}
    --input-file=${SPIRV_GLSL_INPUT_FILE}
    --output-file=${SPIRV_GLSL_OUTPUT_FILE}
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  DEPENDS ${SPIRV_GLSL_INPUT_FILE} ${SSPIRV_GLSL_CMAKE_FILE})
