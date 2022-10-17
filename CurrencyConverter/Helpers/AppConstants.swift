//
//  AppConstants.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation

enum AppConstants{
    enum RestURL{
        static let currencyParser = "https://openexchangerates.org/api/latest.json"
    }
    enum Config{
        static var APPID:String{
            guard let id = Bundle.main.infoDictionary?["APP_ID"] as? String else{ return ""}
            return id
        }
    }
    enum HTTPMethods{
        static let GET = "GET"
        static let POST = "POST"
    }
}
