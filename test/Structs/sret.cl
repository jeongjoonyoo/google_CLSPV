// RUN: clspv %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK: ; SPIR-V
// CHECK: ; Version: 1.0
// CHECK: ; Bound: 5
// CHECK: ; Schema: 0
// CHECK: OpCapability Shader
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 1 1 1
// CHECK-NOT: OpMemberDecorate
// CHECK-NOT: OpTypeStruct
// CHECK-DAG: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK-DAG: %[[FOO_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]
// CHECK-NOT: OpUndef

struct test {
  int a;
  int b;
  int c;
  int d;
};

struct test boo(void) {
  struct test sret;
  return sret;
}

// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] Const %[[FOO_TYPE_ID]]
// CHECK: %[[FOO_LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
// CHECK:         OpReturn
// CHECK:         OpFunctionEnd

void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(void) {
  boo();
}
