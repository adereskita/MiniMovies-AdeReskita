//
//  MovieDetailNetworking.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import Alamofire

public enum MovieDetailNetworking {
    case fetchMovieDetail(id: Int)
    case fetchMovieReview(moviesID: Int, page: Int)
    case fetchVideos(moviesID: Int)
}

extension MovieDetailNetworking: TargetType {
    
    public var baseURL: String {
        switch self {
        default:
            return Constants.setBaseUrl(.hostAPI)
        }
    }
    
    // MARK: API Path
    public var path: String {
        switch self {
        case .fetchMovieDetail(let moviesID):
            return "movie/\(moviesID)"
        case .fetchMovieReview(let moviesID, let page):
            return "movie/\(moviesID)/reviews?page=\(page)"
        case .fetchVideos(let moviesID):
            return "movie/\(moviesID)/videos"
        }
    }
    
    public var method: HTTPMethods {
        switch self {
        case .fetchMovieDetail:
            return .get
        case .fetchMovieReview:
            return .get
        case .fetchVideos:
            return .get
        }
    }
    
    //The parameters (Queries) APIs
    public var task: Task {
        switch self {
        case .fetchMovieDetail:
            return .requestPlain
        case .fetchMovieReview:
            return .requestPlain
        case .fetchVideos:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return [HttpHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HttpHeaderField.authentication.rawValue: "Bearer " + Constants.APIKey.movieAccessToken.rawValue]
        }
    }
}
