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
    func getMovieList()
}

protocol MovieListVMOutput {
    var setViewContents: PublishRelay<(keyword: String, searchType: MovieType)> { get }
    var pagingFinished: PublishRelay<Int> { get }
    var movieList: [MovieList.Movie] { get }
}

final class MovieListVM: MovieListVMable {
    private let getMovieListUseCase: GetMovieListUseCase
    
    init(getMovieListUseCase: GetMovieListUseCase,
         keyword: String,
         searchType: MovieType) {
        self.getMovieListUseCase = getMovieListUseCase
        self.keyword = keyword
        self.searchType = searchType
        
        print(keyword)
        print(searchType)
    }
    
    private let keyword: String
    private let searchType: MovieType
    private var page = 1
    private var totalCount = 0
    
    //MARK: - Intput
    func viewDidLoad() {
        setViewContents.accept((keyword: keyword, searchType: searchType))
        getMovieList()
    }
    
    func getMovieList() {
        Task {
            do {
                let list = try await getMovieListUseCase.execute(
                    keyword: keyword,
                    searchType: searchType,
                    page: page
                )
                self.totalCount = list.totalCount
                await MainActor.run {
                    pagingFinished.accept(list.totalCount)
                    print(list.totalCount)
                }
            } catch let error {
                await MainActor.run {
                    print(error)
                }
            }
        }
    }
    
    //MARK: - Output
    let setViewContents = PublishRelay<(keyword: String, searchType: MovieType)>()
    let pagingFinished = PublishRelay<Int>()
    var movieList = [MovieList.Movie]()
}
