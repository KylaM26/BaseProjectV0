//
//  Node.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import simd

class Node {
    var name = "untitled"
    var position: Vector3 = [0, 0, 0]
    var rotation: Vector3 = [0, 0, 0]
    var scale:    Vector3 = [1, 1, 1]
    
    var modelMatrix: Matrix4x4 {
        let translationMatrix = Matrix4x4(translation: position)
        let rotationMatrix    = Matrix4x4(rotation: rotation)
        let scaleMatrix       = Matrix4x4(scale: scale)
        return translationMatrix * rotationMatrix * scaleMatrix
    }
}
