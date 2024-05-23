//
//  MovieList.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

struct MovieList {
    let movieType: MovieType
    let totalCount: Int
    let movieList: [Movie]
    
    struct Movie {
        let title: String
        let id: String
        let movieType: MovieType
        let imageUrl: String
    }
}
