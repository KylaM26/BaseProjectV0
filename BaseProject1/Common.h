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
    FragmentBufferIndex = 12,
    LightsBufferIndex = 13,
    MaterialBufferIndex = 14
} BufferIndices;

typedef enum {
    Position = 0,
    Normal = 1,
    UV = 2,
    Tangent = 3,
    Bitangent = 4,
} Attributes;

typedef enum {
    DiffuseTexture = 0,
    NormalTexture = 1,
    RoughnessTexture = 2
} Materials;

typedef struct {
    matrix_float3x3 normalMatrix;
    
    matrix_float4x4 viewMatrix;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef enum {
    unused = 0,
    Sunlight = 1,
    Spotlight = 2,
    Pointlight = 3,
    Ambientlight = 4
} LightType;

typedef struct {
    float intensity;
    
    vector_float3 position;
    vector_float3 color;
    vector_float3 specularColor;
    vector_float3 attenuation;
    
    LightType type;
} Light;

typedef struct {
    vector_float3 diffuse;
    vector_float3 ambientOcclusion;
    vector_float3 specularColor;
    
    float shininess;
    float roughness;
    float metallic;
    
    
} Material;

typedef struct {
    uint tiling;
    uint lightCount;
    
    vector_float3 cameraPosition;
} FragmentUniforms;

#endif /* Common_h */
