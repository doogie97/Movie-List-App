//
//  NetworkRepository.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

protocol NetworkRepositoryable {
    
}

struct NetworkRepository: NetworkRepositoryable {
    private let networkManager: NetworkManageralbe
    
    init(networkManager: NetworkManageralbe) {
        self.networkManager = networkManager
    }
}
