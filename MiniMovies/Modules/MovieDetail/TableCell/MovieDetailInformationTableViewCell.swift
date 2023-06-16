//
//  MovieDetailInformationTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/15/23.
//

import UIKit
import SnapKit

protocol MovieDetailInformationCellDelegate: AnyObject {
    func gotoTrailer(data videos: VideosResult)
}

class MovieDetailInformationTableViewCell: UITableViewCell {
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemGreen
        return label
    }()
    
    let releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    let movieDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    let trailerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Play Trailer", for: .normal)
        button.backgroundColor = .lightGray
        button.roundedCorners(.allCorners, radius: 12)
        return button
    }()
    
    weak var delegate: MovieDetailInformationCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(releaseYearLabel)
        contentView.addSubview(movieDurationLabel)
        contentView.addSubview(trailerButton)
    }
    
    private func setupLayout() {
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(movieTitleLabel.snp.leading)
        }
        
        releaseYearLabel.snp.makeConstraints { make in
            make.leading.equalTo(ratingLabel.snp.trailing).offset(16)
            make.centerY.equalTo(ratingLabel.snp.centerY)
        }
        
        movieDurationLabel.snp.makeConstraints { make in
            make.leading.equalTo(releaseYearLabel.snp.trailing).offset(8)
            make.centerY.equalTo(ratingLabel.snp.centerY)
            make.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setupUI(with data: MoviesDetailModel) {
        movieTitleLabel.text = data.title
        ratingLabel.text = "⭐️ " + String(data.voteAverage ?? 0.0)
        releaseYearLabel.text = data.releaseDate?.convertToYear()
        movieDurationLabel.text = data.runtime?.convertToFormattedTime()
    }
    
    func setupButton(with data: VideosResult) {
        
        let isKeyEmpty = data.key?.isEmpty ?? true
        trailerButton.backgroundColor = isKeyEmpty ? .lightGray : .systemPink
        
        trailerButton.addAction { [weak self] in
            self?.delegate?.gotoTrailer(data: data)
        }
    }
}
