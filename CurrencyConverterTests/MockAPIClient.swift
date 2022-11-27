//
//  MockAPIClient.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 14/10/22.
//

import Combine
import XCTest
@testable import CurrencyConverter


final class MockAPIClient{
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
//        let testBundle = Bundle(for: MockAPIClient.self)
//        if let url =
//            testBundle.url(forResource:"@Mock-ExchangeRates",withExtension:"json"){
//            do
//            {
//                let data = try Data(contentsOf: url)
//                let json = try JSONDecoder().decode(ExchangeRates.self, from: data)
//            }catch{
//                print("error")
//            }
//        }
        
    }
}

extension MockAPIClient:APIClientProtocol{
    func getData(_ request: URLRequest) -> AnyPublisher<ExchangeRates, Error> {
//        var publisher = PassthroughSubject<ExchangeRates, API.ErrorType>()
        var fetchJobsResult: AnyPublisher<ExchangeRates, Error>!
        return fetchJobsResult
    }
    
    

}
