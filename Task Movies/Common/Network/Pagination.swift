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
    private var isPageLoading = true
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
            minPage = 1
        }
        pageSubject = BehaviorSubject<Int>(value: minPage)
        currentPage = minPage
    }

    private func readIsPageLoading() -> Bool {
        queue.sync {
            return isPageLoading
        }
    }

    private func writeIsPageLoading(value: Bool) {
        queue.sync {
            self.isPageLoading = value
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
            self.writeIsPageLoading(value: false)
        }
        .do { error in
            self.writeIsPageLoading(value: false)
        }
    }

    func reset(to params: Parameters) {
        requestParams = params
        pageSubject.on(.next(minPage))
    }

    func loadNextPage() {
        guard !readIsPageLoading() else { return }
        currentPage += 1
        writeIsPageLoading(value: true)
        pageSubject.on(.next(currentPage))
    }

    func refresh() {
        currentPage = minPage
        writeIsPageLoading(value: true)
        pageSubject.on(.next(currentPage))
    }

    private func loadFromNetwork(page: Int = 0) -> Single<T?> {
        var params = requestParams
        params.updateValue(page, forKey: "page")
        return networkService.fetchData(urlString: urlString, parameters: params)
            .do(onError: { _ in
                self.writeIsPageLoading(value: false)
                if self.currentPage > self.minPage {
                    self.currentPage -= 1
                }
            })
            .catchAndReturn(nil)
    }

}
