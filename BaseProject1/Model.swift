//
//  Model.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class Model: Node {
    var meshes: [Mesh]
    
    var tiling: UInt32 = 1
    
    var samplerState: MTLSamplerState?
    
    init(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError("Model not found: \(name)") }
        let bufferAllocator = MTKMeshBufferAllocator(device: Renderer.device)

        let asset = MDLAsset(url: url, vertexDescriptor: MDLVertexDescriptor.defaultVertexDescriptor, bufferAllocator: bufferAllocator)
        
        asset.loadTextures()
        
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: Renderer.device)
        
        meshes = zip(mdlMeshes, mtkMeshes).map { Mesh(mdlMesh: $0.0, mtkMesh: $0.1) }
        
        samplerState = Model.buildSamplerState()
        
        super.init()
        self.name = name
    }
    
    static func buildSamplerState() -> MTLSamplerState? {
        let descriptor = MTLSamplerDescriptor()
        descriptor.rAddressMode = .repeat
        descriptor.sAddressMode = .repeat
        descriptor.tAddressMode = .repeat
        descriptor.maxAnisotropy = 8
        descriptor.mipFilter = .linear
        return Renderer.device.makeSamplerState(descriptor: descriptor)
    }
}

extension Model: Renderable {
    func render(renderEncoder: MTLRenderCommandEncoder, uniforms: Uniforms, fragmentUniforms: FragmentUniforms) {
        var vertexUniforms = uniforms
        var fragmentUniforms = fragmentUniforms
        
        vertexUniforms.modelMatrix = modelMatrix
        renderEncoder.setVertexBytes(&vertexUniforms, length: MemoryLayout<Uniforms>.stride, index: Int(UniformBufferIndex.rawValue))
        
        renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        
        fragmentUniforms.tiling = tiling
        
        for mesh in meshes {
 
            let vertexBuffer = mesh.mtkMesh.vertexBuffers[0].buffer
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: Int(VertexBufferIndex.rawValue))
            
            renderEncoder.setFragmentBytes(&fragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride, index: Int(FragmentBufferIndex.rawValue))
            
            for submesh in mesh.submeshes {
                guard let pipelineState = submesh.renderPipelineState else { fatalError("Failed to set render pipeline state for model.") }
                renderEncoder.setRenderPipelineState(pipelineState)
                
                renderEncoder.setFragmentTexture(submesh.textures.diffuse, index: Int(DiffuseTexture.rawValue))
                renderEncoder.setFragmentTexture(submesh.textures.roughness, index: Int(RoughnessTexture.rawValue))
                
                let mtkSubmesh = submesh.mtkSubmesh
                renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: mtkSubmesh.indexCount, indexType: mtkSubmesh.indexType, indexBuffer: mtkSubmesh.indexBuffer.buffer, indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }
}
