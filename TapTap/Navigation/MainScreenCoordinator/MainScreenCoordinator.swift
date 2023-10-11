//
//  MainScreenCoordinator.swift
//  TapTap
//
//  Created by Artem Pavlov on 04.10.2023.
//

import UIKit

/// Псевдоним протокола Coordinator & MainScreenCoordinatorInput
typealias MainScreenCoordinatorProtocol = Coordinator & MainScreenCoordinatorInput

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {

  /// Приложение стало активным
  func sceneDidBecomeActive()


  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainScreenCoordinatorOutput? { get set }
}

// MARK: - MainScreenCoordinator

/// Координатор `MainScreen`
final class MainScreenCoordinator: MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: MainScreenModule?
  private var navigationController: UINavigationController
  private var anyCoordinator: Coordinator?
  private let window: UIWindow?
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  init(_ navigationController: UINavigationController, _ window: UIWindow?) {
    self.navigationController = navigationController
    self.window = window
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = MainScreenAssembly().createModule()
    self.module = module
    self.module?.moduleOutput = self
    navigationController.pushViewController(module, animated: true)
  }

  func sceneDidBecomeActive() {}
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
}
