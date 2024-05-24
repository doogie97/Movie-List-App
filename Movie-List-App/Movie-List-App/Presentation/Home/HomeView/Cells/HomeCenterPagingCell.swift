//
//  HomeCenterPagingCell.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit
import Kingfisher

final class HomeCenterPagingCell: UICollectionViewCell {
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
//        self.contentView.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(posterImageView.snp.bottom).inset(-4)
//            $0.bottom.equalToSuperview()
//            $0.left.trailing.equalToSuperview()
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
}

