//
//  DisneyTakeHomeTests.swift
//  DisneyTakeHomeTests
//
//  Created by Oliver Paray on 4/24/25.
//

import Foundation
import Testing
import OpenAPIRuntime
import OpenAPIURLSession
@testable import DisneyTakeHome

struct DisneyTakeHomeTests {

    @Test func example() async throws {
        let client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        await #expect(throws: Never.self) {
            let response = try await client.getAnimeSearch(query: .init(q: "Solo Leveling", unapproved: true, page: 3, limit: 25, sfw: false, orderBy: "title"))
            switch response {
            case .ok(let okResult):
                print("Ok Result:\n\(okResult)")
            case .undocumented(statusCode: let statusCode, let unknownPayLoad):
                print("Status code:\(statusCode)\nPayload:\(unknownPayLoad)")
            case .badRequest(let badRequest):
                print("Bad Request: \(badRequest)")
            }
        }
    }
}
