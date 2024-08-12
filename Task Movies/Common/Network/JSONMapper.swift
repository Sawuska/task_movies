//
//  JSONMapper.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation
final class JSONMapper<T: Decodable> {

    func mapData(_ data: Data) -> T? {
        var response: T?
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            response = try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return response
    }
}
