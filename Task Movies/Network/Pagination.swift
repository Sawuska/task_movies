//
//  Pagination.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
import RxSwift
import Alamofire

final class Pagination<T: Decodable> {

    typealias Page = (objects: T, pageNumber: Int)

    private let pageSubject: BehaviorSubject<Int>

    private var currentPage = 0
    private let minPage: Int
    private var isPageRefreshing = false
    private var requestParams: Parameters
    private let networkService: NetworkService<T>
    private let urlString: String
    private let queue = DispatchQueue.global(qos: .userInitiated)

    init(networkService: NetworkService<T>, requestParams: Parameters, urlString: String) {
        self.networkService = networkService
        self.urlString = urlString
        self.requestParams = requestParams
        if let page = requestParams["page"] as? Int {
            minPage = page
        } else {
            minPage = 0
        }
        pageSubject = BehaviorSubject<Int>(value: minPage)
        currentPage = minPage
    }

    func readIsPageRefreshing() -> Bool {
        queue.sync {
            return isPageRefreshing
        }
    }

    func writeIsPageRefreshing(value: Bool) {
        queue.async(flags: .barrier) {
            self.isPageRefreshing = value
        }
    }

    func observe() -> Observable<T> {
        pageSubject.flatMap { page in
            self.loadFromNetwork(page: page)
        }
        .flatMap { page in
            if let page = page {
                return Observable.just(page)
            } else {
                return Observable.empty()
            }
        }
        .do { _ in
            self.writeIsPageRefreshing(value: false)
        }
        .do { error in
            self.writeIsPageRefreshing(value: false)
        }
    }

    func reset(to params: Parameters) {
        requestParams = params
        pageSubject.on(.next(minPage))
    }

    func loadNextPage() {
        guard !readIsPageRefreshing() else { return }
        currentPage += 1
        writeIsPageRefreshing(value: true)
        pageSubject.on(.next(currentPage))
    }

    private func loadFromNetwork(page: Int = 0) -> Single<T?> {
        var params = requestParams
        params.updateValue(page, forKey: "page")
        return networkService.fetchData(urlString: urlString, parameters: params)
            .do(onError: { _ in
                self.writeIsPageRefreshing(value: false)
                if self.currentPage > self.minPage {
                    self.currentPage -= 1
                }
            })
            .catchAndReturn(nil)
    }

}
