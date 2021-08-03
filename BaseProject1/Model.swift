//
//  Model.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class Model: Node {
    var meshes: [Mesh]
    
    init(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError("Model not found: \(name)") }
        let bufferAllocator = MTKMeshBufferAllocator(device: Renderer.device)

        let asset = MDLAsset(url: url, vertexDescriptor: MDLVertexDescriptor.defaultVertexDescriptor, bufferAllocator: bufferAllocator)
        
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)
        
        meshes = zip(mdlMeshes, mtkMeshes).map { Mesh(mdlMesh: $0.0, mtkMesh: $0.1) }
        
        super.init()
        self.name = name
    }
}

extension Model: Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder, uniforms: Uniforms) {
        var vertexUniforms = uniforms
        
        vertexUniforms.modelMatrix = modelMatrix
        renderEncoder.setVertexBytes(&vertexUniforms, length: MemoryLayout<Uniforms>.stride, index: Int(UniformBufferIndex.rawValue))
        
        for mesh in meshes {
 
            let vertexBuffer = mesh.mtkMesh.vertexBuffers[0].buffer
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: Int(VertexBufferIndex.rawValue))
            
            for submesh in mesh.submeshes {
                guard let pipelineState = submesh.renderPipelineState else { fatalError("Failed to set render pipeline state for model.") }
                renderEncoder.setRenderPipelineState(pipelineState)
                
                let mtkSubmesh = submesh.mtkSubmesh
                renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: mtkSubmesh.indexCount, indexType: mtkSubmesh.indexType, indexBuffer: mtkSubmesh.indexBuffer.buffer, indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }
}
