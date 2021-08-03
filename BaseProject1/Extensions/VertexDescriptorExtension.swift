//
//  VertexDescriptorExtension.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

extension MDLVertexDescriptor {
    
    static var defaultVertexDescriptor: MDLVertexDescriptor {
        let descriptor = MDLVertexDescriptor()
        var offset = 0
        
        descriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: offset, bufferIndex: Int(VertexBufferIndex.rawValue))
        offset += MemoryLayout<Vector3>.stride
        
        descriptor.attributes[1] = MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: offset, bufferIndex: Int(VertexBufferIndex.rawValue))
        offset += MemoryLayout<Vector3>.stride
        
        descriptor.layouts[0] = MDLVertexBufferLayout(stride: offset)
        
        return descriptor
    }
}
