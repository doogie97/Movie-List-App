//
//  Container.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import Foundation

protocol Containerable {
    func homeVC() -> HomeVC
    func movieListVC(keyword: String,
                     searchType: MovieType) -> MovieListVC
}

final class Container: Containerable {
    private let networkRepository = NetworkRepository(networkManager: NetworkManager())
    
    func homeVC() -> HomeVC {
        let viewModel = HomeVM(
            getMovieListUseCase: GetMovieListUseCase(networkRepository: networkRepository)
        )
        
        return HomeVC(viewModel: viewModel, 
                      container: self)
    }
    
    func movieListVC(keyword: String,
                     searchType: MovieType) -> MovieListVC {
        let viewModel = MovieListVM(
            getMovieListUseCase: GetMovieListUseCase(networkRepository: networkRepository),
            keyword: keyword,
            searchType: searchType
        )
        
        return MovieListVC(viewModel: viewModel)
    }
}
