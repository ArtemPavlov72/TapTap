//
//  CoinView.swift
//  TapTap
//
//  Created by Артем Павлов on 07.10.2023.
//

import UIKit
import SceneKit

class CoinView: UIView {

  // MARK: - Private properties

  private var sceneView = SCNView()
  private var scene = SCNScene()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    setupScene()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private

private extension CoinView {
  func setupView() {
    configureLayout()
  }

  func setupScene() {
    sceneView.scene = scene

    let camera = SCNCamera()
    let cameraNode = SCNNode()
    cameraNode.camera = camera
    cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)

    let light = SCNLight()
    light.type = SCNLight.LightType.omni
    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)

    let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
    let cubeNode = SCNNode(geometry: cubeGeometry)

    scene.rootNode.addChildNode(lightNode)
    scene.rootNode.addChildNode(cameraNode)
    scene.rootNode.addChildNode(cubeNode)
  }

  func configureLayout() {
    [sceneView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    NSLayoutConstraint.activate([
      sceneView.leadingAnchor.constraint(equalTo: leadingAnchor),
      sceneView.topAnchor.constraint(equalTo: topAnchor),
      sceneView.trailingAnchor.constraint(equalTo: trailingAnchor),
      sceneView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
