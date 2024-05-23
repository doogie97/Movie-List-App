//
//  HomeView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var loadingView = LoadingView()
}
