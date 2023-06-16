//
//  MovieDetailPresenter.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import Foundation
import RxSwift

enum DetailMoviesRows: Int, CaseIterable  {
    case imageBanner
    case movieInfo
    case movieOverview
    case movieReviews
    
    static func numberOfRows() -> Int {
        return self.allCases.count
    }
    
    static func getRows(_ row: Int) -> DetailMoviesRows {
        return self.allCases[row]
    }
}

struct PresenterState {
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let dataReview: BehaviorSubject<[ReviewResult]> = BehaviorSubject(value: [])
    let error: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
}

protocol MovieDetailPresenterProtocol {
    var router: MovieDetailRouterProtocol? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    var view: MovieDetailViewProtocol? { get set }
    
    var errorObservable: Observable<APIError>? { get }
    
    func viewDidLoad(id: Int)
    func didSelectRow(_ row: DetailMoviesRows)
    func didLoadMore(_ genreID: Int)
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    var router: MovieDetailRouterProtocol?
    
    var interactor: MovieDetailInteractorProtocol?
    
    var view: MovieDetailViewProtocol?
    
    private let disposeBag = DisposeBag()
    
    private var currentPage = 1
    
    private let errorSubject = PublishSubject<APIError>()
    
    var errorObservable: Observable<APIError>? {
        return errorSubject.asObservable()
    }
    
    init(router: MovieDetailRouterProtocol, interactor: MovieDetailInteractorProtocol, view: MovieDetailViewProtocol) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    func viewDidLoad(id: Int) {
        interactor?.getMovieDetail(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                self?.view?.update(with: details)
            }, onError: { [weak self] err in
                guard let err = err as? APIError else { return }
                self?.errorSubject.onNext(err)
            })
            .disposed(by: disposeBag)
        
        interactor?.getMovieReview(with: id, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] reviews in
                guard let results = reviews.results else { return }
                self?.view?.updateDataReview(with: results)
            }
            .disposed(by: disposeBag)
        
        interactor?.getMovieTrailer(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] videos in
                guard let videos = videos.results else { return }
                
                self?.view?.update(with: videos)
            }
            .disposed(by: disposeBag)
    }
    
    func didLoadMore(_ genreID: Int) {
        currentPage += 1
        interactor?.getMovieReview(with: genreID, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] reviews in
                guard let results = reviews.results else { return }
                
                self?.view?.updateDataReview(with: results)
            }
            .disposed(by: disposeBag)
    }
    
    func didSelectRow(_ row: DetailMoviesRows) {
        switch row {
        case .imageBanner:
            break
        case .movieInfo:
            break
        case .movieOverview:
            break
        case .movieReviews:
            break
        }
    }
}
