//
//  MovieDetailGET.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import Alamofire

struct MovieDetailGET: Requestable {
    let movieId: String
    let apiKey: String
    
    init(movieId: String,
         apiKey: String = "aab90e3a") {
        self.movieId = movieId
        self.apiKey = apiKey
    }
    
    var baseURL = BaseURLCase.movieAPI.url
    var path = ""
    let headers = [String : String]()
    var params: [String : Any] {
        return [
            "apikey" : apiKey,
            "i" : movieId
        ]
    }
    var httpMethod = HTTPMethod.get
    var encodingType = EncodingType.urlEncoding
}
