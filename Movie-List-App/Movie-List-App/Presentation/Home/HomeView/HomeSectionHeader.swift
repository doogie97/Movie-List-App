//
//  HomeSectionHeader.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit

final class HomeSectionHeader: UICollectionReusableView {
    private lazy var titleLabel = pretendardLabel(family: .SemiBold, size: 18)
    private lazy var countLabel = pretendardLabel(family: .Regular, size: 14, color: .xButtonBG)
    
    func setViewContents(viewModel: HomeVMable?,
                         searchType: MovieType,
                         totalCount: Int) {
        titleLabel.text = searchType.title
        countLabel.text = "(\(totalCount))"
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        self.addSubview(countLabel)
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).inset(-4)
            $0.trailing.equalToSuperview().inset(4)
        }
    }
}
