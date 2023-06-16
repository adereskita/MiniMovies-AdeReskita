//
//  GenreMovieTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit
import SnapKit
import Kingfisher

class GenreMovieTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.roundedCorners([.allCorners], radius: 2)
        return imageView
    }()
    
    let backgroundMovies: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.roundedCorners([.allCorners], radius: 12)
        backgroundView.addShadow(opacity: 0.1)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
//        backgroundMovies.backgroundColor = .white
//        backgroundMovies.roundedCorners(.allCorners, radius: 12)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupUI(with data: MovieResult) {
        titleLabel.text = data.title
        descriptionLabel.text = data.overview
        
        let imageURLString = Constants.ConfigAPI.image.rawValue + (data.posterPath ?? "")
        
        guard let imageURL = URL(string: imageURLString) else { return }
        
        posterImageView.kf.setImage(with: imageURL)
//        self.posterImageView.kf.setImage(with: imageURL, placeholder: nil, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(0.2))], progressBlock: nil)
    }
    
    private func setupView() {
        
        contentView.addSubview(backgroundMovies)
        backgroundMovies.addSubview(titleLabel)
        backgroundMovies.addSubview(descriptionLabel)
        backgroundMovies.addSubview(posterImageView)
    }
    
    private func setupLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(backgroundMovies.snp.trailing).offset(-16.0)
        }
        
        backgroundMovies.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
//            make.top.equalToSuperview().offset(8)
//            make.bottom.equalToSuperview().inset(4)
//            make.trailing.leading.equalToSuperview().inset(24.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(backgroundMovies.snp.trailing).offset(-16.0)
            make.bottom.lessThanOrEqualTo(backgroundMovies.snp.bottom).inset(16.0)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundMovies.snp.top).offset(16)
            make.leading.equalTo(backgroundMovies.snp.leading).offset(16)
            make.bottom.equalTo(backgroundMovies.snp.bottom).inset(16)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.25) // aspect ratio
        }
    }
}
