//
//  ReepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation
import Combine
import CoreData
//RepositoryProtocol is conformed by all classes that are part of the data repository and returns data to the worker object
protocol RepositoryProtocol {
    associatedtype Request
    associatedtype Output
    func getData(_ request:Request)->Output
}


//This is used for boxing and type erasing. Otherwise generic protocols cannot be registerd in DIContainer and will give following error- "Protocol can only be used as a generic constraint because it has Self or associated type requirements"
struct RepositoryTypeEraser<T: RepositoryProtocol> {
    typealias X = T
    let objectType: X.Type
    let object: X

    init(object: X) {
        self.object = object
        self.objectType = X.self
    }
}
