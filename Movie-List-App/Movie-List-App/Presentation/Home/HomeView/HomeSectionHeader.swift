//
//  HomeSectionHeader.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit
import SnapKit

final class HomeSectionHeader: UICollectionReusableView {
    private weak var viewModel: HomeVMable?
    private var sectionIndex: Int?
    private lazy var titleLabel = pretendardLabel(family: .SemiBold, size: 18)
    
    private lazy var countLabel = pretendardLabel(family: .Regular, size: 14, color: .xButtonBG)
    
    private lazy var moreButtonView: UIView = {
        let view = UIView()
        let label = pretendardLabel(color: .xButtonBG, text: "전체보기")
        let rightImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        rightImageView.tintColor = .xButtonBG
        
        view.addSubview(rightImageView)
        view.addSubview(label)
        view.addSubview(moreButton)
        
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.width.equalTo(8)
            $0.height.equalTo(15)
        }
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(rightImageView.snp.leading).inset(-2)
        }
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(touchMoreButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func touchMoreButton() {
        if let sectionIndex = self.sectionIndex {
            viewModel?.touchMoreButton(sectionIndex: sectionIndex)
        }
    }
    
    func setViewContents(viewModel: HomeVMable?,
                         searchType: MovieType,
                         totalCount: Int,
                         sectionIndex: Int) {
        self.viewModel = viewModel
        self.sectionIndex = sectionIndex
        titleLabel.text = searchType.title
        countLabel.text = "(\(totalCount))"
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        self.addSubview(countLabel)
        self.addSubview(moreButtonView)
        
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
        
        moreButtonView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(100)
        }
    }
}
