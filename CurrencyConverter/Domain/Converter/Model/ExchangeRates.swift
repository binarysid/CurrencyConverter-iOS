//
//  ExchangeRates.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import Foundation

struct ExchangeRates: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
