//
//  Submesh.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class Submesh: Texturable {
    var mtkSubmesh: MTKSubmesh
    var renderPipelineState: MTLRenderPipelineState?
    
    var textures: Textures
    var material: Material
    
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        self.mtkSubmesh = mtkSubmesh
        textures = Textures(material: mdlSubmesh.material)
        material = Submesh.getMaterials(mdlMaterial: mdlSubmesh.material)
        renderPipelineState = Submesh.buildRenderPipelineState(textures: textures)
    }
    
    static func buildRenderPipelineState(textures: Textures) -> MTLRenderPipelineState? {
        let functionConstants = Submesh.createFunctionConstants(textures: textures)
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = Renderer.library.makeFunction(name: "vertex_main")

        var fragmentFunction: MTLFunction? //= Renderer.library.makeFunction(name: "fragment_main")
        
        do {
            fragmentFunction = try Renderer.library.makeFunction(name: "fragment_mainPBR", constantValues: functionConstants)
        } catch {
            print("No metal function found!")
        }
        

        descriptor.colorAttachments[0].pixelFormat = Renderer.colorPixelFormat
        descriptor.fragmentFunction = fragmentFunction
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(Model.vertexAttributeDescriptor)
        descriptor.depthAttachmentPixelFormat = .depth32Float
        
        var pipelineState: MTLRenderPipelineState? = nil
        
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return pipelineState
    }
    
    static func getMaterials(mdlMaterial: MDLMaterial?) -> Material {
        var material = Material()
        
        if let property = mdlMaterial?.property(with: .baseColor), property.type == .float3 {
            material.diffuse = property.float3Value
        }
        
        if let property = mdlMaterial?.property(with: .specular), property.type == .float3 {
            material.specularColor = property.float3Value
        }
        
        if let property = mdlMaterial?.property(with: .specularExponent), property.type == .float {
            material.shininess = property.floatValue
        }
        
        if let property = mdlMaterial?.property(with: .roughness), property.type == .float {
            material.roughness = property.floatValue
        }
        
        return material
    }
    
    static func createFunctionConstants(textures: Textures) -> MTLFunctionConstantValues {
        let functionConstants = MTLFunctionConstantValues()
        
        var doesHaveTexture = textures.diffuse == nil ? false : true
        functionConstants.setConstantValue(&doesHaveTexture, type: .bool, index: 0)
        
        doesHaveTexture = textures.normal == nil ? false : true
        functionConstants.setConstantValue(&doesHaveTexture, type: .bool, index: 1)
        
        doesHaveTexture = textures.roughness == nil ? false : true
        functionConstants.setConstantValue(&doesHaveTexture, type: .bool, index: 2)
        
        doesHaveTexture = false
        functionConstants.setConstantValue(&doesHaveTexture, type: .bool, index: 3)
        functionConstants.setConstantValue(&doesHaveTexture, type: .bool, index: 4)
        
        return functionConstants
    }
}

