//
//  WebViewPresenter.swift
//  MiniMovies
//
//  Created by Ade on 6/16/23.
//

import Foundation


protocol WebViewPresenterProtocol: AnyObject {
    var router: WebRouterProtocol? { get set }
    var view: WebViewDisplayProtocol? { get set }

    func viewDidLoad()
}

class WebViewPresenter: WebViewPresenterProtocol {
    
    var router: WebRouterProtocol?
    weak var view: WebViewDisplayProtocol?
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func viewDidLoad() {
        view?.loadWebPage(url: url)
    }
}
