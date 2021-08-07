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
        
        descriptor.attributes[Int(Position.rawValue)] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: offset, bufferIndex: 0)
        offset += MemoryLayout<Vector3>.stride
        
        descriptor.attributes[Int(Normal.rawValue)] = MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: offset, bufferIndex: 0)
        offset += MemoryLayout<Vector3>.stride
        
        descriptor.attributes[Int(UV.rawValue)] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: .float2, offset: offset, bufferIndex: 0)
        offset += MemoryLayout<Vector2>.stride
        
//        descriptor.attributes[Int(Tangent.rawValue)] = MDLVertexAttribute(name: MDLVertexAttributeTangent, format: .float3, offset: offset, bufferIndex: 1)
//        offset += MemoryLayout<Vector3>.stride
//        
//        descriptor.attributes[Int(Bitangent.rawValue)] = MDLVertexAttribute(name: MDLVertexAttributeBitangent, format: .float3, offset: offset, bufferIndex: 2)
//        offset += MemoryLayout<Vector3>.stride
        
        descriptor.layouts[0] = MDLVertexBufferLayout(stride: offset)
        
        return descriptor
    }
}
