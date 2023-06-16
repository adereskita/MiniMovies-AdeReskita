//
//  GenreMoviesViewController.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit
import SnapKit
import RxSwift

protocol GenreMoviesViewProtocol {
    var presenter: GenreMoviesPresenterProtocol? { get set }
    
    var isFetchingData: Bool { get set }
    
    func update(with movieList: [MovieResult])
}

class GenreMoviesViewController: UIViewController, GenreMoviesViewProtocol {
    
    var presenter: GenreMoviesPresenterProtocol?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    var isFetchingData = false
    
    var genreID: Int
    private var movieLists: [MovieResult] = []
    private let disposeBag = DisposeBag()
    
    init (genreID: Int) {
        self.genreID = genreID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupLayout()
        setupTableView()

        presenter?.viewDidLoad(genreID: self.genreID)
        
        presenter?.errorObservable?
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(with: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.register(GenreMovieTableViewCell.self, forCellReuseIdentifier: GenreMovieTableViewCell.identifier)
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        activityIndicatorView.startAnimating()
        tableView.tableFooterView = activityIndicatorView
        
        tableView.reloadData()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with movieList: [MovieResult]) {
        self.movieLists += movieList
        tableView.reloadData()
        isFetchingData = false
    }
    
    private func showError(with error: APIError) {
        let message = error.statusMessage ?? ""
        let alert = UIAlertController(title: "Network Error", message: message.isEmpty ? "Oops! looks like there’s a problem connecting to the internet. Status Code \(error.statusCode ?? 0)" : error.statusMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        present(alert, animated: true)
    }
}

extension GenreMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreMovieTableViewCell.identifier, for: indexPath) as? GenreMovieTableViewCell else { return UITableViewCell() }
        
        let data = movieLists[indexPath.row]
        
        cell.setupUI(with: data)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetThreshold = contentHeight - scrollView.bounds.height // Adjust the threshold as needed
        
        if scrollView.contentOffset.y > offsetThreshold && !isFetchingData {
            isFetchingData = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presenter?.didLoadMore(self.genreID)
                
                self.activityIndicatorView.stopAnimating()
                self.tableView.tableFooterView = nil
            }
            
        } else {
            self.activityIndicatorView.startAnimating()
            self.tableView.tableFooterView = activityIndicatorView
        }
    }
}

extension GenreMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let data = movieLists[indexPath.row]
        
        presenter?.didTapList(with: data.id ?? 0)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
