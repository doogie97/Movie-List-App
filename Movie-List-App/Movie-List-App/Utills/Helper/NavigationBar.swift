//
//  NavigationBar.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import UIKit
import SnapKit

final class DefaultNavigationBar: UIView {
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var backButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        
        return button
    }()
    
    private(set) lazy var titleLabel = pretendardLabel(family: .Bold, size: 18)
    
    private func setLayout() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        self.addSubview(titleLabel)
        self.addSubview(backButton)
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
}

