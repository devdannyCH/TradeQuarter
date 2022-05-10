//
//  TickerRepositoryTests.swift
//  TradeQuarterTests
//
//  Created by Danny Dev on 09.05.22.
//

import XCTest
import Combine
import Alamofire
import CoreData
@testable import TradeQuarter

class MockTickerService: TickerServiceProtocol {
    
    var data: [TickerDTO]?
    var error: Error?
    
    public func getTickers() -> AnyPublisher<[TickerDTO], Error> {
        if let data = data {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}

class TickerRepositoryTests: XCTestCase {
    
    private let mockTickerService = MockTickerService()
    private let mockTickerDao = TickerDao(viewContext: PersistenceController.preview.container.viewContext)
    
    override func setUpWithError() throws {
        mockTickerService.data = nil
        mockTickerService.error = nil
    }
    
    func testSyncTickersSuccess() throws {
        mockTickerService.data = [btcDTO, ethDTO]
        let repo = TickerRepository(service: mockTickerService, dao: mockTickerDao)
        let tickers = try awaitPublisher(repo.syncTickers())
        XCTAssertEqual(tickers.count, 2)
    }
    
    func testSyncTickersServiceFailure() throws {
        mockTickerService.error = AFError.explicitlyCancelled
        do{
            let repo = TickerRepository(service: mockTickerService, dao: mockTickerDao)
          _ = try awaitPublisher(repo.syncTickers())
        }catch{
            XCTAssert(error is TickersError)
        }
    }

}
