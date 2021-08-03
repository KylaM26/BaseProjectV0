//
//  Camera.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import Foundation

class Camera: Node {
    var fovDegrees: Float = 60
    var fovRadians: Float {
        return fovDegrees.degreesToRadians
    }
    
    var aspect: Float = 1
    var near:   Float = 0.001
    var far:    Float = 100
    
    var projectionMatrix: Matrix4x4 {
        return Matrix4x4(projectionFOV: fovRadians, near: near, far: far, aspect: aspect)
    }
    
    var viewMatrix: Matrix4x4 {
        return modelMatrix.inverse
    }
    
    func zoom(delta: Float) { }
    func rotate(delta: Vector2) { } 
}
