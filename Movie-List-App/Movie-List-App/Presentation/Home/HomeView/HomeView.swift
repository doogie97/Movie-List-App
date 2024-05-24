//
//  HomeView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeView: UIView {
    private weak var viewModel: HomeVMable?
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeVMable?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var loadingView = LoadingView()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .searchBar
        textField.layer.cornerRadius = 19
        textField.placeholder = "검색어를 입력해 주세요."
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 0.0))
        textField.rightViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 34, height: 0.0))
        textField.returnKeyType = .search
        textField.inputAccessoryView = nil
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.addTarget(self, action: #selector(changedTextField), for: .editingChanged)
        textField.font = .pretendard(.Regular, 14)
        
        textField.addSubview(xButtonView)
        xButtonView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
            $0.width.equalTo(30)
        }
        
        return textField
    }()
    
    private lazy var xButtonView: UIView = {
        let view = UIView()
        view.isHidden = true
        let circleView = UIView()
        circleView.backgroundColor = .xButtonBG
        let buttonImage = UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withRenderingMode(.alwaysTemplate)
        let buttonImageView = UIImageView(
            image: buttonImage)
        
        buttonImageView.tintColor = .white
        
        circleView.addSubview(buttonImageView)
        buttonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(12)
        }
        
        view.addSubview(circleView)
        view.addSubview(textXButton)
        
        circleView.snp.makeConstraints {
            $0.height.width.equalTo(18)
            $0.center.equalToSuperview()
            circleView.layer.cornerRadius = 9
        }
        
        textXButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var textXButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(touchXbutton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func touchXbutton() {
        searchField.text = ""
        xButtonView.isHidden = true
    }
    
    @objc private func changedTextField(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            xButtonView.isHidden = true
        } else {
            xButtonView.isHidden = false
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
        xButtonView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.movieListView.layer.opacity = 1
        }
        self.endEditing(true)
    }
    
    private lazy var movieListView = HomeMovieListView(viewModel: self.viewModel)
    
    private func setLayout() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(searchField)
        self.addSubview(cancelButton)
        self.addSubview(movieListView)
        self.addSubview(loadingView)

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
        
        movieListView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).inset(-8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeView {
    private func bindViewModel() {
        viewModel?.isLoading.withUnretained(self)
            .subscribe { owner, isLoading in
                owner.loadingView.isLoading(isLoading)
            }
            .disposed(by: disposeBag)
        
        viewModel?.searchFinished.withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.movieListView.layer.opacity = 1
            })
            .disposed(by: disposeBag)
    }
}

extension HomeView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.searchField.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(58)
            }
            
            self?.cancelButton.layer.opacity = 1
            self?.movieListView.layer.opacity = 0
            self?.layoutIfNeeded()
        }
        xButtonView.isHidden = textField.text?.isEmpty == true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.searchField.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(16)
            }
            
            self?.cancelButton.layer.opacity = 0
            self?.layoutIfNeeded()
        }
        
        xButtonView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.getMovieList(keyword: textField.text ?? "")
        endEditing(true)
        return true
    }
}
