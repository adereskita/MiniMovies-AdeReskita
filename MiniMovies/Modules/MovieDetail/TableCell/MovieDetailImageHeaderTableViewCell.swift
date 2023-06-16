//
//  MovieDetailImageHeaderTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit
import SnapKit
import Kingfisher

protocol MovieDetailImageHeaderTableCellDelegate: AnyObject {
    func backButtonTapped()
}

class MovieDetailImageHeaderTableViewCell: UITableViewCell {
    
    let previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Preview"
        return label
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let backgroundPreview: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black.withAlphaComponent(0.2)
        backgroundView.roundedCorners([.topLeft, .topRight], radius: 6)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .gray.withAlphaComponent(0.5)
        button.roundedCorners(.allCorners, radius: 17)
        return button
    }()
    
    weak var delegate: MovieDetailImageHeaderTableCellDelegate?
    
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
    
    
    func setupUI(with data: MoviesDetailModel) {
        
        let imageURLString = Constants.ConfigAPI.image.rawValue + (data.posterPath ?? "")
        
        guard let imageURL = URL(string: imageURLString) else { return }
        
//        movieImageView.kf.setImage(with: imageURL)
        self.movieImageView.kf.setImage(with: imageURL, placeholder: nil, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(0.2))], progressBlock: nil)
        self.layoutIfNeeded()
    }
    
    private func setupView() {
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(backgroundPreview)
        contentView.addSubview(backButton)
        backgroundPreview.addSubview(previewLabel)
        
        backButton.addAction { [weak self] in
            self?.delegate?.backButtonTapped()
        }
    }
    
    private func setupLayout() {
        
        backgroundPreview.snp.makeConstraints { make in
            make.bottom.equalTo(movieImageView.snp.bottom)
            make.leading.equalTo(movieImageView.snp.leading).offset(8)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.height / 1.5)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
//            make.width.equalTo(backButton.snp.height).multipliedBy(1.2)
            make.width.height.equalTo(34)
        }
        
        previewLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundPreview.safeAreaLayoutGuide)
            make.trailing.equalTo(backgroundPreview.safeAreaLayoutGuide)
            make.bottom.equalTo(backgroundPreview.safeAreaLayoutGuide)
        }
    }
    
    func updateParallaxOffset(scrollView: UIScrollView) {
            let cellFrame = convert(bounds, to: scrollView)
            let contentOffset = scrollView.contentOffset.y
            let yOffset = cellFrame.origin.y - contentOffset
            let parallaxOffset = (yOffset / bounds.height) * 25
        movieImageView.transform = CGAffineTransform(translationX: 0, y: parallaxOffset)
        }
}
