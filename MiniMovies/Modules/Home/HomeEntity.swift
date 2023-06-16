//
//  HomeEntity.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation

// MARK: - Welcome
public struct HomeGenreModel: Codable {
    let genres: [GenreModel]
}

// MARK: - Genre
public struct GenreModel: Codable {
    let id: Int
    let name: String
}


// MARK: - MovieLists
public struct MovieLists: Codable {
    let results: [MovieResult]?
    let totalPages, totalResults, page: Int?

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page
    }
}

// MARK: - Result
public struct MovieResult: Codable {
    let genreIDS: [Int]?
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let originalTitle: String?
    let voteAverage, popularity: Double?
    let posterPath, overview, title, originalLanguage: String?
    let voteCount: Int?
    let releaseDate: String?
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case popularity
        case posterPath = "poster_path"
        case overview, title
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case video
    }
}
