//
//  GenreMoviesPresenter.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import RxSwift

protocol GenreMoviesPresenterProtocol {
    var router: GenreMoviesRouterProtocol? { get set }
    var interactor: GenreMoviesInteractorProtocol? { get set }
    var view: GenreMoviesViewProtocol? { get set }
    
    var errorObservable: Observable<APIError>? { get }
    
    func viewDidLoad(genreID: Int)
    func didTapList(with movieID: Int)
    func didLoadMore(_ genreID: Int)
}

class GenreMoviesPresenter: GenreMoviesPresenterProtocol {
    
    var interactor: GenreMoviesInteractorProtocol?
    
    var router: GenreMoviesRouterProtocol?
        
    var view: GenreMoviesViewProtocol?
    
    private var currentPage = 1
    
    private let disposeBag = DisposeBag()
    private let errorSubject = PublishSubject<APIError>()
    
    var errorObservable: Observable<APIError>? {
        return errorSubject.asObservable()
    }

    init(view: GenreMoviesViewProtocol, interactor: GenreMoviesInteractorProtocol, router: GenreMoviesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad(genreID: Int) {
        interactor?.getMovies(by: genreID, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                self?.view?.update(with: results)
            }, onError: { [weak self] err in
                guard let err = err as? APIError else { return }
                self?.errorSubject.onNext(err)
            })
            .disposed(by: disposeBag)
    }
    
    func didTapList(with movieID: Int) {
        router?.navigateToMovieDetail(with: movieID)
    }
    
    func didLoadMore(_ genreID: Int) {
        currentPage += 1
        interactor?.getMovies(by: genreID, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] results in
                
                self?.view?.update(with: results)
            }
            .disposed(by: disposeBag)
    }
}
