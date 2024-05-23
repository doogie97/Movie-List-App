//
//  MovieListGET.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import Alamofire

struct MovieListGET: Requestable {
    let keyword: String
    let searchType: MovieType
    let page: Int
    let apiKey: String
    
    init(keyword: String,
         searchType: MovieType,
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
        var params: [String : Any] = [
            "apikey" : apiKey,
            "s" : keyword,
            "page" : page
        ]
        
        if searchType != .all {
            params["type"] = searchType.rawValue
        }
        
        return params
    }
    var httpMethod = HTTPMethod.get
    var encodingType = EncodingType.urlEncoding
}
