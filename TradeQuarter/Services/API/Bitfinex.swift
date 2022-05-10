//[
//  0 SYMBOL,
//  1 BID,
//  2 BID_SIZE,
//  3 ASK,
//  4 ASK_SIZE,
//  5 DAILY_CHANGE,
//  6 DAILY_CHANGE_RELATIVE,
//  7 LAST_PRICE,
//  8 VOLUME,
//  9 HIGH,
//  10 LOW
//],

struct FieldIndexes{
    let symbol = 0
    let dailyChange = 6
    let lastPrice  = 7
}

struct  Bitfinex  {
    static let fieldIndexes = FieldIndexes()
    static let url = "https://api-pub.bitfinex.com/v2"
    static let tickersEndpoint = url+"/tickers?symbols=tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,tEOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tLUNA:USD,tMATIC:USD,tNEXO:USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD"
}

// MARK: JSON serialization
extension TickerDTO {

    enum SerializationError: Error {
        case missing(String)
    }

    init(jsonArray: [Any]) throws {
        guard var symbol = jsonArray[Bitfinex.fieldIndexes.symbol] as? String else {
            throw SerializationError.missing("symbol")
        }
        symbol.removeFirst()
        symbol.removeAll{$0==":"}
        symbol.removeLast(3)
        guard let dailyChange = jsonArray[Bitfinex.fieldIndexes.dailyChange] as? Double else {
            throw SerializationError.missing("dailyChange")
        }
        guard let lastPrice = jsonArray[Bitfinex.fieldIndexes.lastPrice] as? Double else {
            throw SerializationError.missing("lastPrice")
        }
        self.symbol = symbol
        self.lastPrice = lastPrice
        self.dailyChange = dailyChange
    }
}
