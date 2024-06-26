//
//  NetworkRepository.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

protocol NetworkRepositoryable {
    func getMovieList(keyword: String,
                      searchType: MovieType,
                      page: Int) async throws -> MovieListDTO
    
    func getMovieDetail(movieId: String) async throws -> MovieDetailDTO
}

struct NetworkRepository: NetworkRepositoryable {
    private let networkManager: NetworkManageralbe
    
    init(networkManager: NetworkManageralbe) {
        self.networkManager = networkManager
    }
    
    func getMovieList(keyword: String,
                      searchType: MovieType,
                      page: Int) async throws -> MovieListDTO {
        let requestable = MovieListGET(
            keyword: keyword,
            searchType: searchType,
            page: page
        )
        
        do {
            return try await networkManager.request(requestable, resultType: MovieListDTO.self)
        } catch let error {
            throw error
        }
    }
    
    func getMovieDetail(movieId: String) async throws -> MovieDetailDTO {
        let requestable = MovieDetailGET(movieId: movieId)
        
        do {
            return try await networkManager.request(requestable, resultType: MovieDetailDTO.self)
        } catch let error {
            throw error
        }
    }
}
