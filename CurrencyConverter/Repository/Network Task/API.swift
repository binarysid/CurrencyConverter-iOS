//
//  API.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 2/11/22.
//

import Foundation
import SwiftUI

struct API{
    enum HTTPMethods{
        static let GET = "GET"
        static let POST = "POST"
    }
    enum ErrorType:CustomError{
        case Service
        case BadURL
        case NoDataFound
        case duplicate
        var notFound: API.ErrorType{
            .NoDataFound
        }
        
        var duplicate: API.ErrorType{
            .duplicate
        }
        
        var errorDescription: String? {
          switch self {
          case .Service: return "Service unreachable"
          case .BadURL: return "Invalid URL"
          case .NoDataFound: return "No data found"
          case .duplicate: return "Duplicate found"
          }
        }
    }
    enum EndPoints{
        static let baseURL = "https://openexchangerates.org/api/latest.json"
        case allCurrencies(_ appID:String)
        var url:URL?{
            switch self{
            case .allCurrencies(let appID):
                guard var urlComponents = URLComponents(string: EndPoints.baseURL) else{
                    return nil
                }
                urlComponents.queryItems = [
                    URLQueryItem(name: "app_id", value: appID)
                ]
                guard let urlStr = urlComponents.url else{
                    return nil
                }
                return urlStr
            }
        }
    }
}
