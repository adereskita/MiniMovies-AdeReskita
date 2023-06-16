//
//  MovieDetailInteractor.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import RxSwift

protocol MovieDetailInteractorProtocol {
    var presenter: MovieDetailPresenterProtocol? { get set }
    
    func getMovieDetail(with id: Int) -> Observable<MoviesDetailModel>
    func getMovieReview(with id: Int, page: Int) -> Observable<MoviesReviewModel>
    func getMovieTrailer(with id: Int) -> Observable<MoviesVideosModel>
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    
    var presenter: MovieDetailPresenterProtocol?
    
    private let api: MovieDetailServiceProtocol
    
    private let disposeBag = DisposeBag()
    
    init(api: MovieDetailServiceProtocol = MovieDetailNetworkService()) {
        self.api = api
    }
    
    func getMovieDetail(with id: Int) -> Observable<MoviesDetailModel> {
        return Observable.create { [weak self] observer in
            self?.api.fetchMovieDetail(moviesID: id) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMovieReview(with id: Int, page: Int = 1) -> Observable<MoviesReviewModel> {
        return Observable.create { [weak self] observer in
            self?.api.fetchMovieReview(moviesID: id, page: page) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMovieTrailer(with id: Int) -> Observable<MoviesVideosModel> {
        return Observable.create { [weak self] observer in
            self?.api.fetchMovieVideos(moviesID: id) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
