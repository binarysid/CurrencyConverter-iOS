//
//  DomainRate.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import Foundation

// DomainRate is used for presenting the data to the view. So this is the object that viewmodel passes to the view
struct DomainRate:Hashable {
    let currency:String
    var rate:Double
}
