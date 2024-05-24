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
        self.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
