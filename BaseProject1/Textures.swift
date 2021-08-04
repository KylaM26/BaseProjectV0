//
//  Textures.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

struct Textures {
    var material: MDLMaterial?
    
    var diffuse: MTLTexture?
    var roughness: MTLTexture?
    
    init(material: MDLMaterial?) {
        self.material = material
        diffuse = property(semantic: .baseColor)
        roughness = property(semantic: .roughness)
    }
    
    func property(semantic: MDLMaterialSemantic) -> MTLTexture? {
        let property = material?.property(with: semantic)
        
        // For obj
        if let type = property?.type, type == .string, let filename = property?.stringValue {
            return try? Submesh.loadTexture(imageName: filename)
        }
        
        // For usd formats
//        if let property = material?.property(with: semantic),
//           property.type == .texture,
//           let mdlTexture = property.textureSamplerValue?.texture {
//            return try? Submesh.loadTexture(texture: mdlTexture)
//        }
        
        return nil
    }
};
