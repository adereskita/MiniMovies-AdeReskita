//
//  GenreMoviesNetworking.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import Alamofire

public enum GenreMoviesNetworking {
    case fetchDiscoverMoviesBy(genreID: Int, page: Int)
}

extension GenreMoviesNetworking: TargetType {
    
    public var baseURL: String {
        switch self {
        default:
            return Constants.setBaseUrl(.hostAPI)
        }
    }
    
    // MARK: API Path
    public var path: String {
        switch self {
        case .fetchDiscoverMoviesBy(let genreID, let page):
            return "discover/movie?with_genres=\(genreID)&page=\(page)"
        }
    }
    
    public var method: HTTPMethods {
        switch self {
        case .fetchDiscoverMoviesBy:
            return .get
        }
    }
    
    //The parameters (Queries) APIs
    public var task: Task {
        switch self {
        case .fetchDiscoverMoviesBy:
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
