//
//  NetworkService.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkService<T: Decodable> {

    private let jsonMapper: JSONMapper<T>

    init(jsonMapper: JSONMapper<T>) {
        self.jsonMapper = jsonMapper
    }

    func fetchData(
        urlString: String,
        parameters: Parameters? = nil
    ) -> Single<T?> {
        return Single<T?>.create { single in
            let request = AF.request(urlString, parameters: parameters)
                .responseData(completionHandler: { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }

                    guard let responseData = response.data else {
                        let error = AFError.responseValidationFailed(reason: AFError.ResponseValidationFailureReason.dataFileNil)
                        single(.failure(error))
                        return
                    }
                    let mappedData = self.jsonMapper.mapData(responseData)
                    single(.success(mappedData))
                })

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
