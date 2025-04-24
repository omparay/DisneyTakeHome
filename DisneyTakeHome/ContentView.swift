//
//  ContentView.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

@Observable
class ContentViewModel {
    var searchText: String = ""
    var showNSFW: Bool = false
    var showUnapproved: Bool = false
    var orderBy: String = "title"
    var page: Int = 1
    var limit: Int = 25
    var searchResults = [Components.Schemas.Anime]()
    var pagingState: Components.Schemas.PaginationPlus.PaginationPayload = .init()
    var genericDisplay: String = ""
    
    func performSearch() async {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )

            let response = try await client.getAnimeSearch(
                query: .init(q: searchText, unapproved: showUnapproved, page: page, limit: limit, sfw: showNSFW, orderBy: orderBy)
            )

            switch response {
            case .ok(let okResult):
                switch okResult.body {
                case .json(let jsonData):
                    if let dataResults = jsonData.value1.data {
                        searchResults = dataResults
                    }
                    if let paginationResults = jsonData.value2.pagination {
                        pagingState = paginationResults
                    }
                }
            case .badRequest(_):
                genericDisplay = "Stay calm... try again later"
            case .undocumented(statusCode: let statusCode, _):
                genericDisplay = "Status code: \(statusCode)... please try again later"
            }
        } catch {
            genericDisplay = "Stay calm... try again later"
        }
    }
}

struct ContentView: View {
    @Bindable var viewModel = ContentViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Search:")
                VStack {
                    TextField("Enter search text", text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) {
                            Task {
                                await viewModel.performSearch()
                            }
                        }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            Spacer()
            if let totalPages = viewModel.pagingState.lastVisiblePage, totalPages > 0 {
                Text("I have \(totalPages) pages of data")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView().background(Color.green.opacity(0.2))
}
