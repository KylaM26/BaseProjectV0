//
//  MathLibrary.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/2/21.
//

import simd

typealias Vector4 = SIMD4<Float>
typealias Vector3 = SIMD3<Float>
typealias Vector2 = SIMD2<Float>

typealias Matrix4x4 = float4x4
typealias Matrix3x3 = float3x3

let PI = Float.pi

// MARK:- FLOAT EXTENSIONS
extension Float {
    var radiansToDegrees: Float {
        return (self / PI) * 180
    }
    
    var degreesToRadians: Float {
        return (self * 180) / PI
    }
}

// MARK:- MATRIX4X4 AKA FLOAT4 EXTENSIONS
extension Matrix4x4 { // This is type alias for apple's float4x4
    // MARK:- Translate
    init(translation: Vector3) {
        let m4x4 = Matrix4x4(
            [1,             0,              0,              0],
            [0,             1,              0,              0],
            [0,             0,              1,              0],
            [translation.x, translation.y, translation.z,   1]
        )
        self = m4x4
    }
    
    // MARK:- Scale
    init(scale: Vector3) {
        let m4x4 = Matrix4x4(
            [scale.x, 0, 0, 0],
            [0, scale.y, 0, 0],
            [0, 0, scale.z, 0],
            [0, 0, 0,       1]
        )
        self = m4x4
    }
    
    init(scaling: Float) {
      self = matrix_identity_float4x4
      columns.3.w = 1 / scaling // The last column which is 3(becuase index start with 0) divide it to scale the object.
    }
    
    // MARK:- Rotate
    init(rotationX angle: Float) {
      let m4x4 = Matrix4x4(
        [1,           0,          0, 0],
        [0,  cos(angle), sin(angle), 0],
        [0, -sin(angle), cos(angle), 0],
        [0,           0,          0, 1]
      )
      self = m4x4
    }
    
    init(rotationY angle: Float) {
      let m4x4 = Matrix4x4(
        [cos(angle), 0, -sin(angle), 0],
        [         0, 1,           0, 0],
        [sin(angle), 0,  cos(angle), 0],
        [         0, 0,           0, 1]
      )
      self = m4x4
    }
    
    init(rotationZ angle: Float) {
      let m4x4 = Matrix4x4(
        [ cos(angle), sin(angle), 0, 0],
        [-sin(angle), cos(angle), 0, 0],
        [          0,          0, 1, 0],
        [          0,          0, 0, 1]
      )
      self = m4x4
    }
    
    init(rotation angle: Vector3) {
        let rotX = Matrix4x4(rotationX: angle.x)
        let rotY = Matrix4x4(rotationY: angle.y)
        let rotZ = Matrix4x4(rotationZ: angle.z)
        self = rotX * rotY * rotZ
    }
    
    init(rotationYXZ angle: Vector3) {
        let rotX = Matrix4x4(rotationX: angle.x)
        let rotY = Matrix4x4(rotationY: angle.y)
        let rotZ = Matrix4x4(rotationZ: angle.z)
        self = rotY * rotX * rotZ
    }
    
    var upperLeft: Matrix3x3 {
      let x = columns.0.xyz
      let y = columns.1.xyz
      let z = columns.2.xyz
      return Matrix3x3(columns: (x, y, z))
    }
    
    // MARK:- Camera
    init(projectionFOV fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = lhs ? far / (far - near) : far / (near - far) // If lh coordinate system
        
        let X = Vector4(x, 0, 0, 0)
        let Y = Vector4(0, y, 0, 0)
        let Z = lhs ? Vector4(0, 0, z, 1) : Vector4(0, 0, z, -1)
        let W = lhs ? Vector4( 0,  0,  z * -near,  0) : Vector4( 0,  0,  z * near,  0)
        
        self.init()
        columns = (X, Y, Z, W)
    }
    
    static func indentity() -> Matrix4x4 { matrix_identity_float4x4 }
}

// MARK:- Vector4
extension Vector4 {
    var xyz: Vector3 {
        get {
            Vector3(x, y, z)
        } set {
            x = newValue.x
            y = newValue.y
            z = newValue.z
        }
    }
}
