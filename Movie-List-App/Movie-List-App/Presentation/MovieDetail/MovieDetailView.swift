//
//  MovieDetailView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class MovieDetailView: UIView {
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var navigationBar = {
        let navigationBar = NavigationBar(title: "")
        navigationBar.backButton.tintColor = .white
        
        return navigationBar
    }()
    
    private lazy var gradientView = UIView()
    private lazy var gradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,
                                y: 0,
                                width: scrollView.frame.width,
                                height: scrollView.frame.height / 4)
        let colors: [CGColor] = [
            .init(red: 0, green: 0, blue: 0, alpha: 1),
            .init(red: 0, green: 0, blue: 0, alpha: 0)
        ]
        gradient.colors = colors
        
        return gradient
    }()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentsView = UIView()
    
    private lazy var posterImageView = UIImageView()
   
    private lazy var titleLabel = pretendardLabel(family: .Bold, size: 20, lineCount: 2)
    
    func setViewContents(movieDetail: MovieDetail) {
        posterImageView.setImage(movieDetail.imageUrl)
        titleLabel.text = movieDetail.title
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        self.addSubview(gradientView)
        self.addSubview(navigationBar)
        gradientView.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(posterImageView)
        contentsView.addSubview(titleLabel)
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.43)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview() //다음 뷰로 이동
        }
    }
}
