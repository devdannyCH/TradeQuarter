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
                VStack(spacing: 8){
                    Text(errorTitle).font(.headline)
                    Text(errorSubtitle).font(.callout).multilineTextAlignment(.center)
                }.foregroundColor(.gray).padding(32)
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
    
    //MARK: - Dynamic labels
    private var errorTitle: String {
        if(searchQuery.isEmpty){
            if(viewModel.isConnected){
                if let error = viewModel.error {
                    switch(error){
                    case .networkError(error: _):
                        return "Network Error"
                    case .peristenceError(error: _):
                        return "Marketplace Unavailable"
                    case .unknownError(error: _):
                        return "Marketplace Unavailable"
                    }
                }
            }else{
                return "Not connected"
            }
            return "Marketplace Unavailable"
        }else{
            return ("No results found")
        }
    }
    
    private var errorSubtitle: String {
        if(searchQuery.isEmpty){
            if(viewModel.isConnected){
                if let error = viewModel.error {
                    switch(error){
                    case .networkError(error: _):
                        return "TradeQuarter can't fetch data, try again later."
                    case .peristenceError(error: let error):
                        return error.localizedDescription
                    case .unknownError(error: let error):
                        return error.localizedDescription
                    }
                }
            }else{
                return "TradeQuarter isn't connected to the internet. Check your connection and try again."
            }
            return "TradeQuarter can't fetch data, try again later."
        }else{
            return ("Try modifying your search")
        }
    }
}

struct TickersView_Previews: PreviewProvider {
    static var previews: some View {
        TickersView()
    }
}
