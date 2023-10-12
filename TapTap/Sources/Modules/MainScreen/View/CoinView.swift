//
//  CoinView.swift
//  TapTap
//
//  Created by Artem Pavlov on 07.10.2023.
//

import UIKit
import SceneKit

class CoinView: UIView {

  // MARK: - Private properties

  private var sceneView = SCNView()
  private var screenScene = SCNScene()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    setupScene()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Internal func

  /// Обновляет экран с монетой
  ///  - Parameter type: Тип монеты
  func updateCoinWith() {
    addCoins()
  }
}

// MARK: - Private

private extension CoinView {
  func setupView() {
    configureLayout()
    sceneView.transform = CGAffineTransformMakeScale(-1, 1)

  }

  func setupScene() {
    sceneView.scene = screenScene

    setupCamera()
  }

  func setupCamera() {
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 12)
  //  cameraNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
    screenScene.rootNode.addChildNode(cameraNode)
  }

  func setupLight() {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .omni
    lightNode.position = SCNVector3(x: 0, y: 5, z: 0)

    //    let rotatingNode = SCNNode()
    //    scnScene.rootNode.addChildNode(rotatingNode)
    //    rotatingNode.addChildNode(lightNode)
    //
    //    let lightOrbit = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
    //    let repeatLightOrbit = SCNAction.repeatForever(lightOrbit)
    //    rotatingNode.runAction(repeatLightOrbit)
  }

  func addCoins() {

    var coinNodes: [SCNNode] = []

    if !coinNodes.isEmpty {
      for die in coinNodes {
        die.removeFromParentNode()
      }
    }

   // coinNodes = []
   // speeds = []

    guard let eagleImage = UIImage(named: "USAPresidentDollarEagle") else {
      return
    }
    guard let tailsImage = UIImage(named: "USAPresidentDollarTails") else {
      return
    }

    let sides = [
      eagleImage,
      tailsImage
    ]

    let coinNode = createCoin(position: SCNVector3(0, 0, 0), sides: sides)
//    coinNode.name = Appearance().coinNodeName
    coinNodes.append(coinNode)
   // speeds.append(SCNVector3(0, 0, 0))

//    let torque = setTorque()
//    let force = setForce()
    for die in coinNodes {
//      die.physicsBody?.applyTorque(torque, asImpulse: true)
//      die.physicsBody?.applyForce(force, asImpulse: true)
      screenScene.rootNode.addChildNode(die)
    }
  }

  func createCoin(position: SCNVector3, sides: [UIImage]) -> SCNNode {
    let geometry = SCNCylinder(radius: 2.6, height: 0.3)

    let material1 = SCNMaterial()
    material1.diffuse.contents = sides[0]
    let material2 = SCNMaterial()
    material2.diffuse.contents = sides[1]
    geometry.materials = [material1, material2]

    let shape = SCNPhysicsShape(geometry: geometry, options: nil)
    let coinBody = SCNPhysicsBody(type: .static, shape: shape)
    let node = SCNNode(geometry: geometry)

    coinBody.restitution = 0.4
    coinBody.friction = 1

 //   coinBody.mass = 1.0
    coinBody.collisionBitMask = 1
    coinBody.contactTestBitMask = 1
    coinBody.velocityFactor = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
    coinBody.angularVelocityFactor = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
    coinBody.categoryBitMask = 1

    node.physicsBody = coinBody
    node.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(50), y: GLKMathDegreesToRadians(20), z: GLKMathDegreesToRadians(90))
    node.physicsBody?.collisionBitMask = 1
    node.physicsBody?.contactTestBitMask = 1
    node.position = position
    return node
  }

}

  // MARK: - Configure Layout

  private extension CoinView {
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
