//
//  CoinView.swift
//  TapTap
//
//  Created by Artem Pavlov on 07.10.2023.
//

import UIKit
import SceneKit

class CoinView: UIView {

  // MARK: - Internal properties

  var valueCoinAction: ((CoinModel.CoinSideType) -> Void)?

  // MARK: - Private properties

  private var sceneView = SCNView()
  private var screenScene = SCNScene()
  private var coinNodes: [SCNNode] = []
  private var speeds: [SCNVector3] = []

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

  /// Обработать нажатие
  func handleTap() {
    screenScene.physicsWorld.speed = 3.0
    let torque = setTorque()
    let force = setForce()

    for coin in coinNodes {
      coin.physicsBody?.applyTorque(torque, asImpulse: true)
      coin.physicsBody?.applyForce(force, asImpulse: true)
    }
  }
}

// MARK: - Private

private extension CoinView {
  func setupView() {
    configureLayout()
    sceneView.transform = CGAffineTransformMakeScale(-1, 1)
    sceneView.autoenablesDefaultLighting = true
    sceneView.delegate = self
    sceneView.isPlaying = true
  }

  func setupScene() {
    sceneView.scene = screenScene


    setupCamera()
    setupLight()

    screenScene.physicsWorld.speed = 3
    screenScene.physicsWorld.gravity = SCNVector3(x: 0, y: -9.8, z: 0)
    screenScene.physicsWorld.timeStep = 1.0 / 60.0

    let wallSize = CGSize(width: 50.0, height: 50.0)

    let walls = [
      // верхняя стена X,Y,Z
      (position: SCNVector3(0, 7, 0),
       normal: SCNVector3Make(0, -1, 0),
       name: "Top"),
      // нижняя стена X,Y,Z
      (position: SCNVector3(0, -7, 0),
       normal: SCNVector3Make(0, 1, 0),
       name: "Flow"),
      // правая стена X,Y,Z
      (position: SCNVector3(7, 0, 0),
       normal: SCNVector3Make(-1, 0, 0),
       name: "Right"),
      // левая стена X,Y,Z
      (position: SCNVector3(-7, 0, 0),
       normal: SCNVector3Make(1, 0, 0),
       name: "Left"),
      // задняя стена X,Y,Z
      (position: SCNVector3(0, 0, 7),
       normal: SCNVector3Make(0, 0, -1),
       name: "Back"),
      // передняя стена X,Y,Z
      (position: SCNVector3(0, 0, -7),
       normal: SCNVector3Make(0, 0, 1),
       name: "Front")
    ]

    for wall in walls {
      let panel = self.wall(at: wall.position, with: wall.normal, sized: wallSize, name: wall.name)
      screenScene.rootNode.addChildNode(panel)
    }
  }

