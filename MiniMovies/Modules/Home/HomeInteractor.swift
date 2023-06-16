//
//  HomeInteractor.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation
import RxSwift

protocol AnyInteractorProtocol {
    var presenter: AnyPresenterProtocol? { get set }
    
    func getGenres() -> Observable<[GenreModel]>
    func getMoviesPopularMovies(genreID: Int) -> Observable<[MovieResult]>
    func filterMoviesByGenre(genreID: Int) -> [MovieResult]
}

class HomeInteractor: AnyInteractorProtocol {
    
    private var allMovies: [MovieResult] = []
    
    var presenter: AnyPresenterProtocol?
    private let api: HomeNetworkServiceProtocol?
    
    let disposeBag = DisposeBag()
    
    public init() {
        self.api = HomeNetworkService()
    }
    
    func getGenres() -> Observable<[GenreModel]> {
        return Observable.create { [weak self] observer in
            self?.api?.fetchGenres { result in
                switch result {
                case .success(let value):
                    observer.onNext(value.genres)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMoviesPopularMovies(genreID: Int) -> Observable<[MovieResult]> {
        return Observable.create { [weak self] observer in
            self?.api?.fetchPopularMovies(genreID: genreID) { result in
                switch result {
                case .success(let value):
                    guard let results = value.results else { return }
                    self?.allMovies = results
                    observer.onNext(results)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func filterMoviesByGenre(genreID: Int) -> [MovieResult] {
        let filteredMovies = allMovies.filter { movie in
            return movie.genreIDS?.contains(genreID) ?? false
        }
        return filteredMovies
    }
    
//    func getGenres() {
//        api?.fetchGenres { [weak self] result in
//            self?.presenter?.interactorDidFetchGenres(with: result)
//        }
//    }
}
