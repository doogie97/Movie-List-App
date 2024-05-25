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
    
    private lazy var loadingView = LoadingView()
    
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
    
    private lazy var topInfoView = MovieDetailTopInfoView()
    private lazy var bottomInfoView = MovieDetailBottomInfoView()
    
    func setViewContents(movieDetail: MovieDetail) {
        topInfoView.setViewContents(movieDetail: movieDetail)
        bottomInfoView.setViewContents(movieDetail: movieDetail)
        gradientView.layer.addSublayer(gradientLayer)
        loadingView.isHidden = true
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        self.addSubview(gradientView)
        self.addSubview(navigationBar)
        gradientView.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(topInfoView)
        contentsView.addSubview(bottomInfoView)
        self.addSubview(loadingView)
        
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
        
        topInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        bottomInfoView.snp.makeConstraints {
            $0.top.equalTo(topInfoView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            loadingView.isLoading(true)
        }
    }
}
