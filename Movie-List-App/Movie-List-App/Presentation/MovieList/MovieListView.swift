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
    
    private lazy var listCollectionView: UICollectionView = {
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
            heightDimension: .fractionalWidth(0.7)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieListCell.self, forCellWithReuseIdentifier: "\(MovieListCell.self)")
        return collectionView
    }()
    
    func setViewContents(keyword: String,
                         searchType: MovieType) {
        self.navigationBar.titleLabel.text = "\(searchType.title) 목록"
        self.keywordLabel.text = "'\(keyword)' 검색 결과"
    }
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        self.addSubview(navigationBar)
        self.addSubview(keywordLabel)
        self.addSubview(listCollectionView)
        
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
    }
}

//MARK: - Bind Method
extension MovieListView {
    private func bindViewModel() {
        viewModel?.pagingFinished.withUnretained(self)
            .subscribe(onNext: { owner, preCount in
                print(preCount)
                if preCount == 0 {
                    owner.listCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Collection View
extension MovieListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movieList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCell.self)", for: indexPath) as? MovieListCell else {
            return UICollectionViewCell()
        }
        cell.setCellContents()
        return cell
    }
}

