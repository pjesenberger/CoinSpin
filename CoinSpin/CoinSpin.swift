//
//  CoinSpin.swift
//  CoinSpin
//
//  Created by Pascal Jesenberger on 04/06/2026.
//

import SwiftUI
import SceneKit

struct CoinSpin: UIViewRepresentable {
    var imageName: String
    var edgeColor: UIColor
    var spinTrigger: Int
    var duration: Double = 1.14
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.antialiasingMode = .multisampling4X
        view.autoenablesDefaultLighting = false
        
        let scene = SCNScene()
        view.scene = scene
        
        var faceTransform = SCNMatrix4MakeTranslation(-0.5, -0.5, 0)
        faceTransform = SCNMatrix4Mult(faceTransform, SCNMatrix4MakeRotation(-.pi / 2, 0, 0, 1))
        faceTransform = SCNMatrix4Mult(faceTransform, SCNMatrix4MakeScale(-1, 1, 1))
        faceTransform = SCNMatrix4Mult(faceTransform, SCNMatrix4MakeTranslation(0.5, 0.5, 0))
        
        let face = SCNMaterial()
        face.diffuse.contents = UIImage(named: imageName)
        face.diffuse.contentsTransform = faceTransform
        face.diffuse.wrapS = .repeat
        face.diffuse.wrapT = .repeat
        face.lightingModel = .constant
        
        let edge = SCNMaterial()
        edge.diffuse.contents = edgeColor
        edge.lightingModel = .constant
        
        let cylinder = SCNCylinder(radius: 1, height: 0.22)
        cylinder.materials = [edge, face, face]
        
        let coin = SCNNode(geometry: cylinder)
        coin.eulerAngles.x = .pi / 2
        scene.rootNode.addChildNode(coin)
        context.coordinator.coin = coin
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 1
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 10)
        scene.rootNode.addChildNode(cameraNode)
        
        view.isHidden = true
        view.prepare([scene]) { _ in
            DispatchQueue.main.async { view.isHidden = false }
        }
        
        return view
    }
    
    func updateUIView(_ view: SCNView, context: Context) {
        let coordinator = context.coordinator
        guard spinTrigger != coordinator.lastTrigger, let coin = coordinator.coin else { return }
        coordinator.lastTrigger = spinTrigger
        
        let spin = CABasicAnimation(keyPath: "eulerAngles.y")
        spin.fromValue = Float(0)
        spin.toValue = Float.pi * 2
        spin.duration = duration
        spin.timingFunction = CAMediaTimingFunction(name: .easeOut)
        coin.removeAnimation(forKey: "spin")
        coin.addAnimation(spin, forKey: "spin")
    }
    
    class Coordinator {
        var coin: SCNNode?
        var lastTrigger = 0
    }
}
