//
//  TrailerMapper.swift
//  Task Movies
//
//  Created by Alexandra on 04.08.2024.
//

import Foundation

final class TrailerMapper {

    func mapFromResponse(response: MovieVideosResponse?) -> MovieTrailer? {
        guard let response = response else { return nil }
        let trailers = response.results.filter { trailer in
            return trailer.official == true && trailer.site == "YouTube" && trailer.type == "Trailer"
        }
        return trailers.first
    }
}
