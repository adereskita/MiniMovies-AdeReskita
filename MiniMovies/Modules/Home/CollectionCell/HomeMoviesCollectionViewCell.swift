//
//  HomeMoviesCollectionViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit
import Kingfisher

class HomeMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.movieBackgroundView.roundedCorners(.allCorners, radius: 12)
        self.movieBackgroundView.contentMode = .scaleAspectFit
    }

    func setupUI(with data: MovieResult) {
        
        let imageURLString = Constants.ConfigAPI.image.rawValue + (data.posterPath ?? "")
        
        guard let imageURL = URL(string: imageURLString) else { return }
        
        // Check if the image is available in the cache
        if let cachedImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: data.posterPath ?? "", options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(0.2))]) {
            // Image is already cached, set it directly
            self.movieImageView.image = cachedImage
            self.movieImageView.roundedCorners(.allCorners, radius: 12)
            self.movieImageView.contentMode = .scaleAspectFit
            
        } else {
            // Image is not cached, load it asynchronously
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.movieImageView.kf.indicatorType = .activity
                self.movieImageView.contentMode = .scaleAspectFit
                
                self.movieImageView.kf.setImage(with: imageURL, placeholder: nil, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(0.2))], progressBlock: nil) { result in
                    switch result {
                    case .success(let imageResult):
                        self.movieImageView.image = imageResult.image
                    case .failure:
                        break
                    }
                }
            }
            self.layoutIfNeeded()
        }
    }
}
