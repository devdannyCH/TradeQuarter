# TradeQuarter
Crypto marketplace that displays a list of crypto trading pairs with USD. The data is updated automatically every 5 seconds.

## Requirements

- iOS 15.4+
- Xcode 13.3.1

## How to run

Preview the request in your terminal.
- > $ git clone https://github.com/devdannyCH/TradeQuarter.git
- > $ cd TradeQuarter 
- > $ open TradeQuarter.xcodeproj
- ⌘R in XCode

## API

### GET `https://api-pub.bitfinex.com/v2//tickers?symbols=tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,tEOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tLUNA:USD,tMATIC:USD,tNEXO:USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD`
``` 
[
  [
    SYMBOL,
    BID, 
    BID_SIZE, 
    ASK, 
    ASK_SIZE, 
    DAILY_CHANGE, 
    DAILY_CHANGE_RELATIVE, 
    LAST_PRICE, 
    VOLUME, 
    HIGH, 
    LOW
  ],
  ...
]
```

Preview the request in your terminal.
> $ curl https://api-pub.bitfinex.com/v2//tickers?symbols=tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,tEOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tLUNA:USD,tMATIC:USD,tNEXO:USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD

## Dependencies

 - [Alamofire 5.6.1](https://github.com/Alamofire/Alamofire)

## Test Dependencies

 - [Mocker 2.5.5](https://github.com/WeTransfer/Mocker)
