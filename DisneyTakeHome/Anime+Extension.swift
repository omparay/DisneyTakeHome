//
//  Anime+Extension.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//

import Foundation

extension Components.Schemas.Anime {
    
    func getDefaultTitle() async -> String {
        guard let titles = self.titles else {
            return String()
        }
        let filteredTitles = titles.filter {
            $0._type == "English"
        }
        if let defaultTitle = filteredTitles.first {
            return defaultTitle.title ?? String()
        } else {
            return titles.first?.title  ?? String()
        }
    }
    
    func getDescription() -> String {
        return self.synopsis ?? String()
    }
    
    func getSmallImageURL() -> URL {
        if let smallImageUrl = images?.jpg?.smallImageUrl, let result = URL(string: smallImageUrl) {
            return result
        } else {
            return URL(string:"https://static.thenounproject.com/png/1400397-200.png")!
        }
    }
    
    func getImageUrl() -> URL {
        if let imageUrl = images?.jpg?.imageUrl, let result = URL(string: imageUrl) {
            return result
        } else {
            return URL(string:"https://static.thenounproject.com/png/1400397-200.png")!
        }
    }
}
