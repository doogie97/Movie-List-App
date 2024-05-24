//
//  MovieListVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

protocol MovieListVMable: MovieListVMInput, MovieListVMOutput, AnyObject {}

protocol MovieListVMInput {}

protocol MovieListVMOutput {}

final class MovieListVM: MovieListVMable {
    private let keyword: String
    private let searchType: MovieType
    
    init(keyword: String, searchType: MovieType) {
        self.keyword = keyword
        self.searchType = searchType
        
        print(keyword)
        print(searchType)
    }
}
