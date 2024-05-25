//
//  HomeCenterPagingHeader.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit

final class HomeCenterPagingHeader: UICollectionReusableView {
    private lazy var titleLabel = pretendardLabel(family: .SemiBold, size: 18, text: "이런 영화는 어때요?")
    
    private lazy var subTitleLabel = pretendardLabel(color: .xButtonBG)
    
    func setViewContents(searchType: MovieType) {
        subTitleLabel.text = searchType.title
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
