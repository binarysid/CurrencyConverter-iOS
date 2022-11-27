//
//  CurrencyAPITTest.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 14/10/22.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyAPIMockDataTest: XCTestCase {
    let apiClient = MockAPIClient()
    func testCuurrencyFetchRequest(){
        apiClient.didReturnError = false
        let expectation = self.expectation(description: "Currency parse expectation")
        apiClient.fecthCurrencyList(){ result in
            switch result{
            case .success(let data):
                if let data = data{
                    do{
                        let resultData = try JSONDecoder().decode(ExchangeRates.self, from: data)
                        print(resultData)
                        XCTAssertNotNil(resultData)
                        expectation.fulfill()
                        
                    }catch{
                        XCTFail()
                    }
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        self.waitForExpectations(timeout: 4.0, handler: nil)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
