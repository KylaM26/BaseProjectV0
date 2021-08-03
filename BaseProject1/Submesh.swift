//
//  Submesh.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class Submesh {
    var mtkSubmesh: MTKSubmesh
    var renderPipelineState: MTLRenderPipelineState?
    
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        self.mtkSubmesh = mtkSubmesh
        renderPipelineState = buildRenderPipelineState()
    }
    
    func buildRenderPipelineState() -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        descriptor.vertexFunction = Renderer.library.makeFunction(name: "vertex_main")
        descriptor.fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultVertexDescriptor)
        descriptor.depthAttachmentPixelFormat = .depth32Float
        
        var pipelineState: MTLRenderPipelineState? = nil
        
        do {
            pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return pipelineState
    }
}

