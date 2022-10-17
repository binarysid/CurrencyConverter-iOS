//
//  DomainModel.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//

import Foundation

// Domain Model is used to map Persistance data or API Data to presentable Domain Object
protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}
