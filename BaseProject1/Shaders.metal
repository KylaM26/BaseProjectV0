//
//  Shaders.metal
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[ attribute(0) ]];
};

vertex float4 vertex_main(VertexIn vertex_in [[ stage_in ]]) {
    return float4(vertex_in.position, 1);
}

fragment float4 fragment_main() {
    return float4(0.5, 0.1, 0.3, 1);
}

