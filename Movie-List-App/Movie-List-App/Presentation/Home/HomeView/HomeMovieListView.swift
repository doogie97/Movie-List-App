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
        collectionView.register(HomeCenterPagingCell.self,
                                forCellWithReuseIdentifier: "\(HomeCenterPagingCell.self)")
        
        collectionView.register(HomeSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HomeSectionHeader.self)")
        collectionView.register(HomeCenterPagingHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HomeCenterPagingHeader.self)")
        
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
            case .realTimeBest:
                return self?.centerPagingSectionLayout()
            case .all:
                return self?.verticalSectionLayout()
            }
        }
    }
    
    private func horizontalSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                              heightDimension: .absolute(190))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        section.boundarySupplementaryItems = [.init(layoutSize: sectionHeaderSize,
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        
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
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        section.boundarySupplementaryItems = [.init(layoutSize: sectionHeaderSize,
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        return section
    }
    
    private func centerPagingSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .fractionalWidth(1.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        section.boundarySupplementaryItems = [.init(layoutSize: sectionHeaderSize,
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        
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
        case .realTimeBest:
            return centerPagingCell(collectionView: collectionView,
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
    
    private func centerPagingCell(collectionView: UICollectionView, indexPath: IndexPath, movie: MovieList.Movie) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HomeCenterPagingCell.self)", for: indexPath) as? HomeCenterPagingCell else {
            return UICollectionViewCell()
        }
        cell.setCellContents(movie: movie, 
                             index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let section = viewModel?.movieSectionList[safe: indexPath.section] else {
                return UICollectionReusableView()
            }
            switch section.movieType {
            case .movie, .series, .episode, .all:
                if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HomeSectionHeader.self)", for: indexPath) as? HomeSectionHeader {
                    header.setViewContents(viewModel: viewModel,
                                           searchType: section.movieType,
                                           totalCount: section.totalCount,
                                           sectionIndex: indexPath.section)
                    return header
                }
            case .realTimeBest :
                if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HomeCenterPagingHeader.self)", for: indexPath) as? HomeCenterPagingHeader {
                    header.setViewContents(searchType: section.movieType)
                    return header
                }
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.touchMovieItem(indexPath: indexPath)
    }
}
