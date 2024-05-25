//
//  MovieListView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit
import RxSwift

final class MovieListView: UIView {
    private weak var viewModel: MovieListVMable?
    private let disposeBag = DisposeBag()
    private var isPaging = false
    
    init(viewModel: MovieListVMable?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var navigationBar = DefaultNavigationBar(title: "")
    
    private lazy var keywordLabel = pretendardLabel(family: .SemiBold)
    
    private lazy var listCollectionView = createSectionCollectionView()
    
    private lazy var loadingView = LoadingView()
    
    func setViewContents(keyword: String,
                         searchType: MovieType) {
        self.loadingView.isLoading(true)
        self.navigationBar.titleLabel.text = "\(searchType.title) 목록"
        self.keywordLabel.text = "'\(keyword)' 검색 결과"
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        self.addSubview(navigationBar)
        self.addSubview(keywordLabel)
        self.addSubview(listCollectionView)
        self.addSubview(loadingView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).inset(-8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - Bind Method
extension MovieListView {
    private func bindViewModel() {
        viewModel?.pagingFinished.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.loadingView.isHidden = true
                owner.isPaging = false
                owner.listCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Collection View
extension MovieListView: UICollectionViewDataSource, UICollectionViewDelegate {
    private func createSectionCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(MovieListCell.self,
                                forCellWithReuseIdentifier: "\(MovieListCell.self)")
        collectionView.register(LoadingCVCell.self,
                                forCellWithReuseIdentifier: "\(LoadingCVCell.self)")
        
        return collectionView
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _)  -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return self?.movieListSectionLayout()
            } else {
                return self?.loadingSectionLayout()
            }
        }
    }
    
    private func movieListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4,
                                   leading: 4,
                                   bottom: 4,
                                   trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.8)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func loadingSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.movieList.count ?? 0
        }
        
        if (section == 1) && isPaging && (viewModel?.hasNext == true) {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCell.self)", for: indexPath) as? MovieListCell,
                  let movie = viewModel?.movieList[safe: indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.setCellContents(movie: movie)
            return cell
        } else {
            guard let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(LoadingCVCell.self)", for: indexPath) as? LoadingCVCell else {
                return UICollectionViewCell()
            }
            
            return loadingCell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if !isPaging && (viewModel?.hasNext == true) {
                isPaging = true
                listCollectionView.reloadSections(IndexSet(integer: 1))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.viewModel?.getMovieList()
                }
            }
        }
    }
}

