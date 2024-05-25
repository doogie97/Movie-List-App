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
    
    private func setLayout() {
        self.backgroundColor = .systemBrown
        self.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
