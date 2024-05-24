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
        textField.layer.cornerRadius = 19
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
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .pretendard(.Regular, 18)
        button.layer.opacity = 0
        button.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func touchCancelButton() {
        self.endEditing(true)
    }
    
    private func setLayout() {
        self.addSubview(searchField)
        self.addSubview(cancelButton)
        
        searchField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(38)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.bottom.equalTo(searchField)
            $0.leading.equalTo(searchField.snp.trailing).inset(-4)
            $0.width.equalTo(50)
        }
    }
}

extension HomeView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.searchField.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(58)
            }
            
            self?.cancelButton.layer.opacity = 1
            print("최근 검색 기록 표시")
            self?.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.searchField.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(16)
            }
            
            self?.cancelButton.layer.opacity = 0
            print("검색 결과 화면 보여주기")
            self?.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.getMovieList(keyword: textField.text ?? "")
        return true
    }
}
