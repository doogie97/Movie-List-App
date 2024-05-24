//
//  HomeView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    private weak var viewModel: HomeVMable?
    init(viewModel: HomeVMable?) {
        self.viewModel = viewModel
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
        textField.returnKeyType = .search
        textField.delegate = self
        textField.inputAccessoryView = nil
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.addTarget(self, action: #selector(changedTextField), for: .editingChanged)
        textField.font = .pretendard(.Regular, 14)
        return textField
    }()
    
    @objc private func changedTextField(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            print("x버튼 hidden")
        } else {
            print("x버튼 활성화")
        }
    }
    
    private func setLayout() {
        self.addSubview(searchField)
        
        searchField.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(40)
        }
    }
}

extension HomeView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("최근 검색 기록 표시")
        print("취소 버튼 노출")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.getMovieList(keyword: textField.text ?? "")
        return true
    }
}
