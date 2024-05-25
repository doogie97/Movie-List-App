//
//  MovieDetailTopInfoView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class MovieDetailTopInfoView: UIView {
    private lazy var posterImageView = UIImageView()
   
    private lazy var titleLabel = pretendardLabel(family: .Bold, size: 20, lineCount: 2)
    private lazy var starImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        
        return imageView
    }()
    
    func setViewContents(movieDetail: MovieDetail) {
        posterImageView.setImage(movieDetail.imageUrl)
        titleLabel.text = movieDetail.title
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(posterImageView)
        self.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.43)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
