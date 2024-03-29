// RUN: clspv  %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK:     ; SPIR-V
// CHECK:     ; Version: 1.0
// CHECK:     ; Bound: 28
// CHECK:     ; Schema: 0
// CHECK-DAG: OpCapability Shader
// CHECK:     OpExtension "SPV_KHR_storage_buffer_storage_class"
// CHECK:     OpMemoryModel Logical GLSL450
// CHECK:     OpEntryPoint GLCompute %[[__original_id_18:[0-9]+]] "foo"
// CHECK:     OpExecutionMode %[[__original_id_18]] LocalSize 1 1 1
// CHECK:     OpSource OpenCL_C 120
// CHECK:     OpDecorate %[[_runtimearr_float:[0-9a-zA-Z_]+]] ArrayStride 4
// CHECK:     OpMemberDecorate %[[_struct_3:[0-9a-zA-Z_]+]] 0 Offset 0
// CHECK:     OpDecorate %[[_struct_3]] Block
// CHECK:     OpDecorate %[[_runtimearr_uint:[0-9a-zA-Z_]+]] ArrayStride 4
// CHECK:     OpMemberDecorate %[[_struct_7:[0-9a-zA-Z_]+]] 0 Offset 0
// CHECK:     OpDecorate %[[_struct_7]] Block
// CHECK:     OpDecorate %[[__original_id_15:[0-9]+]] DescriptorSet 0
// CHECK:     OpDecorate %[[__original_id_15]] Binding 0
// CHECK:     OpDecorate %[[__original_id_16:[0-9]+]] DescriptorSet 0
// CHECK:     OpDecorate %[[__original_id_16]] Binding 1
// CHECK:     OpDecorate %[[__original_id_17:[0-9]+]] DescriptorSet 0
// CHECK:     OpDecorate %[[__original_id_17]] Binding 2
// CHECK-DAG: %[[float:[0-9a-zA-Z_]+]] = OpTypeFloat 32
// CHECK-DAG: %[[_runtimearr_float]] = OpTypeRuntimeArray %[[float]]
// CHECK-DAG: %[[_struct_3]] = OpTypeStruct %[[_runtimearr_float]]
// CHECK-DAG: %[[_ptr_StorageBuffer__struct_3:[0-9a-zA-Z_]+]] = OpTypePointer StorageBuffer %[[_struct_3]]
// CHECK-DAG: %[[uint:[0-9a-zA-Z_]+]] = OpTypeInt 32 0
// CHECK-DAG: %[[_runtimearr_uint]] = OpTypeRuntimeArray %[[uint]]
// CHECK-DAG: %[[_struct_7]] = OpTypeStruct %[[_runtimearr_uint]]
// CHECK-DAG: %[[_ptr_StorageBuffer__struct_7:[0-9a-zA-Z_]+]] = OpTypePointer StorageBuffer %[[_struct_7]]
// CHECK-DAG: %[[void:[0-9a-zA-Z_]+]] = OpTypeVoid
// CHECK-DAG: %[[__original_id_10:[0-9]+]] = OpTypeFunction %[[void]]
// CHECK-DAG: %[[_ptr_StorageBuffer_float:[0-9a-zA-Z_]+]] = OpTypePointer StorageBuffer %[[float]]
// CHECK-DAG: %[[_ptr_StorageBuffer_uint:[0-9a-zA-Z_]+]] = OpTypePointer StorageBuffer %[[uint]]
// CHECK-DAG: %[[bool:[0-9a-zA-Z_]+]] = OpTypeBool
// CHECK-DAG: %[[uint_0:[0-9a-zA-Z_]+]] = OpConstant %[[uint]] 0
// CHECK-DAG: %[[__original_id_15]] = OpVariable %[[_ptr_StorageBuffer__struct_3]] StorageBuffer
// CHECK-DAG: %[[__original_id_16]] = OpVariable %[[_ptr_StorageBuffer__struct_3]] StorageBuffer
// CHECK-DAG: %[[__original_id_17]] = OpVariable %[[_ptr_StorageBuffer__struct_7]] StorageBuffer
// CHECK:     %[[__original_id_18]] = OpFunction %[[void]] None %[[__original_id_10]]
// CHECK:     %[[__original_id_19:[0-9]+]] = OpLabel
// CHECK:     %[[__original_id_20:[0-9]+]] = OpAccessChain %[[_ptr_StorageBuffer_float]] %[[__original_id_15]] %[[uint_0]] %[[uint_0]]
// CHECK:     %[[__original_id_21:[0-9]+]] = OpAccessChain %[[_ptr_StorageBuffer_float]] %[[__original_id_16]] %[[uint_0]] %[[uint_0]]
// CHECK:     %[[__original_id_22:[0-9]+]] = OpAccessChain %[[_ptr_StorageBuffer_uint]] %[[__original_id_17]] %[[uint_0]] %[[uint_0]]
// CHECK:     %[[__original_id_23:[0-9]+]] = OpLoad %[[float]] %[[__original_id_20]]
// CHECK:     %[[__original_id_24:[0-9]+]] = OpLoad %[[float]] %[[__original_id_21]]
// CHECK:     %[[__original_id_25:[0-9]+]] = OpLoad %[[uint]] %[[__original_id_22]]
// CHECK:     %[[__original_id_26:[0-9]+]] = OpIEqual %[[bool]] %[[__original_id_25]] %[[uint_0]]
// CHECK:     %[[__original_id_27:[0-9]+]] = OpSelect %[[float]] %[[__original_id_26]] %[[__original_id_23]] %[[__original_id_24]]
// CHECK:     OpStore %[[__original_id_20]] %[[__original_id_27]]
// CHECK:     OpReturn
// CHECK:     OpFunctionEnd


kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* a, global float* b, global uint* c)
{
    *a = select(*a, *b, *c);
}

