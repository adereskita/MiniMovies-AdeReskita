//
//  MovieDetailEntity.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation

// MARK: - MoviesDetailModel
public struct MoviesDetailModel: Codable {
    let runtime: Int?
    let status, backdropPath, overview, title: String?
    let voteCount: Int?
    let tagline: String?
    let belongsToCollection: BelongsToCollection?
    let originalTitle, originalLanguage, posterPath: String?
    let productionCountries: [ProductionCountry]?
    let revenue: Int?
    let homepage: String?
    let video: Bool?
    let imdbID: String?
    let id: Int?
    let releaseDate: String?
    let budget: Int?
    let popularity: Double?
    let genres: [GenreModel]?
    let productionCompanies: [ProductionCompany]?
    let adult: Bool?
    let spokenLanguages: [SpokenLanguage]?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case runtime, status
        case backdropPath = "backdrop_path"
        case overview, title
        case voteCount = "vote_count"
        case tagline
        case belongsToCollection = "belongs_to_collection"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case revenue, homepage, video
        case imdbID = "imdb_id"
        case id
        case releaseDate = "release_date"
        case budget, popularity, genres
        case productionCompanies = "production_companies"
        case adult
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
    }
}

// MARK: - BelongsToCollection
public struct BelongsToCollection: Codable {
    let backdropPath: String?
    let id: Int?
    let name, posterPath: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, name
        case posterPath = "poster_path"
    }
}

// MARK: - ProductionCompany
public struct ProductionCompany: Codable {
    let logoPath: String?
    let id: Int?
    let originCountry, name: String?

    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case id
        case originCountry = "origin_country"
        case name
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let name, iso3166_1: String?

    enum CodingKeys: String, CodingKey {
        case name
        case iso3166_1 = "iso_3166_1"
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, name, iso639_1: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
        case iso639_1 = "iso_639_1"
    }
}

// MARK: - MoviesReviewModel
public struct MoviesReviewModel: Codable {
    let id, page: Int?
    let results: [ReviewResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
public struct ReviewResult: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content, createdAt, id, updatedAt: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
public struct AuthorDetails: Codable {
    let name, username, avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

// MARK: - MoviesVideosModel
struct MoviesVideosModel: Codable {
    let id: Int?
    let results: [VideosResult]?
}

// MARK: - Result
struct VideosResult: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let publishedAt, site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key
        case publishedAt = "published_at"
        case site, size, type, official, id
    }
}
