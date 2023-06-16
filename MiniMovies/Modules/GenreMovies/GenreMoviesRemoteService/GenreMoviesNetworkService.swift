//
//  GenreMoviesNetworkService.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation

public protocol GenreMoviesServiceProtocol {
    func fetchDiscoverMovies(genreID: Int, page: Int, completionHandler: @escaping (Result<MovieLists, APIError>) -> Void)
}

public class GenreMoviesNetworkService: BaseAPI<GenreMoviesNetworking>, GenreMoviesServiceProtocol {

    public override init() {}
    
    public func fetchDiscoverMovies(genreID: Int, page: Int, completionHandler: @escaping (Result<MovieLists, APIError>) -> Void) {
        self.fetchData(target: .fetchDiscoverMoviesBy(genreID: genreID, page: page), responseClass: MovieLists.self) { (result) in
            completionHandler(result)
        }
    }
}
