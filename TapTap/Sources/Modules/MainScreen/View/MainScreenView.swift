//
//  MainScreenView.swift
//  TapTap
//
//  Created by Artem Pavlov on 06.10.2023.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol MainScreenViewOutput: AnyObject {

  /// Было нажатие на результат генерации
  func resultLabelAction()

  /// Была нажата кнопку генерации
  func generateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput {

  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith()
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties

  private let resultLabel = UILabel()
  private let generateButton = UIButton()
  private let coinView = CoinView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    applyDefaultBehavior()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func

  func updateContentWith() {
    coinView.updateCoinWith()
  }
}

// MARK: - Private

private extension MainScreenView {
  func applyDefaultBehavior() {
    backgroundColor = .white

    generateButton.setTitle("Play", for: .normal)
    generateButton.backgroundColor = .brown
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)

    resultLabel.font = .boldSystemFont(ofSize: 50)

    coinView.valueCoinAction = { [weak self] coinResultType in
      guard let self else {
        return
      }

      let coinResultText = coinResultType == .eagle ? "Eagle" : "Tails"
      print(coinResultText)
      self.resultLabel.text = coinResultText
    }
  }


  func setupConstraints() {
    [coinView, resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                       constant: 8),

      coinView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      coinView.leadingAnchor.constraint(equalTo: leadingAnchor),
      coinView.trailingAnchor.constraint(equalTo: trailingAnchor),
      coinView.bottomAnchor.constraint(equalTo: bottomAnchor),

      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: 16),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -16),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -8)
    ])

  }

  @objc
  func generateButtonAction() {
//    output?.generateButtonAction()
    resultLabel.text = ""
    coinView.handleTap()
  }

  @objc
  func resultAction() {
 //   output?.resultLabelAction()
  }
}
