//
//  MovieDetailVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

protocol MovieDetailVMable: MovieDetailVMInput, MovieDetailVMOutput {}

protocol MovieDetailVMInput {}

protocol MovieDetailVMOutput {}

final class MovieDetailVM: MovieDetailVMable {
    private let movieId: String
    init(movieId: String) {
        self.movieId = movieId
    }
}
