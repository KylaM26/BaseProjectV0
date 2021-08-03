//
//  ViewController.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import MetalKit

class ViewController: NSViewController {

    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // What is a MTKView?
        // A specialized view that creates, configures, and displays Metal objects; Therefore, it must be used to used Metal API objects
        guard let metalView = view as? MTKView else { return }
        renderer = Renderer(metalView: metalView)
    }

    override var representedObject: Any? {
        didSet {

        }
    }
}

