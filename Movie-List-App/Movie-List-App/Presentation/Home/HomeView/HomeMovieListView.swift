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
    
    private lazy var homeCollectionView = createSectionCollectionView()
    private func setLayout() {
        self.addSubview(homeCollectionView)
        
        homeCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: - Bind ViewModel
extension HomeMovieListView {
    private func bindViewModel() {
        viewModel?.searchFinished.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.homeCollectionView.reloadData()
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
        
        collectionView.register(HomeHorizontalCell.self,
                                forCellWithReuseIdentifier: "\(HomeHorizontalCell.self)")
        collectionView.register(HomeVerticalCell.self,
                                forCellWithReuseIdentifier: "\(HomeVerticalCell.self)")
        
        return collectionView
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _)  -> NSCollectionLayoutSection? in
            guard let sectionCase = self?.viewModel?.movieSectionList[safe: sectionIndex]?.movieType else {
                return nil
            }
            
            //임시로 nil return
            switch sectionCase {
            case .movie, .series, .episode:
                return self?.horizontalSectionLayout()
            case .all:
                return self?.verticalSectionLayout()
            }
        }
    }
    
    private func horizontalSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                              heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        return section
    }
    
    private func verticalSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 4, bottom: 4, trailing: 4)
        return section
    }

    
    //DataSource, Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.movieSectionList.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movieSectionList[safe: section]?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = viewModel?.movieSectionList[safe: indexPath.section],
              let movie = section.movieList[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        switch section.movieType {
        case .movie, .series, .episode:
            return horizontalCell(collectionView: collectionView,
                                  indexPath: indexPath,
                                  movie: movie)
        case .all:
            return verticalCell(collectionView: collectionView,
                                indexPath: indexPath,
                                movie: movie)
        }
    }
    
    private func horizontalCell(collectionView: UICollectionView, indexPath: IndexPath, movie: MovieList.Movie) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HomeHorizontalCell.self)", for: indexPath) as? HomeHorizontalCell else {
            return UICollectionViewCell()
        }
        cell.setCellContents(movie: movie)
        return cell
    }
    
    private func verticalCell(collectionView: UICollectionView, indexPath: IndexPath, movie: MovieList.Movie) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HomeVerticalCell.self)", for: indexPath) as? HomeVerticalCell else {
            return UICollectionViewCell()
        }
        cell.setCellContents(movie: movie)
        return cell
    }
}
