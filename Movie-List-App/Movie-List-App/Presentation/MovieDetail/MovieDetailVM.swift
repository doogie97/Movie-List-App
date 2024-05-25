//
//  MovieDetailVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

protocol MovieDetailVMable: MovieDetailVMInput, MovieDetailVMOutput {}

protocol MovieDetailVMInput {
    func viewDidLoad()
}

protocol MovieDetailVMOutput {}

final class MovieDetailVM: MovieDetailVMable {
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    private let movieId: String
    
    init(getMovieDetailUseCase: GetMovieDetailUseCase,
         movieId: String) {
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.movieId = movieId
    }
    
    func viewDidLoad() {
        Task {
            do {
                let movieDetail = try await getMovieDetailUseCase.execute(movieId: movieId)
                await MainActor.run {
                    print(movieDetail.actors)
                }
            } catch let error {
                await MainActor.run {
                    print(error)
                }
            }
        }
    }
}
