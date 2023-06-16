//
//  MovieDetailRouter.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit

typealias MovieDetailEntryPoint = MovieDetailViewProtocol & UIViewController

protocol MovieDetailRouterProtocol {
    var entry: MovieDetailEntryPoint? { get }
    
    static func start(with movieID: Int) -> MovieDetailRouterProtocol
}


class MovieDetailRouter: MovieDetailRouterProtocol {
    var entry: MovieDetailEntryPoint?
    
    static func start(with movieID: Int) -> MovieDetailRouterProtocol {
        let router = MovieDetailRouter()
        
        // assign VIP
        var view: MovieDetailViewProtocol = MovieDetailViewController(movieID: movieID)
        var interactor: MovieDetailInteractorProtocol = MovieDetailInteractor()
        let presenter: MovieDetailPresenterProtocol = MovieDetailPresenter(router: router, interactor: interactor, view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        
        router.entry = view as? MovieDetailEntryPoint
        
        return router
    }
    
}
