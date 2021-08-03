//
//  ViewControllerExtension.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import Cocoa

extension ViewController {
    func addGestureRecognizers(to view: NSView) {
        let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(gesture: NSPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let delta = Vector2(Float(translation.x), Float(translation.y))
        
        renderer?.camera.rotate(delta: delta)
        gesture.setTranslation(.zero, in: gesture.view)
    }
    
    override func scrollWheel(with event: NSEvent) {
        renderer?.camera.zoom(delta: Float(event.deltaY))
    }
}
