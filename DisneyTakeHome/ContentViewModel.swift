//
//  ContentViewModel.swift
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
        }
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
    
    func nextPage() async {
        guard let maxPage = pagingState.lastVisiblePage else { return }
        if page+1 <= maxPage {
            page += 1
            await performSearch()
        }
    }
    
    func previousPage() async {
        if page-1 > 0 {
            page -= 1
            await performSearch()
        }
    }
    
    func resetPaging() async {
        page = 1
        await performSearch()
    }
}

