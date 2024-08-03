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
                title = "By Rating (Ascending)"
            case .ratingDescending:
                title = "By Rating (Descending)"
            case .popularityAscending:
                title = "By Popularity (Ascending)"
            case .popularityDescending:
                title = "By Popularity (Descending)"
            case .revenueDescending:
                title = "By Revenue (Descending)"
            case .revenueAscending:
                title = "By Revenue (Ascending)"
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
