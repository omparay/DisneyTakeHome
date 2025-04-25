//
//  Anime+Extension.swift
//  DisneyTakeHome
//
//  Created by Oliver Paray on 4/24/25.
//


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
}
