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
    func touchMovieItem(index: Int)
}

protocol MovieListVMOutput {
    var setViewContents: PublishRelay<(keyword: String, searchType: MovieType)> { get }
    var showAlert: PublishRelay<String> { get }
    var pagingFinished: PublishRelay<Void> { get }
    var movieList: [MovieList.Movie] { get }
    var hasNext: Bool { get }
    var showMovieDetail: PublishRelay<String> { get }
}

final class MovieListVM: MovieListVMable {
    private let getMovieListUseCase: GetMovieListUseCase
    
    init(getMovieListUseCase: GetMovieListUseCase,
         keyword: String,
         searchType: MovieType) {
        self.getMovieListUseCase = getMovieListUseCase
        self.keyword = keyword
        self.searchType = searchType
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
                    self.movieList += list.movieList
                    if totalCount <= self.movieList.count {
                        hasNext = false
                    }
                    pagingFinished.accept(())
                    page += 1
                }
            } catch let error {
                await MainActor.run {
                    showAlert.accept(error.errorMessage)
                }
            }
        }
    }
    
    func touchMovieItem(index: Int) {
        guard let movie = movieList[safe: index] else {
            showAlert.accept("해당 영화 정보를 불러올 수 없습니다.")
            return
        }
        
        showMovieDetail.accept(movie.id)
    }
    
    //MARK: - Output
    let setViewContents = PublishRelay<(keyword: String, searchType: MovieType)>()
    let showAlert = PublishRelay<String>()
    let pagingFinished = PublishRelay<Void>()
    var movieList = [MovieList.Movie]()
    var hasNext = true
    let showMovieDetail = PublishRelay<String>()
}
