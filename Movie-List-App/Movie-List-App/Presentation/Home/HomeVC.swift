//
//  HomeVC.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import UIKit

final class HomeVC: UIViewController {
    private let homeView = HomeView()
    
    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

