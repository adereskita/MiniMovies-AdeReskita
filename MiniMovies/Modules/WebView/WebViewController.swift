//
//  WebViewController.swift
//  MiniMovies
//
//  Created by Ade on 6/16/23.
//

import UIKit
import WebKit
import SnapKit

protocol WebViewDisplayProtocol: AnyObject {
    func loadWebPage(url: URL)
}

class WebViewController: UIViewController, WebViewDisplayProtocol {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var presenter: WebViewPresenterProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationController?.navigationBar.tintColor = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        presenter?.viewDidLoad()
    }
    
    private func setupViews() {
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissWebView))
        closeButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = closeButton
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    func loadWebPage(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func dismissWebView() {
        presenter?.router?.dismiss()
    }
}
