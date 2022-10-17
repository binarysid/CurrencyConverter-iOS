//
//  MockAPIClient.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation

@testable import CurrencyConverter

class MockAPIClient{
    var didReturnError = false
    var apiLoaded = false
    
    enum MockServiceError:Error{
        case noDataFound
    }
    func reset(){
        didReturnError = false
        apiLoaded = false
    }
    convenience init() {
        self.init(false)
    }
    init(_ shouldReturnError:Bool){
        self.didReturnError = shouldReturnError
    }
    let mockResponse = """
    {
      "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
      "license": "https://openexchangerates.org/license",
      "timestamp": 1665651600,
      "base": "USD",
      "rates": {
        "AED": 3.67301,
        "AFN": 85.586049,
        "ALL": 119.92627,
        "AMD": 403.176631,
        "ANG": 1.802582,
        "AOA": 439.58815,
        "ARS": 151.019763,
        "AUD": 1.591371,
        "AWG": 1.8,
        "AZN": 1.7,
        "BAM": 2.01332,
        "BBD": 2,
        "BDT": 101.690363,
        "BGN": 2.014631,
        "BHD": 0.377003,
        "BIF": 2066.598159,
        "BMD": 1,
        "BND": 1.436145,
        "BOB": 6.911247,
        "BRL": 5.2931,
        "BSD": 1,
        "BTC": 0.000052587351
        }
    }
    """
}

extension MockAPIClient:APIClientProtocol{
    func fecthCurrencyList(completionHandler: @escaping resultHandler) {
        apiLoaded = true
        if didReturnError{
            completionHandler(.failure(MockServiceError.noDataFound))
        }
        else{
            completionHandler(.success(Data(mockResponse.description.utf8)))
        }
    }
}
