//
//  SceneDelegate.swift
//  TapTap
//
//  Created by Artem Pavlov on 03.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  // MARK: - Private property

  private var coordinator: RootCoordinatorProtocol?

  // MARK: - Internal func

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let scene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: scene)
    let coordinator = RootCoordinator(window)
    self.coordinator = coordinator
    coordinator.start()
    self.window = window
  }
}

