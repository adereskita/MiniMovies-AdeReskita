//
//  GenreMoviesInteractor.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import RxSwift

protocol GenreMoviesInteractorProtocol {
    var presenter: GenreMoviesPresenterProtocol? { get set }
    
    func getMovies(by genreID: Int, page: Int) -> Observable<[MovieResult]>
}

class GenreMoviesInteractor: GenreMoviesInteractorProtocol {
    
    var presenter: GenreMoviesPresenterProtocol?
    
    private let api: GenreMoviesServiceProtocol?
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.api = GenreMoviesNetworkService()
    }
    
    func getMovies(by genreID: Int, page: Int) -> Observable<[MovieResult]> {
        return Observable.create { [weak self] observer in
            self?.api?.fetchDiscoverMovies(genreID: genreID, page: page) { result in
                switch result {
                case .success(let value):
                    guard let results = value.results else { return }
                    observer.onNext(results)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
