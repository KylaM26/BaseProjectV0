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
    float4 position  [[ attribute(Position) ]];
    float3 normal    [[ attribute(Normal)  ]];
    float2 uv        [[ attribute(UV) ]];
};

struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 worldNormal;
    float2 uv;
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]], constant Uniforms &uniforms [[ buffer(UniformBufferIndex) ]]) {
    
    VertexOut out {
        .position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position,
        
        // Here, you convert the vertex position and normal to world space.
        .worldPosition = (uniforms.modelMatrix * vertex_in.position).xyz,
        .worldNormal = uniforms.normalMatrix * vertex_in.normal, // The order of this matter
        
        .uv = vertex_in.uv,
    };
    
    return out;
}


fragment float4 fragment_main(const VertexOut vertex_out [[ stage_in ]],

                              constant FragmentUniforms &fragmentUniforms [[ buffer(FragmentBufferIndex) ]],

                              constant Light *lights [[ buffer(LightsBufferIndex) ]],

                              texture2d<float> baseColorTexture [[ texture(DiffuseTexture) ]],
                              texture2d<float> roughnessTexture [[ texture(RoughnessTexture) ]],
                              texture2d<float> normalTexture    [[ texture(NormalTexture)]],

                              sampler textureSampler [[ sampler(0) ]])
{

    float3 color = 0;

    float3 ambientColor = 0;
    float3 diffuseColor = 0;
    float3 specularColor = 0;

    float materialShininess = 32;
    float3 materialSpecularColor = float3(1, 1, 1);

    float3 baseColor = baseColorTexture.sample(textureSampler, vertex_out.uv * fragmentUniforms.tiling).rgb;

    float3 normalDirection = normalize(vertex_out.worldNormal);

    for(uint index = 0; index < fragmentUniforms.lightCount; index++) {
        Light light = lights[index];

        if (light.type == Sunlight) {
            float3 lightDirection = normalize(-light.position);
            float diffuseIntensity = saturate(-dot(lightDirection, normalDirection));
            diffuseColor += light.color * baseColor * diffuseIntensity;

            if(diffuseIntensity > 0) {
                float3 reflection = reflect(lightDirection, normalDirection);
                float3 cameraDirection = normalize(vertex_out.worldPosition - fragmentUniforms.cameraPosition);
                float specularIntensity = pow(saturate(-dot(reflection, cameraDirection)), materialShininess);
                specularColor += light.specularColor * materialSpecularColor * specularIntensity;

            }
        } else if (light.type == Ambientlight) {
            ambientColor += light.color * light.intensity;
        }

    }

    color = diffuseColor + ambientColor + specularColor;

    return float4(color, 1);

//    float3 baseColor = float3(1, 1, 1);
//      float3 diffuseColor = 0;
//      // 2
//      float3 normalDirection = normalize(vertex_out.worldNormal);
//      for (uint i = 0; i < fragmentUniforms.lightCount; i++) {
//        Light light = lights[i];
//        if (light.type == Sunlight) {
//          float3 lightDirection = normalize(-light.position);
//          // 3
//          float diffuseIntensity =
//                  saturate(-dot(lightDirection, normalDirection));
//          // 4
//          diffuseColor += light.color
//                            * baseColor * diffuseIntensity;
//            
//            if(diffuseIntensity > 0) {
//                float3 reflection = reflect(lightDirection, normalDirection);
//                float3 cameraDirection = normalize(vertex_out.worldPosition - fragmentUniforms.cameraPosition);
//                float specularIntensity = pow(saturate(-dot(reflection, cameraDirection)), materialShininess);
//                specularColor += light.specularColor * materialSpecularColor * specularIntensity;
//                
//            }
//        }
//      }
//      // 5
//      float3 color = diffuseColor;
//      return float4(color, 1);
}

