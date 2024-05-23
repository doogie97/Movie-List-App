//
//  MovieListDTO.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

struct MovieListDTO: Decodable {
    let totalResults: String?
    let Search: [Search]?
    
    struct Search: Decodable {
        let Title: String?
        let imdbID: String?
        let `Type`: String?
        let Poster: String?
    }
}
