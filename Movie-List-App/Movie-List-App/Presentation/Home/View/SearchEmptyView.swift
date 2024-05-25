//
//  SearchEmptyView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class SearchEmptyView: UIView {
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emptyImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        imageView.tintColor = .xButtonBG
        
        return imageView
    }()
    
    private lazy var emptyLabel = pretendardLabel(family: .SemiBold, size: 16, color: .xButtonBG, text: "검색 결과가 없습니다.", textAlignment: .center)
    
    func setLayout() {
        self.isHidden = true
        self.backgroundColor = .systemBackground
        self.addSubview(emptyImageView)
        self.addSubview(emptyLabel)
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(60)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
