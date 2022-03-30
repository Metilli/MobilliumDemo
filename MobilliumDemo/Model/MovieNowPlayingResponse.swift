//
//  MovieNowPlaying.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

struct MovieNowPlayingResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
