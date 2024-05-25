//
//  MovieDetailVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import RxSwift

final class MovieDetailVC: UIViewController {
    private let viewModel: MovieDetailVMable
    private let movieDetailView = MovieDetailView()
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieDetailVMable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}


