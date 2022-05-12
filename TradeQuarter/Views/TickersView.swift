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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.lastPrice, order: .reverse)])
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
                    if !viewModel.isConnected || viewModel.error != nil {
                        Image(systemName: "icloud.slash").foregroundColor(.red).opacity(0.8)                    }else {
                            Image(systemName: "checkmark.icloud").foregroundColor(.green)
                                .opacity(viewModel.showSyncAnimation ? 0.8 : 0)
                                .animation(.linear(duration: 0.3), value: viewModel.showSyncAnimation)
                        }
                }
            }else{
                VStack{
                    Text((searchQuery.isEmpty ? "Marketplace" : "Search") + " Unavailable").font(.headline)
                    Text(!viewModel.isConnected ? "TradeQuarter isn't connected to the internet." : "TradeQuarter has no data to display").font(.callout)
                    if let error = viewModel.error {
                        Text(error.localizedDescription).font(.callout)
                    }
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
            viewModel.syncTickersEvery5s()
        }
    }
}

struct TickersView_Previews: PreviewProvider {
    static var previews: some View {
        TickersView()
    }
}
