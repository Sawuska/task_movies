//
//  MovieSortTypeUIMapper.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation

final class MovieSortTypeUIMapper {
    
    func mapSortTypesToUI(
        sortTypes: [MovieSortType],
        currentSortType: MovieSortType
    ) -> [MovieSortTypeUIModel] {
        sortTypes.map { sortType in
            let title: String
            switch(sortType) {
            case .ratingAscending:
                title = String(localized: "By Rating (Ascending)")
            case .ratingDescending:
                title = String(localized: "By Rating (Descending)")
            case .popularityAscending:
                title = String(localized: "By Popularity (Ascending)")
            case .popularityDescending:
                title = String(localized: "By Popularity (Descending)")
            case .revenueDescending:
                title = String(localized: "By Revenue (Descending)")
            case .revenueAscending:
                title = String(localized: "By Revenue (Ascending)")
            }
            return MovieSortTypeUIModel(
                id: sortType.rawValue,
                title: title,
                isSelected: currentSortType == sortType)
        }
    }

    func mapUIToSortType(uiModel: MovieSortTypeUIModel) -> MovieSortType?  {
        MovieSortType(rawValue: uiModel.id)
    }
}
