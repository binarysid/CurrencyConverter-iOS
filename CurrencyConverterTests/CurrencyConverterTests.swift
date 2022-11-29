//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 8/10/22.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    var worker:ConversionWorker?
    override func setUpWithError() throws {
        worker = ConversionWorker()
    }
    
    override func tearDownWithError() throws {
        worker = nil
    }
    func testEUROToGBPonversion(){
        let expected = 0.87
        let units:Double = 1
        guard let val = worker?.convert(givenCurrencyRateInUSD: 1.02956, expectedCurrencyRateInUSD: 0.900769, amount: units) else{return}
        
        XCTAssertTrue(val.checkEqual(to: expected, decimalPoint: 1))
    }
    func testGBPToPLNConversion(){
        let expected = 55.33
        let units:Double = 10
        guard let val = worker?.convert(givenCurrencyRateInUSD: 0.901998, expectedCurrencyRateInUSD: 4.98899, amount: units) else{return}
        XCTAssertTrue(val.checkEqual(to: expected, decimalPoint: 1))
    }
    func testEURToCZKConversion(){
        let expected = 244.95
        let units:Double = 10
        guard let val = worker?.convert(givenCurrencyRateInUSD: 1.026167, expectedCurrencyRateInUSD: 25.1363, amount: units) else{return}
        
        XCTAssertTrue(val.checkEqual(to: expected, decimalPoint: 1))
    }
    func testEURToBDTConversion(){
        let expected = 105.0
        let units:Double = 1
        guard let val = worker?.convert(givenCurrencyRateInUSD: 0.97, expectedCurrencyRateInUSD: 101.69, amount: units) else{return}
        XCTAssertEqual(val, expected)
//        XCTAssertTrue(val.checkEqual(to: expected, decimalPoint: 1))
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
