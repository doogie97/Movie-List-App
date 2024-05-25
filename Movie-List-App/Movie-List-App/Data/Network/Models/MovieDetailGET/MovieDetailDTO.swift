//
//  MovieDetailDTO.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

struct MovieDetailDTO: Decodable {
    let Title: String?
    let Year: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Poster: String?
    let imdbRating: String?
}
