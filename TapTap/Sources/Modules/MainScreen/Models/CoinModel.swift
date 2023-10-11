//
//  CoinModel.swift
//  TapTap
//
//  Created by Artem Pavlov on 07.10.2023.
//

import Foundation

struct CoinModel {

  let coinSideType: CoinSideType

  enum CoinSideType {

    /// Орел
    case eagle

    /// Решка
    case tails

    /// Ничего
    case none
  }
}


