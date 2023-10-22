//
//  MainScreenCoordinator.swift
//  TapTap
//
//  Created by Artem Pavlov on 04.10.2023.
//

import UIKit

/// Псевдоним протокола Coordinator & MainScreenCoordinatorInput
typealias MainScreenCoordinatorProtocol = MainScreenCoordinatorInput

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainScreenCoordinatorOutput? { get set }
}

// MARK: - MainScreenCoordinator

/// Координатор `MainScreen`
final class MainScreenCoordinator: MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables

  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: MainScreenModule?
  private var navigationController: UINavigationController
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  ///   - services: Сервисы приложения
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = MainScreenAssembly().createModule()
    self.module = module
    self.module?.moduleOutput = self
    navigationController.pushViewController(module, animated: true)
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func resultLabelAction(text: String?) {
    
  }
}
