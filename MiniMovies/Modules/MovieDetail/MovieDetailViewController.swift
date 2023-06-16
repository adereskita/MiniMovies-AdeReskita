//
//  MovieDetailViewController.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit
import SnapKit
import RxSwift

protocol MovieDetailViewProtocol {
    var presenter: MovieDetailPresenterProtocol? { get set }
    
    func update(with movieList: MoviesDetailModel)
    func update(with videos: [VideosResult])
    func updateDataReview(with reviewList: [ReviewResult])
}

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    var presenter: MovieDetailPresenterProtocol?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var movieID: Int
    private var movieData: MoviesDetailModel?
    private var videosData: [VideosResult]?
    private var reviewMovieData: [ReviewResult] = []
    var isAlreadyAtBottomContent = false
    
    private let disposeBag = DisposeBag()
    
    init (movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupLayout()
        setupTableView()
        presenter?.viewDidLoad(id: self.movieID)
        
        presenter?.errorObservable?
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(with: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.register(MovieDetailImageHeaderTableViewCell.self, forCellReuseIdentifier: MovieDetailImageHeaderTableViewCell.identifier)
        tableView.register(MovieDetailInformationTableViewCell.self, forCellReuseIdentifier: MovieDetailInformationTableViewCell.identifier)
        tableView.register(MovieDetailOverviewTableViewCell.self, forCellReuseIdentifier: MovieDetailOverviewTableViewCell.identifier)
        tableView.register(MovieDetailReviewsTableViewCell.self, forCellReuseIdentifier: MovieDetailReviewsTableViewCell.identifier)
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with movieList: MoviesDetailModel) {
        self.movieData = movieList
        tableView.reloadData()
    }
    
    func update(with videos: [VideosResult]) {
        self.videosData = videos
        tableView.reloadData()
    }
    
    func updateDataReview(with reviewList: [ReviewResult]) {
        self.reviewMovieData += reviewList
        tableView.reloadData()
    }
    
    private func showError(with error: APIError) {
        navigationController?.navigationBar.isHidden = false
        
        let message = error.statusMessage ?? ""
        let alert = UIAlertController(title: "Network Error", message: message.isEmpty ? "Oops! looks like there’s a problem connecting to the internet. Status Code \(error.statusCode ?? 0)" : error.statusMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        present(alert, animated: true)
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailMoviesRows.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = movieData else { return UITableViewCell() }
        
        switch DetailMoviesRows.getRows(indexPath.row) {
        case .imageBanner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailImageHeaderTableViewCell.identifier, for: indexPath) as? MovieDetailImageHeaderTableViewCell else { return UITableViewCell() }
            
            cell.setupUI(with: data)
            cell.delegate = self
            
            return cell
            
        case .movieInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailInformationTableViewCell.identifier, for: indexPath) as? MovieDetailInformationTableViewCell else { return UITableViewCell() }
            
            cell.setupUI(with: data)
            cell.delegate = self

            if let buttonData = videosData?.first {
                cell.setupButton(with: buttonData)
            }
            
            return cell
            
        case .movieOverview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailOverviewTableViewCell.identifier, for: indexPath) as? MovieDetailOverviewTableViewCell else { return UITableViewCell() }
        
            cell.setupUI(with: data)
            
            return cell
            
        case .movieReviews:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailReviewsTableViewCell.identifier, for: indexPath) as? MovieDetailReviewsTableViewCell else { return UITableViewCell() }
            
            cell.setTableViewData(reviewMovieData)
            cell.delegate = self
            
            return cell
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the table view has reached the bottom based on the content offset, table view height, and content size
        let isAtBottom = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        
        // Check if there is no ongoing fetch request and the table view has reached the bottom
        if isAtBottom && !isAlreadyAtBottomContent {
            isAlreadyAtBottomContent = true
            self.tableView.reloadData()
        }
        
        let visibleCells = tableView.visibleCells.compactMap { $0 as? MovieDetailImageHeaderTableViewCell }
        
        for cell in visibleCells {
            cell.updateParallaxOffset(scrollView: scrollView)
        }
    }
}

extension MovieDetailViewController: MovieDetailReviewsCellDelegate {
    func updateReviews() {
        presenter?.didLoadMore(movieID)
        isAlreadyAtBottomContent = false
    }
}

extension MovieDetailViewController: MovieDetailInformationCellDelegate {
    func gotoTrailer(data: VideosResult) {
        
        let key = data.key ?? ""
        let youtubeURLString = Constants.ConfigAPI.youtube.rawValue + key
        
        if let url = URL(string: youtubeURLString) {
            let webViewController = WebViewController()
            let presenter = WebViewPresenter(url: url)
            let router = WebRouter(viewController: webViewController)
            
            webViewController.presenter = presenter
            presenter.router = router
            presenter.view = webViewController
            
            webViewController.navigationItem.title = data.site
            webViewController.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}

extension MovieDetailViewController: MovieDetailImageHeaderTableCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


