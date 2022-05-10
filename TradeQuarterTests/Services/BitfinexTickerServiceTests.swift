//
//  BitfinexTickerServiceTests.swift
//  TradeQuarterTests
//
//  Created by Danny Dev on 09.05.22.
//

import XCTest
import Combine
import Alamofire
import Mocker
@testable import TradeQuarter

class BitfinexTickerServiceTests: XCTestCase {
    
    func testGetTickersSuccess() throws {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let session = Session(configuration: configuration)
        let apiEndpoint = URL(string: Bitfinex.tickersEndpoint)!
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: bitfinexJson.data(using: .utf8)!])
        mock.register()
        let service = BitfinexTickerService(session: session)
        let tickers: [TickerDTO] = try awaitPublisher(service.getTickers())
        XCTAssertEqual(tickers, [btcDTO, ethDTO])
    }
    
    func testGetTickersFailure() throws {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let session = Session(configuration: configuration)
        let apiEndpoint = URL(string: Bitfinex.tickersEndpoint)!
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 500, data: [.get: bitfinexJson.data(using: .utf8)!])
        mock.register()
        let service = BitfinexTickerService(session: session)
        do{
            _ = try awaitPublisher(service.getTickers())
        }catch{
            XCTAssert(error is TickersError)
        }
    }
    
}
