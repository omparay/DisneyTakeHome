//
//  ContentView.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI

@MainActor
struct SearchView: View {
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Search:")
                VStack {
                    TextField("Enter search text", text: $viewModel.searchText)
                        .onReceive(viewModel.$searchText.debounce(for: .seconds(2), scheduler: DispatchQueue.main)) {
                            guard !$0.isEmpty else { return }
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
                    ListItemView(anime: $0)
                }
                .scrollContentBackground(.hidden)
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
            Spacer()
        }
        .padding()
    }
}

struct ListItemView: View {
    let anime: Components.Schemas.Anime
    @State var title: String = ""
    @State var imageUrl: URL = URL(string: "https://static.thenounproject.com/png/1400397-200.png")!
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top){
                AsyncImage(url: imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                Text(title)
            }
        }
        .listRowBackground(Color.clear)
        .background(.clear)
        .onAppear {
            Task() {
                title = await anime.getDefaultTitle()
                imageUrl = await anime.getSmallImageURL()
            }
        }
    }
}

#Preview {
    SearchView().background(Color.green.opacity(0.2))
}
