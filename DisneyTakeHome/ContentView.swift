//
//  ContentView.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI

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
            if let totalPages = viewModel.pagingState.lastVisiblePage, totalPages > 0 && !viewModel.searchText.isEmpty {
                List(viewModel.searchResults, id: \.malId) {
                    ListView(anime: $0)
                }
                .scrollContentBackground(.hidden)
                PagingControls(viewModel: viewModel)
            }
            Spacer()
        }
        .padding()
    }
}

struct ListView: View {
    let anime: Components.Schemas.Anime
    @State var title: String = ""
    var body: some View {
        Text(title)
        .listRowBackground(Color.clear)
        .background(.clear)
        .onAppear {
            Task() {
                title = await anime.getDefaultTitle()
            }
        }
    }
}

struct PagingControls: View {
    let viewModel: ContentViewModel
    var body: some View {
        HStack {
            Button {
                Task {
                    await viewModel.previousPage()
                }
            } label: {
                Image(systemName: "arrowshape.backward.circle.fill")
            }
            Spacer()
            Text("Page \(viewModel.page) of \(viewModel.totalPages)")
            Spacer()
            Button {
                Task {
                    await viewModel.nextPage()
                }
            } label: {
                Image(systemName: "arrowshape.forward.circle.fill")
            }
        }
    }
}

#Preview {
    ContentView().background(Color.green.opacity(0.2))
}
