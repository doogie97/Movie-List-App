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

//MARK: - CollectionView
extension HomeMovieListView: UICollectionViewDataSource, UICollectionViewDelegate {
    //Make CollectionView
    private func createSectionCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _)  -> NSCollectionLayoutSection? in
            guard let sectionCase = self?.viewModel?.movieSectionList[safe: sectionIndex]?.movieType else {
                return nil
            }
            
            //임시로 nil return
            switch sectionCase {
            case .movie:
                return nil
            case .series:
                return nil
            case .episode:
                return nil
            case .all:
                return nil
            }
        }
    }
    
    //DataSource, Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.movieSectionList.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movieSectionList[safe: section]?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
