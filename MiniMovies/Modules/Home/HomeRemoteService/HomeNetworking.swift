//
//  HomeNetworking.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation
import Alamofire

public enum HomeNetworking {
    case fetchGenres
    case fetchPopularMovies(genreID: Int)
}

extension HomeNetworking: TargetType {
    
    public var baseURL: String {
        switch self {
        default:
            return Constants.setBaseUrl(.hostAPI)
        }
    }
    
    // MARK: API Path
    public var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchPopularMovies(let genreID):
            return "movie/popular?with_genres=\(genreID)"
        }
    }
    
    public var method: HTTPMethods {
        switch self {
        case .fetchGenres:
            return .get
        case .fetchPopularMovies:
            return .get
        }
    }
    
    //The parameters (Queries) APIs
    public var task: Task {
        switch self {
        case .fetchGenres:
            return .requestPlain
        case .fetchPopularMovies:
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
