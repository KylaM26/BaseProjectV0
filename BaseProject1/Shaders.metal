//
//  Shaders.metal
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

#include <metal_stdlib>
using namespace metal;

#import "Common.h"

struct VertexIn {
    float4 position [[ attribute(Position) ]];
    float3 normal   [[ attribute(Normal)  ]];
    float2 uv       [[ attribute(UV) ]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]], constant Uniforms &uniforms [[ buffer(UniformBufferIndex) ]]) {
    
    VertexOut out {
        .position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position,
        .normal = vertex_in.normal,
        .uv = vertex_in.uv
    };
    
    return out;
}

fragment float4 fragment_main(const VertexOut vertex_out [[ stage_in ]], texture2d<float> baseColorTexture [[ texture(DiffuseTexture) ]], texture2d<float> roughnessTexture [[ texture(RoughnessTexture) ]], constant FragmentUniforms &fragmentUniforms [[ buffer(FragmentBufferIndex) ]], sampler textureSampler [[ sampler(0) ]]) {

    float3 baseColor = baseColorTexture.sample(textureSampler, vertex_out.uv * fragmentUniforms.tiling).rgb;
    
    return float4(baseColor, 1);
}