  func setupCamera() {
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 12, z: 2)
    cameraNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
    screenScene.rootNode.addChildNode(cameraNode)
  }

  func setupLight() {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .omni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)

    let rotatingNode = SCNNode()
    screenScene.rootNode.addChildNode(rotatingNode)
    rotatingNode.addChildNode(lightNode)

    let lightOrbit = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
    let repeatLightOrbit = SCNAction.repeatForever(lightOrbit)
    rotatingNode.runAction(repeatLightOrbit)
  }

  func scnVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y,
                          left.z * right.x - left.x * right.z,
                          left.x * right.y - left.y * right.x)
  }

  func scnVector3DotProduct(left: SCNVector3, right: SCNVector3) -> float_t {
    return (left.x * right.x + left.y * right.y + left.z * right.z)
  }

  func scnVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    let scale = 1.0 / sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
    return SCNVector3Make(vector.x * scale, vector.y * scale, vector.z*scale)
  }

  func reposition(_ node: SCNNode, to position: SCNVector3, with normal: SCNVector3) {
    let transVector1 = SCNVector3Make(1, 0, 0)
    let transVector2 = SCNVector3Make(0, 1, 0)
    var tangent0 = scnVector3CrossProduct(left: normal, right: transVector1)

    let dotprod = scnVector3DotProduct(left: tangent0, right: tangent0)
    if dotprod < 0.001 {
      tangent0 = scnVector3CrossProduct(left: normal, right: transVector2)
    }
    tangent0 = scnVector3Normalize(vector: tangent0)

    let helpVector1 = scnVector3CrossProduct(left: normal, right: tangent0)
    let tangent1 = scnVector3Normalize(vector: helpVector1)

    let tangent0GLK = GLKVector4Make(tangent0.x, tangent0.y, tangent0.z, 0)
    let tangent1GLK = GLKVector4Make(tangent1.x, tangent1.y, tangent1.z, 0)
    let normalGLK = GLKVector4Make(normal.x, normal.y, normal.z, 0)

    let rotMat = GLKMatrix4MakeWithColumns(tangent0GLK, tangent1GLK, normalGLK, GLKVector4Make(0, 0, 0, 1))
    let transMat = SCNMatrix4MakeTranslation(node.position.x, node.position.y, node.position.z)
    node.transform = SCNMatrix4Mult(transMat, SCNMatrix4FromGLKMatrix4(rotMat))
    node.position = position
  }

  func setTorque() -> SCNVector4 {
    let route = CGFloat.random(in: 2...4)
    return SCNVector4(-route, 0, -2, 2)
  }

  func setForce() -> SCNVector3 {
    let tapStrong = CGFloat.random(in: 10...14)
    return SCNVector3(0, tapStrong, 0)
  }

  func wall(at position: SCNVector3,
            with normal: SCNVector3,
            sized size: CGSize,
            name: String,
            color: UIColor = .clear) -> SCNNode {
    let geometry = SCNBox(width: size.width, height: size.height, length: 0.2, chamferRadius: 0)
    geometry.materials.first?.diffuse.contents = color
    geometry.materials.first?.isDoubleSided = true

    let shape = SCNPhysicsShape(geometry: geometry, options: nil)
    let wallBody = SCNPhysicsBody(type: .static, shape: shape)
    wallBody.restitution = 0.4
    wallBody.friction = 0.8
    wallBody.collisionBitMask = 1
    wallBody.contactTestBitMask = 1
    wallBody.categoryBitMask = 1

    let geometryNode = SCNNode(geometry: geometry)
    geometryNode.name = name
    geometryNode.physicsBody = wallBody
    geometryNode.physicsBody?.collisionBitMask = 1
    geometryNode.physicsBody?.contactTestBitMask = 1

    geometryNode.position = position
    reposition(geometryNode, to: position, with: normal)
    return geometryNode
  }

  func addCoins() {

    if !coinNodes.isEmpty {
      for die in coinNodes {
        die.removeFromParentNode()
      }
    }

    coinNodes = []
    speeds = []

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

    let coinNode = createCoin(position: SCNVector3(0, 1, 0), sides: sides)
    coinNodes.append(coinNode)
    speeds.append(SCNVector3(0, 0, 0))

    let torque = setTorque()
    let force = setForce()
    for die in coinNodes {
      die.physicsBody?.applyTorque(torque, asImpulse: true)
      die.physicsBody?.applyForce(force, asImpulse: true)
      screenScene.rootNode.addChildNode(die)
    }
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
    node.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(50), y: GLKMathDegreesToRadians(20), z: GLKMathDegreesToRadians(90))
    node.physicsBody?.collisionBitMask = 1
    node.physicsBody?.contactTestBitMask = 1
    node.position = position
    return node
  }

  func boxUpIndex(n: SCNNode) -> Int {
    let rotation = n.rotation
    let invRotation = SCNVector4(rotation.x,
                                 rotation.y,
                                 rotation.z,
                                 -rotation.w)
    let up = SCNVector3(0, 0, 0) // На что влияет?
    let transform = SCNMatrix4MakeRotation(invRotation.w,
                                           invRotation.x,
                                           invRotation.y,
                                           invRotation.z)
    let glkTransform = SCNMatrix4ToGLKMatrix4(transform)
    let glkUp = SCNVector3ToGLKVector3(up)
    let rotatedUp = GLKMatrix4MultiplyVector3(glkTransform, glkUp)
    let boxNormals: [GLKVector3] = [
      GLKVector3(v: (0, 0, 1)),
      GLKVector3(v: (1, 0, 0)),
      GLKVector3(v: (0, 0, -1)),
      GLKVector3(v: (-1, 0, 0)),
      GLKVector3(v: (0, 1, 0)),
      GLKVector3(v: (0, -1, 0)),
    ]

    var bestIndex = 0
    var maxDot: Float = 0.0

    for (i, bNormal) in boxNormals.enumerated() {
      let dot = GLKVector3DotProduct(bNormal, rotatedUp)
      if dot > maxDot {
        maxDot = dot
        bestIndex = i
      }
    }
    return bestIndex
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

// MARK: - SCNSceneRendererDelegate

extension CoinView: SCNSceneRendererDelegate {
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    DispatchQueue.global(qos: .userInteractive).sync { [weak self] in
      guard let self else {
        return
      }

      for (num, coin) in coinNodes.enumerated() {
        if let pb = coin.physicsBody {
          guard speeds.indices.contains(num) else {
            continue
          }

          let os = speeds[num]
          if !os.isZero && pb.velocity.isZero {
            DispatchQueue.main.async {
              // coin.presentation - состояние монеты в данный момент на экране
              let resultCoin = self.boxUpIndex(n: coin.presentation)
              self.valueCoinAction?(resultCoin == 5 ? .eagle : .tails)
            }
          }
          speeds[num] = pb.velocity
        }
      }
    }
  }
}

// MARK: - SCNVector3

private extension SCNVector3 {
  var isZero: Bool {
    return self.x == .zero && self.y == .zero && self.z == .zero
  }
}
