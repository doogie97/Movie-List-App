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
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var navigationBar = DefaultNavigationBar(title: "")
    
    private lazy var keywordLabel = pretendardLabel(family: .SemiBold)
    
    private lazy var listCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4,
                                   leading: 4,
                                   bottom: 4,
                                   trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / 2)
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
    
    func setViewContents(viewModel: MovieListVMable,
                         keyword: String,
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

extension MovieListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCell.self)", for: indexPath) as? MovieListCell else {
            return UICollectionViewCell()
        }
        cell.setCellContents()
        return cell
    }
    
    
}
