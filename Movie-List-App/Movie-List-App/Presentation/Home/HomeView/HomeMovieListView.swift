//
//  HomeMovieListView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeMovieListView: UIView {
    private weak var viewModel: HomeVMable?
    private let disposeBag = DisposeBag()
    init(viewModel: HomeVMable?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBlue
    }
}

//MARK: - Bind ViewModel
extension HomeMovieListView {
    private func bindViewModel() {
        viewModel?.searchFinished.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                print(owner.viewModel?.keyword)
            })
            .disposed(by: disposeBag)
    }
}
