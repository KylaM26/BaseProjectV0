//
//  ArcballCamera.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import simd

class ArcballCamera: Camera {
    var minDistance: Float = 0.5
    var maxDistance: Float = 10
    
    var _viewMatrix: Matrix4x4 = .indentity()
    
    var distance: Float  = 0 {
        didSet {
            _viewMatrix = updateViewMatrix()
        }
    }
    
    var target: Vector3  = [0, 0, 0] {
        didSet {
            _viewMatrix = updateViewMatrix()
        }
    }
    
    override var rotation: Vector3 {
        didSet {
            _viewMatrix = updateViewMatrix()
        }
    }
    
    override var viewMatrix: Matrix4x4 {
        return _viewMatrix
    }
    
    override init() {
        super.init()
        _viewMatrix = updateViewMatrix()
    }
    
    func updateViewMatrix() -> Matrix4x4 {
        let translationMatrix = Matrix4x4(translation: [target.x, target.y, target.z - distance])
        let rotationMatrix = Matrix4x4(rotationYXZ: [-rotation.x, rotation.y, 0])
        
        let matrix = (rotationMatrix * translationMatrix).inverse
        position = rotationMatrix.upperLeft * -matrix.columns.3.xyz
        
        return matrix
    }
    
    override func zoom(delta: Float) {
        let sensitivity: Float = 0.05
        distance -= delta * sensitivity
        _viewMatrix = updateViewMatrix()
    }
    
    override func rotate(delta: Vector2) {
        let sensitivity: Float = 0.005
        rotation.y += delta.x * sensitivity
        rotation.x += delta.y * sensitivity
        rotation.x = max(-Float.pi/2, min(rotation.x, Float.pi/2))
        _viewMatrix = updateViewMatrix()
    }

}
