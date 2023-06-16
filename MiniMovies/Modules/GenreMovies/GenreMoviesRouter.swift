//
//  GenreMoviesRouter.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit

typealias GenreEntryPoint = GenreMoviesViewProtocol & UIViewController

protocol GenreMoviesRouterProtocol {
    var entry: GenreEntryPoint? { get }
    
    static func start(with genreID: Int) -> GenreMoviesRouterProtocol
    func navigateToMovieDetail(with moviesID: Int)
}

class GenreMoviesRouter: GenreMoviesRouterProtocol {
    
    var entry: GenreEntryPoint?
    
    static func start(with genreID: Int) -> GenreMoviesRouterProtocol {
        let router = GenreMoviesRouter()
        
        // assign VIP
        var view: GenreMoviesViewProtocol = GenreMoviesViewController(genreID: genreID)
        var interactor: GenreMoviesInteractorProtocol = GenreMoviesInteractor()
        let presenter: GenreMoviesPresenterProtocol = GenreMoviesPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        
        router.entry = view as? GenreEntryPoint
        
        return router
    }
    
    func navigateToMovieDetail(with moviesID: Int) {
        let view = MovieDetailViewController(movieID: moviesID)
        let interactor = MovieDetailInteractor()
        let router = MovieDetailRouter()
        let presenter = MovieDetailPresenter(router: router, interactor: interactor, view: view)

        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        router.entry = view
        
        guard let routeEntry = router.entry else { return }
        
        entry?.navigationController?.pushViewController(routeEntry, animated: true)
    }
}
