//
//  MovieListView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class MovieListView: UIView {
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var navigationBar = DefaultNavigationBar(title: "")
    
    private lazy var keywordLabel = pretendardLabel(family: .SemiBold)
    
    func setViewContents(viewModel: MovieListVMable,
                         keyword: String,
                         searchType: MovieType) {
        self.navigationBar.titleLabel.text = "\(searchType.title) 목록"
        self.keywordLabel.text = "'\(keyword)' 검색 결과"
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        self.addSubview(navigationBar)
        self.addSubview(keywordLabel)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
