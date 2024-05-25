//
//  MovieListVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieListVC: UIViewController {
    private let viewModel: MovieListVMable
    private let movieListView: MovieListView
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieListVMable) {
        self.viewModel = viewModel
        self.movieListView = MovieListView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = movieListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func bindView() {
        movieListView.navigationBar.backButton.rx.tap.withUnretained(self)
            .subscribe { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.setViewContents.withUnretained(self)
            .subscribe { owner, info in
                owner.movieListView.setViewContents(
                    keyword: info.keyword,
                    searchType: info.searchType
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.showAlert.withUnretained(self)
            .subscribe { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }
}
