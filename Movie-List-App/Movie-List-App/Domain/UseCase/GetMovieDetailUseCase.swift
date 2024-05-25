//
//  GetMovieDetailUseCase.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

struct GetMovieDetailUseCase {
    private let networkRepository: NetworkRepositoryable
    
    init(networkRepository: NetworkRepositoryable) {
        self.networkRepository = networkRepository
    }
    
    func execute(movieId: String) async throws -> MovieDetail {
        do {
            let response = try await networkRepository.getMovieDetail(movieId: movieId)
            return MovieDetail(
                title: response.Title == "N/A" ? "알 수 없음" : (response.Title ?? ""),
                year: response.Year == "N/A" ? "알 수 없음" : (response.Year ?? ""),
                runtime: response.Runtime == "N/A" ? "알 수 없음" : (response.Runtime ?? ""),
                genre: response.Genre == "N/A" ? "알 수 없음" : (response.Genre ?? ""),
                director: response.Director == "N/A" ? "알 수 없음" : (response.Director ?? ""),
                writer: response.Writer == "N/A" ? "알 수 없음" : (response.Writer ?? ""),
                actors: response.Actors == "N/A" ? "알 수 없음" : (response.Actors ?? ""),
                plot: response.Plot == "N/A" ? "알 수 없음" : (response.Plot ?? ""),
                imageUrl: response.Poster ?? "",
                rating: response.imdbRating == "N/A" ? "알 수 없음" : (response.imdbRating ?? "")
            )
        } catch let error {
            throw error
        }
    }
}
