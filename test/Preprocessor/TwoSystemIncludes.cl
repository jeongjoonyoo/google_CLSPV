// RUN: clspv -I %S/SomeIncludeDirectory -I %S/AnotherIncludeDirectory %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK: ; SPIR-V
// CHECK: ; Version: 1.0
// CHECK: ; Bound: 7
// CHECK: ; Schema: 0
// CHECK: OpCapability Shader
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpEntryPoint GLCompute %[[BAR_ID:[a-zA-Z0-9_]*]] "bar"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 4 2 1
// CHECK: OpExecutionMode %[[BAR_ID]] LocalSize 5 3 2
// CHECK-DAG: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK-DAG: %[[FUNC_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]

// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] Const %[[FUNC_TYPE_ID]]
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
// CHECK: OpReturn
// CHECK: OpFunctionEnd

#include <SomeHeader.h>

// CHECK: %[[BAR_ID]] = OpFunction %[[VOID_TYPE_ID]] Const %[[FUNC_TYPE_ID]]
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
// CHECK: OpReturn
// CHECK: OpFunctionEnd

#include <AnotherHeader.h>
