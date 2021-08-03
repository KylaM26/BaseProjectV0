//
//  Renderable.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

protocol Renderable {
    func draw(renderEncoder: MTLRenderCommandEncoder)
}
