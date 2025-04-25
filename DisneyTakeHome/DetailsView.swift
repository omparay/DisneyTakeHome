//
//  DetailsView.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import SwiftUI

struct DetailsView: View {
    var animeToDisplay: Components.Schemas.Anime
    @State var title: String = ""
    @State var imageUrl: URL = URL(string: "https://static.thenounproject.com/png/1400397-200.png")!
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack{
                    HStack{
                        Text("Title:")
                        Text(title)
                        Spacer()
                    }
                    AsyncImage(url: imageUrl)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: reader.size.width)
                    Text(animeToDisplay.getDescription())
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.3))
        .onAppear(){
            Task() {
                title = await animeToDisplay.getDefaultTitle()
                imageUrl = animeToDisplay.getImageUrl()
            }
        }
    }
}

#Preview {
    DetailsView(animeToDisplay: .init())
}
