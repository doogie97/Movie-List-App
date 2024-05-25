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
                title: response.Title ?? "",
                year: response.Year ?? "",
                runtime: response.Runtime ?? "",
                genre: response.Genre ?? "",
                director: response.Director ?? "",
                writer: response.Writer ?? "",
                actors: response.Actors ?? "",
                plot: response.Plot ?? "",
                imageUrl: response.Poster ?? "",
                rating: response.imdbRating ?? ""
            )
        } catch let error {
            throw error
        }
    }
}
