//
//  Constants.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation

public struct Constants {
    
    public enum ConfigAPI: String {
        case host = "https://api.themoviedb.org/3/"
        case image = "https://image.tmdb.org/t/p/w500/"
        case youtube = "https://www.youtube.com/watch?v="
    }
    
    public enum APIKey: String {
        case movieAPI = "1f8943413f710ee5afdca40a33f4d021"
        case movieAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZjg5NDM0MTNmNzEwZWU1YWZkY2E0MGEzM2Y0ZDAyMSIsInN1YiI6IjY0ODg3N2EyNmY4ZDk1MDExZjIzOGNkOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Gmwz5-7JUPGx3Q6hXB7JRs9ZpS2iomwvCpE_TlZqPog"
    }
    
    public enum hostAPI {
        case hostAPI
        case imageAPI
        case youtube
    }
    
    public static func setBaseUrl(_ api: Constants.hostAPI) -> String {
        switch api {
        case .hostAPI:
            let url = Constants.ConfigAPI.host.rawValue
            return url
        case .imageAPI:
            let url = Constants.ConfigAPI.image.rawValue
            return url
        case .youtube:
            let url = Constants.ConfigAPI.youtube.rawValue
            return url
        }
    }
}
