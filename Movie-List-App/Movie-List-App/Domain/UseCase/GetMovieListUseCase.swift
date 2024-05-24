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
    
    func execute(keyword: String,
                 searchType: MovieType,
                 page: Int) async throws -> MovieList {
        do {
            //실시간 베스트 타입이라는 가상 타입 구현
            let keyword = searchType == .realTimeBest ? "game" : keyword
            let newSearchType: MovieType = searchType == .realTimeBest ? .all : searchType
            let response = try await networkRepository.getMovieList(keyword: keyword,
                                                                    searchType: newSearchType,
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
