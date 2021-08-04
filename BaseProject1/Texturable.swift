//
//  Texturable.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

protocol Texturable { }

extension Texturable {
    static func loadTexture(imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: Renderer.device)

        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .SRGB: false,
            .generateMipmaps: NSNumber(booleanLiteral: true)
        ]
        
        let fileExtension = URL(fileURLWithPath: imageName).path.isEmpty ? "png" : nil
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: fileExtension) else {
            return try? textureLoader.newTexture(name: imageName, scaleFactor: 1, bundle: Bundle.main, options: textureLoaderOptions)
        }
        
        return try? textureLoader.newTexture(URL: url, options: textureLoaderOptions)
    }
}
