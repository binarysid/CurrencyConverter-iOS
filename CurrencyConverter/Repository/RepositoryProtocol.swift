//
//  ReepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation

//RepositoryProtocol is conformed by all classes that are part of the data repository and returns data to the worker object
protocol RepositoryProtocol {
    associatedtype T
    func getData(completionHandler: @escaping(Result<T?, Error>) -> Void)
}
