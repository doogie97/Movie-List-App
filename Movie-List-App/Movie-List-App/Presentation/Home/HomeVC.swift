//
//  HomeVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit

final class HomeVC: UIViewController {
    private let viewModel: HomeVMable
    private let homeView = HomeView()
    
    init(viewModel: HomeVMable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

