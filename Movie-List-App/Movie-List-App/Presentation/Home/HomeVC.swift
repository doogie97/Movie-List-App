//
//  HomeVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import RxSwift

final class HomeVC: UIViewController {
    private let viewModel: HomeVMable
    private let homeView: HomeView
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeVMable) {
        self.viewModel = viewModel
        self.homeView = HomeView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getMovieList(keyword: "star")
    }
    
    private func bindViewModel() {
        viewModel.showAlert.withUnretained(self)
            .subscribe { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }
}

