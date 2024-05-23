//
//  LoadingView.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    init() {
        super.init(frame: .zero)
        self.isHidden = true
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.stopAnimating()
        
        return indicator
    }()
    
    func isLoading(_ isLoading: Bool) {
        if isLoading {
            self.isHidden = false
            activityIndicator.startAnimating()
        } else {
            self.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}

