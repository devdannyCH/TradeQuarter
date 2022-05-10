//
//  TickerCell.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import SwiftUI

struct TickerCell: View {
    
    var ticker: Ticker
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = "+"
        return formatter
    }
    
    var body: some View {
        ZStack{
            HStack{
                Text(ticker.symbol ?? "???").font(Font.body.weight(.bold))
                Spacer()
                VStack(alignment: .trailing, spacing: 4){
                    Text("$"+String(format: "%.2f",  ticker.lastPrice))  .font(Font.body.weight(.bold))
                    Text(numberFormatter.string(from: ticker.dailyChange as NSNumber)!).foregroundColor( ticker.decreasing ? .red : .green)
                }
            }.padding(.vertical, 4)
        }
    }
}

struct TickerCell_Previews: PreviewProvider {
    static var previews: some View { 
        let context = PersistenceController.preview.container.viewContext
        let ticker = Ticker(context: context)
        ticker.symbol = "tBTCUSD"
        ticker.lastPrice = 39630.06427442
        ticker.dailyChange = +1.0852
        return TickerCell(ticker: ticker)
    }
}
