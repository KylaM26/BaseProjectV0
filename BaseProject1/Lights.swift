//
//  Lights.swift
//  BaseProject1
//
//  Created by Kyla Wilson on 8/5/21.
//

import Foundation

var sunlight: Light = {
    var light = buildDefaultLight()
    light.position = [1, 2, -2]
    return light
}()

var ambientLight: Light = {
    var light = buildDefaultLight()
    light.color = [0.5, 1, 0]
    light.intensity = 0.1
    light.type = Ambientlight
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
