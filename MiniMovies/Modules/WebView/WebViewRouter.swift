//
//  WebViewRouter.swift
//  MiniMovies
//
//  Created by Ade on 6/16/23.
//

import UIKit

protocol WebRouterProtocol: AnyObject {
    func dismiss()
}

class WebRouter: WebRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
