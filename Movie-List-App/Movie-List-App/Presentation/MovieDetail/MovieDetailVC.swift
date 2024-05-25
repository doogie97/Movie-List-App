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
        bindView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func bindView() {
        movieDetailView.navigationBar.backButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.setViewContents.withUnretained(self)
            .subscribe { owner, movieDetail in
                owner.movieDetailView.setViewContents(movieDetail: movieDetail)
            }
            .disposed(by: disposeBag)
        
        viewModel.showAlert.withUnretained(self)
            .subscribe { owner, message in
                owner.showAlert(message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}


