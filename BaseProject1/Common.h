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
    UniformBufferIndex = 11
} BufferIndices;

typedef enum {
    Position = 0,
    Normal = 1
} Attributes;

typedef struct {
    matrix_float4x4 viewMatrix;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

#endif /* Common_h */
