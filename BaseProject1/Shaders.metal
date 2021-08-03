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
    float3 normal   [[  attribute(Normal)  ]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]], constant Uniforms &uniforms [[ buffer(UniformBufferIndex) ]]) {
    
    VertexOut out {
        .position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position,
        .normal = vertex_in.normal
    };
    
    return out;
}

fragment float4 fragment_main(const VertexOut vertex_out [[ stage_in ]]) {
    return float4(vertex_out.normal, 1);
}

