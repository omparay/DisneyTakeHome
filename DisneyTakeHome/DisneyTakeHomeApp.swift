//
//  DisneyTakeHomeApp.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI

@main
struct DisneyTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SearchView().background(Color.green.opacity(0.3))
            }
        }
    }
}
