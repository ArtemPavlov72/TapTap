//
//  MainScreenViewController.swift
//  TapTap
//
//  Created by Artem Pavlov on 06.10.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainScreenModuleOutput: AnyObject {

  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
typealias MainScreenModule = UIViewController & MainScreenModuleInput

/// Презентер
final class MainScreenViewController: MainScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let moduleView: MainScreenViewProtocol
  private let factory: MainScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MainScreenViewProtocol,
       interactor: MainScreenInteractorInput,
       factory: MainScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   // view.backgroundColor = .blue
    moduleView.updateContentWith() //загружаем монетку для теста
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func resultLabelAction() {

  }

  func generateButtonAction() {
    
  }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenViewController: MainScreenInteractorOutput {}

// MARK: - MainScreenFactoryOutput

extension MainScreenViewController: MainScreenFactoryOutput {}

// MARK: - Private

private extension MainScreenViewController {}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {}
}
