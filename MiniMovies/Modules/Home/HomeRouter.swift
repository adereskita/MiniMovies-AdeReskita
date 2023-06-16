//
//  HomeRouter.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import UIKit

typealias HomeEntryPoint = HomeViewProtocol & UIViewController

protocol HomeRouterProtocol {
    var entry: HomeEntryPoint? { get }
    
    static func start() -> HomeRouterProtocol
    func navigateToMovieListPage(with genreID: Int)
    func navigateToDetailMovie(with id: Int)
}

class HomeRouter: HomeRouterProtocol {
    
    var entry: HomeEntryPoint?
    
    func navigateToMovieListPage(with genreID: Int) {
        
        let router = GenreMoviesRouter()
        
        // assign VIP
        var view: GenreMoviesViewProtocol = GenreMoviesViewController(genreID: genreID)
        var interactor: GenreMoviesInteractorProtocol = GenreMoviesInteractor()
        let presenter: GenreMoviesPresenterProtocol = GenreMoviesPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        
        router.entry = view as? GenreEntryPoint
        
        guard let routeEntry = router.entry else { return }
        
        entry?.navigationController?.pushViewController(routeEntry, animated: true)
    }
    
    func navigateToDetailMovie(with id: Int) {
        
        let router = MovieDetailRouter()
        
        // assign VIP
        var view: MovieDetailViewProtocol = MovieDetailViewController(movieID: id)
        var interactor: MovieDetailInteractorProtocol = MovieDetailInteractor()
        let presenter: MovieDetailPresenterProtocol = MovieDetailPresenter(router: router, interactor: interactor, view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        
        router.entry = view as? MovieDetailEntryPoint
        
        guard let routeEntry = router.entry else { return }
        
        entry?.navigationController?.pushViewController(routeEntry, animated: true)
    }
    
    static func start() -> HomeRouterProtocol {
        let router = HomeRouter()
        
        // assign VIP
        var view: HomeViewProtocol = HomeViewController()
        var interactor: AnyInteractorProtocol = HomeInteractor()
        let presenter: AnyPresenterProtocol = HomePresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        
        router.entry = view as? HomeEntryPoint
        
        return router
    }
}
