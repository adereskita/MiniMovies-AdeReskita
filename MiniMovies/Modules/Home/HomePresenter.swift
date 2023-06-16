//
//  HomePresenter.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation
import RxSwift

protocol AnyPresenterProtocol {
    var router: HomeRouterProtocol? { get set }
    var interactor: AnyInteractorProtocol? { get set }
    var view: HomeViewProtocol? { get set }
    
    var errorObservable: Observable<APIError>? { get }
    
    func viewDidLoad()
    func didTapSeeAll(with genreID: Int)
    func didTapToDetailMovies(with id: Int)
    func displayFilteredMovies(_ genreID: Int, indexPath: IndexPath)
}

class HomePresenter: AnyPresenterProtocol {
    
    var router: HomeRouterProtocol?
    
    var interactor: AnyInteractorProtocol?
    
    var view: HomeViewProtocol?
    
    let disposeBag = DisposeBag()
        
    private let errorSubject = PublishSubject<APIError>()
    
    var errorObservable: Observable<APIError>? {
        return errorSubject.asObservable()
    }
        
    init(view: HomeViewProtocol, interactor: AnyInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor?.getGenres()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] genres in
                self?.view?.update(with: genres)
            }, onError: { [weak self] err in
                guard let err = err as? APIError else { return }
                self?.errorSubject.onNext(err)
            })
            .disposed(by: disposeBag)
    }
    
    func displayFilteredMovies(_ genreID: Int, indexPath: IndexPath) {
        interactor?.getMoviesPopularMovies(genreID: genreID)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                let fiveResults = Array(results.prefix(5))
                self?.view?.setCollectionViewData(fiveResults, forCellAt: indexPath)
            }, onError: { [weak self] err in
                guard let err = err as? APIError else { return }
                self?.errorSubject.onNext(err)
            })
            .disposed(by: disposeBag)
    }
    
    func didTapSeeAll(with genreID: Int) {
        router?.navigateToMovieListPage(with: genreID)
    }
    
    func didTapToDetailMovies(with id: Int) {
        router?.navigateToDetailMovie(with: id)
    }
}
