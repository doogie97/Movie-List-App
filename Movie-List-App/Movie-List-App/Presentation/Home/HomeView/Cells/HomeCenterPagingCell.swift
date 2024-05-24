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
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private lazy var gradientView = UIView()
    private lazy var gradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,
                                y: 0,
                                width: self.frame.width,
                                height: self.frame.height / 2)
        let colors: [CGColor] = [
            .init(red: 0, green: 0, blue: 0, alpha: 0),
            .init(red: 0, green: 0, blue: 0, alpha: 0.4),
            .init(red: 0, green: 0, blue: 0, alpha: 0.8),
            .init(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        gradient.colors = colors
        
        return gradient
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var rakingLabel = {
        let label = pretendardLabel(family: .Black, size: 90, textAlignment: .center)
        label.layer.opacity = 0.7
        
        return label
    }()
    
    private lazy var titleLabel = {
        let label = pretendardLabel(family: .SemiBold, size: 25, lineCount: 2)
        label.layer.opacity = 0.7
        
        return label
    }()
    
    func setCellContents(movie: MovieList.Movie,
                         index: Int) {
        posterImageView.setImage(movie.imageUrl)
        rakingLabel.text = movie.title
        rakingLabel.text = (index + 1).description
        titleLabel.text = movie.title
        
        setLayout()
    }
    
    private func setLayout() {
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(gradientView)
        self.contentView.addSubview(rakingLabel)
        self.contentView.addSubview(titleLabel)
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
        }
        
        rakingLabel.setContentHuggingPriority(.required, for: .horizontal)
        rakingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        rakingLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(rakingLabel.snp.trailing).inset(-8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        gradientLayer.removeFromSuperlayer()
    }
}
