//
//  HomeViewController.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import UIKit
import RxSwift
import SnapKit

protocol HomeViewProtocol {
    var presenter: AnyPresenterProtocol? { get set }
    var didSelectItem: Observable<GenreModel> { get }
    
    func update(with genre: [GenreModel])
    func update(with error: String)
    func setCollectionViewData(_ data: [MovieResult], forCellAt indexPath: IndexPath)
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HomeMovieTableCellTableViewCell.nib(), forCellReuseIdentifier: HomeMovieTableCellTableViewCell.nibName())
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let didSelectItemSubject = PublishSubject<GenreModel>()
    var didSelectItem: Observable<GenreModel> {
        return didSelectItemSubject.asObservable()
    }
    
    private var genres: [GenreModel] = []
    private let disposeBag = DisposeBag()
    
    var presenter: AnyPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupViews()
        setupLayout()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter?.errorObservable?
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(with: error)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showError(with error: APIError) {
        let message = error.statusMessage ?? ""
        let alert = UIAlertController(title: "Network Error", message: message.isEmpty ? "Oops! looks like there’s a problem connecting to the internet. Status Code \(error.statusCode ?? 0)" : error.statusMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupLayout() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    func update(with genre: [GenreModel]) {
        self.genres = genre
        self.tableView.reloadData()
    }
    
    func update(with error: String) {
        
    }
    
    func setCollectionViewData(_ data: [MovieResult], forCellAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HomeMovieTableCellTableViewCell else {
            return
        }
        
        cell.setCollectionViewData(data)
        cell.collectionViewGenre.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieTableCellTableViewCell.nibName(), for: indexPath) as? HomeMovieTableCellTableViewCell else { return UITableViewCell() }
        
        let dataGenre = genres[indexPath.row]
        cell.setupUI(with: dataGenre)
        
        // Get the movies for the genre ID
        let genreID = dataGenre.id
        presenter?.displayFilteredMovies(genreID, indexPath: indexPath)
        
        // config button
        cell.delegate = self
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: HomeMovieTableCellDelegate {
    
    func toDetailMovie(with id: Int) {
        presenter?.router?.navigateToDetailMovie(with: id)
    }
    
    func seeAllButtonTapped(with genreID: Int) {
        presenter?.didTapSeeAll(with: genreID)
    }
}
