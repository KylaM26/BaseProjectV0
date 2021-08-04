//
//  Common.h
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef enum {
    VertexBufferIndex = 0,
    UniformBufferIndex = 11,
    FragmentBufferIndex = 12
} BufferIndices;

typedef enum {
    Position = 0,
    Normal = 1,
    UV = 2
} Attributes;

typedef enum {
    DiffuseTexture = 0,
    RoughnessTexture = 1
} Materials;

typedef struct {
    matrix_float4x4 viewMatrix;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint tiling;
}FragmentUniforms;

#endif /* Common_h */
