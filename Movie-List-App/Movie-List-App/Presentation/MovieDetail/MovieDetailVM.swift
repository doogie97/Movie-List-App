//
//  MovieDetailVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import RxRelay

protocol MovieDetailVMable: MovieDetailVMInput, MovieDetailVMOutput {}

protocol MovieDetailVMInput {
    func viewDidLoad()
}

protocol MovieDetailVMOutput {
    var setViewContents: PublishRelay<MovieDetail> { get }
}

final class MovieDetailVM: MovieDetailVMable {
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    private let movieId: String
    
    init(getMovieDetailUseCase: GetMovieDetailUseCase,
         movieId: String) {
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.movieId = movieId
    }
    
    //MARK: - Intput
    func viewDidLoad() {
        Task {
            do {
                let movieDetail = try await getMovieDetailUseCase.execute(movieId: movieId)
                await MainActor.run {
                    setViewContents.accept(movieDetail)
                }
            } catch let error {
                await MainActor.run {
                    print(error)
                }
            }
        }
    }
    
    //MARK: - Output
    let setViewContents = PublishRelay<MovieDetail>()
}
