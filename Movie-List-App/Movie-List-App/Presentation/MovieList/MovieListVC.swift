//
//  MovieListVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit

final class MovieListVC: UIViewController {
    private let viewModel: MovieListVMable
    private let movieListView = MovieListView()
    
    init(viewModel: MovieListVMable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
