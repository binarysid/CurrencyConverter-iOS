//
//  CurrencyAPITest.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 21/11/22.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyAPITest: XCTestCase {
    var urlRequest:URLRequest?
    var expectation:XCTestExpectation!
    
    override func setUpWithError() throws {
        guard let url = API.EndPoints.allCurrencies(AppConstants.Config.APPID).url else{
            return
        }
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = API.HTTPMethods.GET
        expectation = expectation(description: "server responds in time")
    }

    override func tearDownWithError() throws {
        urlRequest = nil
    }

//    func testAPIHttpResponse() throws {
//        defer{
//            waitForExpectations(timeout: 3)
//        }
//        guard let url = urlRequest else{return}
//        URLSession.shared.dataTask(with: url){data,response,error in
//            defer{self.expectation.fulfill()}
////            XCTAssertNil(data)
////            XCTAssertNil(response)
//            XCTAssertNil(error)
//            do{
//                let response = try XCTUnwrap(response as? HTTPURLResponse)
//                XCTAssertEqual(response.statusCode, 200)
//                let data = try XCTUnwrap(data)
//                XCTAssertNoThrow(
//                    try JSONDecoder().decode(ExchangeRates.self, from: data)
//                )
//            }catch{}
//        }
//        .resume()
//    }
//    func testAPI404() throws {
//        defer{
//            waitForExpectations(timeout: 3)
//        }
//        guard let url = urlRequest else{return}
//        URLSession.shared.dataTask(with: url){data,response,error in
//            defer{self.expectation.fulfill()}
////            XCTAssertNil(data)
////            XCTAssertNil(response)
//            XCTAssertNil(error)
//            do{
//                let response = try XCTUnwrap(response as? HTTPURLResponse)
//                XCTAssertEqual(response.statusCode, 404)
//                let data = try XCTUnwrap(data)
//                XCTAssertThrowsError(
//                    try JSONDecoder().decode(ExchangeRates.self, from: data)
//                ){ error in
//                    guard case DecodingError.dataCorrupted = error else{
//                        XCTFail("\(error)")
//                        return
//                    }
//
//                }
//            }catch{}
//        }
//        .resume()
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
