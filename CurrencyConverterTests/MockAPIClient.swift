//
//  MockAPIClient.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 14/10/22.
//

import Combine
import XCTest
@testable import CurrencyConverter


final class MockAPIClient{
    var result: AnyPublisher<ExchangeRates, Error>!
}

extension MockAPIClient:APIClientProtocol{
    func getData(_ request: URLRequest) -> AnyPublisher<ExchangeRates, Error> {
        return result
    }
}
