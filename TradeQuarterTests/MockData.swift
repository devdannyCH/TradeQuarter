//
//  FakeData.swift
//  TradeQuarterTests
//
//  Created by Danny Dev on 09.05.22.
//

@testable import TradeQuarter

let btcDTO = TickerDTO.init(symbol: "BTC", lastPrice: 31632, dailyChange: -0.0701)
let ethDTO = TickerDTO.init(symbol: "ETH", lastPrice: 2307.01772922, dailyChange: -0.0865)

let bitfinexJson = "[[\"tBTCUSD\",31621,8.90851069,31632,11.44868065,-2384,-0.0701,31632,14946.37299086,34775,31151],[\"tETHUSD\",2306.9,157.15842186,2307.4,270.36002753,-218.38227078,-0.0865,2307.01772922,60856.00477372,2574.8,2250]]"
