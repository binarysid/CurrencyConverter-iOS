//
//  APIClientProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation

protocol APIClientProtocol{
    typealias resultHandler = (Result<Data?,Error>)->Void
    func fecthCurrencyList(completionHandler: @escaping resultHandler)
}
