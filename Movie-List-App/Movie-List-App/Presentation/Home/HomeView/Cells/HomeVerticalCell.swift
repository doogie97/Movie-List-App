//
//  HomeVerticalCell.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit

final class HomeVerticalCell: UICollectionViewCell {
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel = pretendardLabel(family: .SemiBold, size: 16, lineCount: 2)
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .xButtonBG
        
        return imageView
    }()
    
    func setCellContents(movie: MovieList.Movie) {
        posterImageView.setImage(movie.imageUrl)
        titleLabel.text = movie.title
        setLayout()
    }
    
    private func setLayout() {
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightImageView)
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(posterImageView.snp.trailing).inset(-16)
            $0.trailing.equalTo(rightImageView.snp.leading).inset(-8)
        }
        
        rightImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightImageView.setContentHuggingPriority(.required, for: .horizontal)
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
}
