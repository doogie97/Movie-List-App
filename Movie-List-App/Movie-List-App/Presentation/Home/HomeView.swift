//
//  HomeView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var loadingView = LoadingView()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .searchBar
        textField.layer.cornerRadius = 20
        textField.placeholder = "검색어를 입력해 주세요."
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 0.0))
        textField.rightViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 0.0))

        
        return textField
    }()
    
    private func setLayout() {
        self.addSubview(searchField)
        
        searchField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
}
