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

  /// добавляем объект вьюшки для отображения сцены
  private var sceneView = SCNView()

  ///добавляем сцену
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
    ///устанавливаем положение основного объекта
    cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 4.0)

    /// добавляем дополнительные рассеянный свет
    let ambientLight = SCNLight()
    ambientLight.type = SCNLight.LightType.ambient
    ambientLight.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    cameraNode.light = ambientLight

    /// основной свет точечный
    let light = SCNLight()
    light.type = SCNLight.LightType.spot
    light.spotInnerAngle = 50.0
    light.spotOuterAngle = 80.0
    light.castsShadow = true
    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = SCNVector3(x: 1.5, y: 3.5, z: 3.5)

    /// cube

    let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
    let cubeNode = SCNNode(geometry: cubeGeometry)

    ///красим куб в красный
    let redMaterial = SCNMaterial()
    redMaterial.diffuse.contents = UIColor.red
    cubeGeometry.materials = [redMaterial]

    /// plane

    let planeGeometry = SCNPlane(width: 50.0, height: 50.0)
    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
    planeNode.position = SCNVector3(x: 0, y: -0.5, z: 0)

    ///красим дополнительный объект в зеленый
    let greenMaterial = SCNMaterial()
    greenMaterial.diffuse.contents = UIColor.green
    planeGeometry.materials = [greenMaterial]

    /// добавляем свет, камеру и объекты на сцену

    scene.rootNode.addChildNode(lightNode)
    scene.rootNode.addChildNode(cameraNode)
    scene.rootNode.addChildNode(cubeNode)
    scene.rootNode.addChildNode(planeNode)

    let constraint = SCNLookAtConstraint(target: cubeNode)
    constraint.isGimbalLockEnabled = true
    cameraNode.constraints = [constraint]
    lightNode.constraints = [constraint]
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
