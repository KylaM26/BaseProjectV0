//
//  Renderer.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class Renderer: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    
    static var library: MTLLibrary!
    
    var models: [Model] = []
    
    init(metalView: MTKView) {
        // MTLDevice objects are your go-to object to do anything in Metal. This method checks for a suitable GPU
        guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Failed to create metal device.") }
        Renderer.device = device
        metalView.device = device
        // Each frame consists of commands that you send to the GPU.
        // You wrap up these commands in a render command encoder.
        // Command buffers organize these command encoders and a command queue organizes the command buffers.
        guard let commandQueue = device.makeCommandQueue() else { fatalError("Failed to create command queue.") }
        Renderer.commandQueue = commandQueue
        
        Renderer.library = device.makeDefaultLibrary()
        
        super.init()
        
        let chest = Model(name: "chest.obj")
        models.append(chest)
        
        metalView.delegate = self
        metalView.clearColor = MTLClearColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        
        mtkView(metalView, drawableSizeWillChange: metalView.frame.size)
    }

    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { // For window resize
        
    }
    
    func draw(in view: MTKView) { // For drawing
        
        // A container that stores encoded commands(from the renderer encoder) for the GPU to execute.
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer() else { fatalError("Failed to create command buffer.") }
        
        guard let drawable = view.currentDrawable else { fatalError("Failed to get current drawable from view.") }
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { fatalError("Failed to get current render pass descriptor.") }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { fatalError("Failed to create render command encoder.") }
        
        for model in models {
            model.draw(renderEncoder: renderEncoder)
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
