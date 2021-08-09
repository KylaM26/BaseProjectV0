//
//  Lights.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/5/21.
//

import Foundation

let sunlight: Light = {
  var light = buildDefaultLight()
    light.position = [0.4, 1, -2]
    return light
}()

let ambientLight: Light = {
    var light = buildDefaultLight()
    light.color = [1, 1, 1]
    light.intensity = 0.1
    light.type = Ambientlight
    return light
}()

let fillLight: Light = {
    var light = buildDefaultLight()
    light.position = [0, -0.1, 0.4]
    light.specularColor = [0, 0, 0]
    light.color = [0.4, 0.4, 0.4]
    return light
}()

func buildDefaultLight() -> Light {
    var light = Light()
    light.position = [0, 0, 0]
    light.color = [1, 1, 1]
    light.specularColor = [0.6, 0.6, 0.6]
    light.intensity = 1
    light.attenuation = Vector3(1, 0, 0)
    light.type = Sunlight
    return light
}
