//
//  MovieListVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/25/24.
//

import RxRelay

protocol MovieListVMable: MovieListVMInput, MovieListVMOutput, AnyObject {}

protocol MovieListVMInput {
    func viewDidLoad()
}

protocol MovieListVMOutput {
    var setViewContents: PublishRelay<(keyword: String, searchType: MovieType)> { get }
}

final class MovieListVM: MovieListVMable {
    private let keyword: String
    private let searchType: MovieType
    
    init(keyword: String, searchType: MovieType) {
        self.keyword = keyword
        self.searchType = searchType
        
        print(keyword)
        print(searchType)
    }
    
    //MARK: - Intpu
    func viewDidLoad() {
        setViewContents.accept((keyword: keyword, searchType: searchType))
    }
    
    //MARK: - Output
    let setViewContents = PublishRelay<(keyword: String, searchType: MovieType)>()
}
