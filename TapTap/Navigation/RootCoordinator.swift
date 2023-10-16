//
//  RootCoordinator.swift
//  TapTap
//
//  Created by Artem Pavlov on 04.10.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol RootCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol RootCoordinatorInput {

  /// Приложение стало активным
  func sceneDidBecomeActive()

  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: RootCoordinatorOutput? { get set }
}

typealias RootCoordinatorProtocol = RootCoordinatorInput & Coordinator

final class RootCoordinator: RootCoordinatorProtocol {

  // MARK: - Internal variables

  weak var output: RootCoordinatorOutput?

  // MARK: - Private variables

  private let window: UIWindow
  private let navigationController = UINavigationController()
  private var mainScreenCoordinator: MainScreenCoordinatorProtocol?

  // MARK: - Initialization

  /// - Parameters:
  ///   - window: Окно просмотра
  init(_ window: UIWindow) {
    self.window = window
  }

  // MARK: - Internal func

  func start() {
    let mainScreenCoordinator = MainScreenCoordinator(navigationController: navigationController)
    self.mainScreenCoordinator = mainScreenCoordinator
    mainScreenCoordinator.start()

    window.makeKeyAndVisible()
    window.rootViewController = navigationController
  }

  func sceneDidBecomeActive() {
 //   mainScreenCoordinator?.sceneDidBecomeActive()
  }
}

