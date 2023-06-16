//
//  MovieReviewTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/15/23.
//

import UIKit
import SnapKit

class MovieReviewTableViewCell: UITableViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let reviewDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    let reviewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(reviewDateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(reviewsLabel)
    }
    
    private func setupLayout() {
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(32)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
        }
        
        reviewDateLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.equalTo(usernameLabel.snp.leading)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(usernameLabel.snp.trailing).offset(16)
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        reviewsLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.leading)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func setupUI(with data: ReviewResult) {
        
        guard let detailData = data.authorDetails else { return }

        usernameLabel.text = detailData.username
        ratingLabel.text = "⭐️ " + String(detailData.rating ?? 0) + "/10"

        reviewDateLabel.text = data.createdAt?.convertToRelativeTime()
        reviewsLabel.text = data.content
        
        let imageURLString = Constants.ConfigAPI.image.rawValue + (detailData.avatarPath ?? "")
        
        guard let imageURL = URL(string: imageURLString) else { return }
        
        avatarImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person")) { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.avatarImageView.image = imageResult.image
            case .failure(_):
                var ava = detailData.avatarPath
                if let range = ava?.range(of: "/") {
                    ava?.replaceSubrange(range, with: "")
                }
                let retryURLString = ava ?? ""
                guard let imageRetryURL = URL(string: retryURLString) else { return }
                
                self?.avatarImageView.kf.setImage(with: imageRetryURL)
            }
        }
        
        avatarImageView.roundedCorners(.allCorners, radius: 16)
        
        self.layoutIfNeeded()
    }
}
