//
//  GetMovieListUseCase.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

struct GetMovieListUseCase {
    private let networkRepository: NetworkRepositoryable
    
    init(networkRepository: NetworkRepositoryable) {
        self.networkRepository = networkRepository
    }
    
    func execute(keywork: String,
                 searchType: MovieType,
                 page: Int) async throws -> MovieList {
        do {
            let response = try await networkRepository.getMovieList(keyword: keywork,
                                                                    searchType: searchType,
                                                                    page: page)
            return MovieList(
                movieType: searchType,
                totalCount: Int(response.totalResults ?? "0") ?? 0,
                movieList: (response.Search ?? []).compactMap {
                    return MovieList.Movie(
                        title: $0.Title ?? "",
                        id: $0.imdbID ?? "",
                        movieType: MovieType(rawValue: $0.Type ?? "") ?? .all,
                        imageUrl: $0.Poster ?? ""
                    )
                })
        } catch let error {
            throw error
        }
    }
}
