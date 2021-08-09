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
    var normal: MTLTexture?
    var roughness: MTLTexture?
    
    init(material: MDLMaterial?) {
        self.material = material
        diffuse = property(semantic: .baseColor)
        normal = property(semantic: .tangentSpaceNormal)
        roughness = property(semantic: .roughness)
    }
    
    func property(semantic: MDLMaterialSemantic) -> MTLTexture? {
        guard let property = material?.property(with: semantic),
          property.type == .string,
          let filename = property.stringValue,
          let texture = try? Submesh.loadTexture(imageName: filename)
          else {
            return nil
        }
        return texture
        
//        guard let property = material?.property(with: semantic), property.type == .string, let filename = property.stringValue else {
//            return nil
//        }
//
//        var texture: MTLTexture? = nil
//
//        if let newTexture = try? Submesh.loadTexture(imageName: filename) {
//            texture = newTexture
//        }
//
//        return texture
    }
};
