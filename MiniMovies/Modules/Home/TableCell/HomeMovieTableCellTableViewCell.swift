//
//  HomeMovieTableCellTableViewCell.swift
//  MiniMovies
//
//  Created by Ade on 6/14/23.
//

import UIKit

protocol HomeMovieTableCellDelegate: AnyObject {
    func seeAllButtonTapped(with genreID: Int)
    func toDetailMovie(with id: Int)
}

class HomeMovieTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var buttonSeeAll: UIButton!
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var collectionViewData: [MovieResult] = []
    weak var delegate: HomeMovieTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        setupUI()
        setupCollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionViewGenre.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewHeightConstraint.constant = collectionViewGenre.collectionViewLayout.collectionViewContentSize.height
        collectionViewGenre.collectionViewLayout.invalidateLayout()
        collectionViewGenre.layoutIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard previousTraitCollection != nil else { return }
        collectionViewGenre?.collectionViewLayout.invalidateLayout()
    }
    
    private func setupUI() {
        
        if let layout = collectionViewGenre.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.collectionView?.isScrollEnabled = true
            layout.invalidateLayout()
        }
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    private func setupCollection() {
        collectionViewGenre.register(HomeMoviesCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeMoviesCollectionViewCell.nibName())
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.showsHorizontalScrollIndicator = false
        collectionViewGenre.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.layoutSubviews()
    }
    
    func setupUI(with data: GenreModel) {
        genreTitleLabel.text = data.name
        
        buttonSeeAll.addAction { [weak self] in
            self?.delegate?.seeAllButtonTapped(with: data.id)
        }
    }
    
    func setCollectionViewData(_ data: [MovieResult]) {
        // Update the collection view data and reload the collection view
        collectionViewData = data
        collectionViewGenre.reloadData()
    }
}

extension HomeMovieTableCellTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMoviesCollectionViewCell", for: indexPath) as? HomeMoviesCollectionViewCell else { return UICollectionViewCell() }
        
        let moviesObj = collectionViewData[indexPath.row]
        cell.setupUI(with: moviesObj)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moviesObj = collectionViewData[indexPath.row]
        
        self.delegate?.toDetailMovie(with: moviesObj.id ?? 0)
    }
}

extension HomeMovieTableCellTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width / 2.5
        return CGSize(width: cellWidth, height: 240)
    }
}
