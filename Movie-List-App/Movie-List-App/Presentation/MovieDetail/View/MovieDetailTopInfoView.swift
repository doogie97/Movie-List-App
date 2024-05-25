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
    
    private lazy var rateLabel = pretendardLabel(family: .SemiBold)
    private lazy var genreYearLabel = pretendardLabel(color: .systemGray)
    private lazy var yearLabel = pretendardLabel(color: .systemGray)
    private lazy var plotLabel = pretendardLabel(lineCount: 0)
    
    func setViewContents(movieDetail: MovieDetail) {
        posterImageView.setImage(movieDetail.imageUrl)
        titleLabel.text = movieDetail.title
        rateLabel.text = movieDetail.rating
        genreYearLabel.text = movieDetail.genre + "  •\(movieDetail.year)"
        plotLabel.text = movieDetail.plot
        
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(posterImageView)
        self.addSubview(titleLabel)
        self.addSubview(starImageView)
        self.addSubview(rateLabel)
        self.addSubview(genreYearLabel)
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.43)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        starImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-4)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(16)
        }
        
        rateLabel.snp.makeConstraints {
            $0.leading.equalTo(starImageView.snp.trailing).inset(-4)
            $0.centerY.equalTo(starImageView)
        }
        
        genreYearLabel.snp.makeConstraints {
            $0.leading.equalTo(rateLabel.snp.trailing).inset(-4)
            $0.centerY.equalTo(starImageView)
        }
    }
}
