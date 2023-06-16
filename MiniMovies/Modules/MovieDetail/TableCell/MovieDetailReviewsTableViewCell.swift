//
//  MovieDetailReviewsTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/15/23.
//

import UIKit
import SnapKit

protocol MovieDetailReviewsCellDelegate: AnyObject {
    func updateReviews()
}

class MovieDetailReviewsTableViewCell: UITableViewCell {
    
    let reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Reviews"
        return label
    }()
    
    let reviewTableView: SelfSizedTableView = {
        let tableView = SelfSizedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let loadMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load More", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
        
    private var reviewsData: [ReviewResult] = []
    weak var delegate: MovieDetailReviewsCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupTableView()
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTableView() {
        loadMoreButton.addAction { [weak self] in
            self?.delegate?.updateReviews()
        }
        reviewTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: reviewTableView.frame.width, height: 50))
        reviewTableView.tableFooterView?.addSubview(loadMoreButton)
        
        reviewTableView.register(MovieReviewTableViewCell.self, forCellReuseIdentifier: MovieReviewTableViewCell.identifier)
        reviewTableView.allowsMultipleSelection = false
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        reviewTableView.separatorStyle = .none
        reviewTableView.reloadData()
        
        reviewTableView.estimatedRowHeight = 500
        reviewTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupView() {
        
        contentView.addSubview(reviewTitleLabel)
        contentView.addSubview(reviewTableView)
    }
    
    private func setupLayout() {
        
        reviewTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        reviewTableView.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.bottom).offset(0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        loadMoreButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTableViewData(_ data: [ReviewResult]) {
        // Update the collection view data and reload the collection view
        reviewsData = data
        reviewTableView.reloadData()
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    @objc fileprivate func footerViewTapped() {
        self.delegate?.updateReviews()
    }
}

extension MovieDetailReviewsTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieReviewTableViewCell.identifier, for: indexPath) as? MovieReviewTableViewCell else { return UITableViewCell() }
        
        let data = reviewsData[indexPath.row]
        
        cell.setupUI(with: data)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return cell
    }
}

extension MovieDetailReviewsTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
