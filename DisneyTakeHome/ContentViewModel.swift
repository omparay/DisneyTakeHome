//
//  ContentViewModel.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showNSFW: Bool = false
    @Published var showUnapproved: Bool = false
    @Published var orderBy: String = "title"
    @Published var page: Int = 1
    @Published var limit: Int = 25
    @Published var searchResults = [Components.Schemas.Anime]()
    @Published var pagingState: Components.Schemas.PaginationPlus.PaginationPayload = .init()
    @Published var genericDisplay: String = ""
    var totalPages: Int {
        get {
            if let maxPages = pagingState.lastVisiblePage {
                return maxPages
            } else {
                return 1
            }
        }
    }
    
    func performSearch() async {
        if searchText.isEmpty {
            searchResults = []
            await resetPaging()
        } else {
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
                            Task.detached { @MainActor in
                                self.searchResults = dataResults
                            }
                        }
                        if let paginationResults = jsonData.value2.pagination {
                            Task.detached { @MainActor in
                                self.pagingState = paginationResults
                            }
                        }
                    }
                case .badRequest(_):
                    Task.detached { @MainActor in
                        self.genericDisplay = "Stay calm... try again later"
                    }
                case .undocumented(statusCode: let statusCode, _):
                    Task.detached { @MainActor in
                        self.genericDisplay = "Status code: \(statusCode)... please try again later"
                    }
                }
            } catch {
                genericDisplay = "Stay calm... try again later"
            }
        }
    }
    
    func nextPage() async {
        guard let maxPage = pagingState.lastVisiblePage else { return }
        if page+1 <= maxPage {
            await MainActor.run {
                page += 1
            }
            await performSearch()
        }
    }
    
    func previousPage() async {
        if page-1 > 0 {
            await MainActor.run {
                page -= 1
            }
            await performSearch()
        }
    }
    
    func resetPaging() async {
        await MainActor.run {
            page = 1
        }
    }
}

