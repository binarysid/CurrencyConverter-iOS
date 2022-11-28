//
//  CurrencyAPITTest.swift
//  CurrencyConverterTests
//
//  Created by Linkon Sid on 14/10/22.
//

import XCTest
import Combine
@testable import CurrencyConverter

final class CurrencyAPIMockDataTest: XCTestCase {
    var apiClient: MockAPIClient!
    var apiWorker:APIWorker<MockAPIClient>!
    var expectation:XCTestExpectation!
    var subscriptions = Set<AnyCancellable>()
    let testBundle = Bundle(for: CurrencyAPIMockDataTest.self)
    func testCurrencyFetchRequest(){
        subscribeToPublisher()
        if let url =
            testBundle.url(forResource:"@Mock-ExchangeRates",withExtension:"json"){
            do
            {
                let data = try Data(contentsOf: url)
                let json = try JSONDecoder().decode(ExchangeRates.self, from: data)
                apiClient.result = Result.success(json).publisher.eraseToAnyPublisher()
            }catch{
                XCTFail("Invalid data request")
                self.expectation.fulfill()
            }
        }
        apiWorker.requestForDomainData()
        self.waitForExpectations(timeout: 0.0, handler: nil)
    }

    private func subscribeToPublisher(){
        apiWorker.resultPublisher.sink(receiveCompletion: {completion in
            if case .failure(_) = completion{
                XCTFail("completion failed")
                self.expectation.fulfill()
            }
            
        }, receiveValue: { domainObject in
            XCTAssertGreaterThan(domainObject.count, 0)
            self.expectation.fulfill()
        })
        .store(in: &subscriptions)
    }
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiClient = MockAPIClient()
        apiWorker = APIWorker(client: apiClient)
        expectation = expectation(description: "Currency parse expectation")
    }

    override func tearDownWithError() throws {
        apiClient = nil
        apiWorker = nil
        try super.tearDownWithError()
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
