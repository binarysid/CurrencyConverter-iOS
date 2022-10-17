//
//  Currency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var name: String?
    @NSManaged public var rate: Double

}

extension Currency : Identifiable {

}

extension Currency:DomainModel{
    func toDomainModel() -> DomainRate {
        return DomainRate(currency: name ?? "", rate: rate)
    }
}
