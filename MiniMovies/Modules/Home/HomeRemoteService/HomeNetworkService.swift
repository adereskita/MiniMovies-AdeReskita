//
//  HomeNetworkService.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation

public protocol HomeNetworkServiceProtocol {
    func fetchGenres(completionHandler: @escaping (Result<HomeGenreModel, APIError>) -> Void)
    func fetchPopularMovies(genreID: Int, completionHandler: @escaping (Result<MovieLists, APIError>) -> Void)
}

public class HomeNetworkService: BaseAPI<HomeNetworking>, HomeNetworkServiceProtocol {

    public override init() {}
    
    public func fetchGenres(completionHandler: @escaping (Result<HomeGenreModel, APIError>) -> Void) {
        self.fetchData(target: .fetchGenres, responseClass: HomeGenreModel.self) { (result) in
            completionHandler(result)
        }
    }
    
    public func fetchPopularMovies(genreID: Int, completionHandler: @escaping (Result<MovieLists, APIError>) -> Void) {
        self.fetchData(target: .fetchPopularMovies(genreID: genreID), responseClass: MovieLists.self) { (result) in
            completionHandler(result)
        }
    }
}
