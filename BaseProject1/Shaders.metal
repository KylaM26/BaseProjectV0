//
//  Shaders.metal
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"

constant bool hasDiffuseTexture [[ function_constant(0) ]];
constant bool hasNormalTexture  [[ function_constant(1) ]];
constant bool hasRoughnessTexture  [[ function_constant(2) ]];


struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
    float3 tangent [[attribute(Tangent)]];
    float3 bitangent [[attribute(Bitangent)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 worldNormal;
    float2 uv;
    float3 worldTangent;
    float3 worldBitangent;
};

vertex VertexOut vertex_main(const VertexIn vertexIn [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformBufferIndex)]]) {
    VertexOut out {
        .position = uniforms.projectionMatrix * uniforms.viewMatrix
        * uniforms.modelMatrix * vertexIn.position,
        .worldPosition = (uniforms.modelMatrix * vertexIn.position).xyz,
        .worldNormal = uniforms.normalMatrix * vertexIn.normal,
        .uv = vertexIn.uv,
        .worldTangent =  uniforms.normalMatrix * vertexIn.tangent,
        .worldBitangent = uniforms.normalMatrix * vertexIn.bitangent
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              
                              texture2d<float> baseColorTexture [[texture(DiffuseTexture), function_constant(hasDiffuseTexture)]],
                              texture2d<float> normalTexture [[ texture(NormalTexture), function_constant(hasNormalTexture)]],
                              texture2d<float> roughnessTexture [[ texture(RoughnessTexture), function_constant(hasRoughnessTexture)]],
                              
                              constant Material &material [[ buffer(MaterialBufferIndex) ]],
                              
                              sampler textureSampler [[sampler(0)]],
                              
                              constant Light *lights [[buffer(LightsBufferIndex)]],
                              
                              constant FragmentUniforms &fragmentUniforms [[buffer(FragmentBufferIndex)]]) {
    
    float3 baseColor;
    if (hasDiffuseTexture) {
        baseColor = baseColorTexture.sample(textureSampler, in.uv * fragmentUniforms.tiling).rgb;
    } else {
        baseColor = material.diffuse;
    }
    
    
    float3 normalValue;
    if(hasNormalTexture) {
        normalValue = normalTexture.sample(textureSampler, in.uv * fragmentUniforms.tiling).xyz;
        normalValue = normalValue * 2 - 1;
    } else {
        normalValue = in.worldNormal;
    }
    
    float3 roughness;
    if(hasRoughnessTexture) {
        roughness = roughnessTexture.sample(textureSampler, in.uv * fragmentUniforms.tiling).rgb;
    } else {
        roughness = material.roughness;
    }
    
    normalValue = normalize(normalValue);
    
    float3 diffuseColor = 0;
    float3 ambientColor = 0;
    float3 specularColor = 0;
    
    
    
    float materialShininess = 64;
    float3 materialSpecularColor = float3(0.4, 0.4, 0.4);
    
    float3 normalDirection = float3x3(in.worldTangent, in.worldBitangent,  in.worldNormal) * normalValue;
    normalDirection = normalize(normalDirection);
    
    for (uint i = 0; i < fragmentUniforms.lightCount; i++) {
        
        Light light = lights[i];
        
        if (light.type == Sunlight) {
            
            float3 lightDirection = normalize(-light.position);
            
            float diffuseIntensity = saturate(-dot(lightDirection, normalDirection));
            
            diffuseColor += light.color * baseColor * diffuseIntensity;
            
            if (diffuseIntensity > 0) {
                float3 reflection = reflect(lightDirection, normalDirection);
                float3 cameraDirection = normalize(in.worldPosition - fragmentUniforms.cameraPosition);
                float specularIntensity = pow(saturate(-dot(reflection, cameraDirection)), materialShininess);
                specularColor += light.specularColor * materialSpecularColor * specularIntensity;
            }
        } else if (light.type == Ambientlight) {
            ambientColor += light.color * light.intensity;
        }
    }
    
    float3 color = saturate(diffuseColor + ambientColor + specularColor);
    return float4(color, 1);
}

//#include <metal_stdlib>
//using namespace metal;
//
//#import "Common.h"
//
//struct VertexIn {
//    float4 position  [[ attribute(Position) ]];
//    float3 normal    [[ attribute(Normal)  ]];
//    float2 uv        [[ attribute(UV) ]];
//    float3 tangent   [[ attribute(Tangent)  ]];
//    float3 bitangent [[ attribute(Bitangent) ]];
//};
//
//struct VertexOut {
//    float4 position [[position]];
//    float3 worldPosition;
//    float3 worldNormal;
//    float3 worldTangent;
//    float3 worldBitangent;
//    float2 uv;
//};
//
//vertex VertexOut vertex_main(const VertexIn vertex_in [[ stage_in ]], constant Uniforms &uniforms [[ buffer(UniformBufferIndex) ]]) {
//
//    VertexOut out {
//        .position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position,
//
//        // Here, you convert the vertex position and normal to world space.
//        .worldPosition = (uniforms.modelMatrix * vertex_in.position).xyz,
//        .worldNormal = uniforms.normalMatrix * vertex_in.normal, // The order of this matter
//
//        .worldTangent = uniforms.normalMatrix * vertex_in.tangent,
//        .worldBitangent = uniforms.normalMatrix * vertex_in.bitangent,
//
//        .uv = vertex_in.uv,
//    };
//
//    return out;
//}
//
//
//fragment float4 fragment_main(const VertexOut in [[ stage_in ]],
//
//                              constant FragmentUniforms &fragmentUniforms [[ buffer(FragmentBufferIndex) ]],
//
//                              constant Light *lights [[ buffer(LightsBufferIndex) ]],
//
//                              texture2d<float> baseColorTexture [[ texture(DiffuseTexture) ]],
//                              texture2d<float> normalTexture    [[ texture(NormalTexture)]],
//                              texture2d<float> roughnessTexture [[ texture(RoughnessTexture) ]],
//
//                              sampler textureSampler [[ sampler(0) ]])
//{
//    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * fragmentUniforms.tiling).rgb;
//
//    float3 normalValue = normalTexture.sample(textureSampler, in.uv * fragmentUniforms.tiling).xyz;
//    normalValue = normalValue * 2 - 1;
//    normalValue = normalize(normalValue);
//
//
//    float3 diffuseColor = 0;
//    float3 ambientColor = 0;
//    float3 specularColor = 0;
//
//    float materialShininess = 64;
//    float3 materialSpecularColor = float3(0.4, 0.4, 0.4);
//
//    float3 normalDirection = float3x3(in.worldTangent, in.worldBitangent,  in.worldNormal) * normalValue;
//    normalDirection = normalize(normalDirection);
//
//    for (uint i = 0; i < fragmentUniforms.lightCount; i++) {
//
//        Light light = lights[i];
//
//        if (light.type == Sunlight) {
//
//            float3 lightDirection = normalize(-light.position);
//
//            float diffuseIntensity = saturate(-dot(lightDirection, normalDirection));
//
//            diffuseColor += light.color * baseColor * diffuseIntensity;
//
//            if (diffuseIntensity > 0) {
//                float3 reflection = reflect(lightDirection, normalDirection);
//                float3 cameraDirection = normalize(in.worldPosition - fragmentUniforms.cameraPosition);
//                float specularIntensity = pow(saturate(-dot(reflection, cameraDirection)), materialShininess);
//                specularColor += light.specularColor * materialSpecularColor * specularIntensity;
//            }
//        } else if (light.type == Ambientlight) {
//            ambientColor += light.color * light.intensity;
//        }
//    }
//
//    float3 color = saturate(diffuseColor + ambientColor + specularColor);
//    return float4(color, 1);
//}
