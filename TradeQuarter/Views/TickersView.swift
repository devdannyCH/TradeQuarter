//
//  TickersView.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import SwiftUI

struct TickersView: View {
    // MARK: - View Model
    @StateObject private var viewModel: TickersViewModel = TickersViewModel();
    
    // MARK: - Core Data
    @FetchRequest(sortDescriptors: [SortDescriptor(\.symbol, order: .forward)])
    private var tickers: FetchedResults<Ticker>
    
    // MARK: - Search
    @State private var searchQuery: String = ""

    
    var body: some View {
        NavigationView {
            if !tickers.isEmpty {
                List(tickers) { ticker in
                    TickerCell(ticker: ticker)
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    viewModel.syncTickers()
                }
                .navigationTitle("Marketplace")
                .toolbar{
                    if !viewModel.isConnected{
                        Image(systemName: "icloud.slash").foregroundColor(.red)
                    }
                }
            }else if !viewModel.isConnected{
                VStack{
                    Text((searchQuery.isEmpty ? "Marketplace" : "Search") + " Unavailable").font(.headline)
                    Text("TradeQuarter isn't connected to the internet.").font(.callout)
                }.foregroundColor(.gray)

            }else if let error = viewModel.error {
                VStack{
                    Text("An error has occured").font(.headline)
                    Text(error.localizedDescription).font(.callout)
                }.foregroundColor(.gray)
            }else{
                VStack{
                    Text("Data Unavailable").font(.headline)
                    Text("TradeQuarter has no data to display").font(.callout)
                }.foregroundColor(.gray)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchQuery){ newSearch in
            if newSearch.isEmpty {
                tickers.nsPredicate = nil
            }else{
                tickers.nsPredicate = Ticker.searchBySymbolPredicate(query: searchQuery)
            }
        }
        .onAppear(){
            viewModel.syncTickers()
        }
    }
}

struct TickersView_Previews: PreviewProvider {
    static var previews: some View {
        TickersView()
    }
}
