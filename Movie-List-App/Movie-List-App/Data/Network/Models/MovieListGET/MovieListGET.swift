//
//  MovieListGET.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import Alamofire

struct MovieListGET: Requestable {
    let keyword: String
    let searchType: MovieSearchType
    let page: Int
    let apiKey: String
    
    init(keyword: String,
         searchType: MovieSearchType,
         page: Int,
         apiKey: String = "aab90e3a") {
        self.keyword = keyword
        self.searchType = searchType
        self.page = page
        self.apiKey = apiKey
    }
    
    var baseURL = BaseURLCase.movieAPI.url
    var path = ""
    let headers = [String : String]()
    var params: [String : Any] {
        return [
            "apikey" : apiKey,
            "s" : keyword,
            "type" : searchType.rawValue,
            "page" : page
        ]
    }
    var httpMethod = HTTPMethod.get
    var encodingType = EncodingType.urlEncoding
    
    enum MovieSearchType: String {
        case movie
        case series
        case episode
    }
}
