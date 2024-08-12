//
//  Router.swift
//  Task Movies
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation

protocol Router {

    func showNoInternetAlert()
    func navigateToDetails(movieID: Int)
    func navigateBack()
    func navigateToTrailer(url: URL?)
    func navigateToPoster(url: URL?)
    func navigateToSorting(
        sortUIModels: [MovieSortTypeUIModel],
        onSelect: @escaping (MovieSortTypeUIModel) -> Void)
}
