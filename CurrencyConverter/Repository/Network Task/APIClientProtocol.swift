//
//  APIClientProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Combine
import Foundation

protocol APIClientProtocol:RepositoryProtocol where Request == URLRequest, Output == AnyPublisher<ExchangeRates, Error>{
    
    func getData(_ request:URLRequest) -> AnyPublisher<ExchangeRates, Error>
}
