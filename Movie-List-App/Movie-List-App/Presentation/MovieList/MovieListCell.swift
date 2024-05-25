//
//  MovieListCell.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class MovieListCell: UICollectionViewCell {
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel = pretendardLabel()
    
    func setCellContents(movie: MovieList.Movie) {
        posterImageView.setImage(movie.imageUrl)
        titleLabel.text = movie.title
        setLayout()
    }
    
    private func setLayout() {
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.43)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).inset(-4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
}
