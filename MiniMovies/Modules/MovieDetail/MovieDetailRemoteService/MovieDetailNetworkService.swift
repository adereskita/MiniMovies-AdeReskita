//
//  MovieDetailNetworkService.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(moviesID: Int, completionHandler: @escaping (Result<MoviesDetailModel, APIError>) -> Void)
    func fetchMovieReview(moviesID: Int, page: Int, completionHandler: @escaping (Result<MoviesReviewModel, APIError>) -> Void)
    func fetchMovieVideos(moviesID: Int, completionHandler: @escaping (Result<MoviesVideosModel, APIError>) -> Void)
}

class MovieDetailNetworkService: BaseAPI<MovieDetailNetworking>, MovieDetailServiceProtocol {
    
    func fetchMovieDetail(moviesID: Int, completionHandler: @escaping (Result<MoviesDetailModel, APIError>) -> Void) {
        self.fetchData(target: .fetchMovieDetail(id: moviesID), responseClass: MoviesDetailModel.self) { (result) in
            completionHandler(result)
        }
    }
    
    func fetchMovieReview(moviesID: Int, page: Int, completionHandler: @escaping (Result<MoviesReviewModel, APIError>) -> Void) {
        self.fetchData(target: .fetchMovieReview(moviesID: moviesID, page: page), responseClass: MoviesReviewModel.self) { (result) in
            completionHandler(result)
        }
    }
    
    func fetchMovieVideos(moviesID: Int, completionHandler: @escaping (Result<MoviesVideosModel, APIError>) -> Void) {
        self.fetchData(target: .fetchVideos(moviesID: moviesID), responseClass: MoviesVideosModel.self) { (result) in
            completionHandler(result)
        }
    }
}
