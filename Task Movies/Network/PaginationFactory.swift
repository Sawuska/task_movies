//
//  PaginationFactory.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
import Alamofire

final class PaginationFactory<T: Decodable> {

    private let networkService: NetworkService<T>

    init(networkService: NetworkService<T>) {
        self.networkService = networkService
    }

    func create(urlString: String, requestParams: Parameters) -> Pagination<T> {
        return Pagination(networkService: networkService, requestParams: requestParams, urlString: urlString)
    }
}
