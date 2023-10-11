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
}

// MARK: - Private

private extension CoinView {
  func setupView() {
    configureLayout()
 //   sceneView.backgroundColor = .lightGray
  }

  func setupScene() {
    sceneView.scene = screenScene
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

  func createCoin(position: SCNVector3, sides: [UIImage]) -> SCNNode {
    let geometry = SCNCylinder(radius: 2.2, height: 0.2)

    let material1 = SCNMaterial()
    material1.diffuse.contents = sides[0]
    let material2 = SCNMaterial()
    material2.diffuse.contents = sides[1]
    geometry.materials = [material1, material2]

    let shape = SCNPhysicsShape(geometry: geometry, options: nil)
    let coinBody = SCNPhysicsBody(type: .dynamic, shape: shape)
    let node = SCNNode(geometry: geometry)

    coinBody.restitution = 0.4
    coinBody.friction = 1
    coinBody.mass = 1.0
    coinBody.collisionBitMask = 1
    coinBody.contactTestBitMask = 1
    coinBody.velocityFactor = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
    coinBody.angularVelocityFactor = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
    coinBody.categoryBitMask = 1

    node.physicsBody = coinBody
    node.physicsBody?.collisionBitMask = 1
    node.physicsBody?.contactTestBitMask = 1
    node.position = position
    return node
  }
}
