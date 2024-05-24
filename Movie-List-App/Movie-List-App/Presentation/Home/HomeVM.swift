//
//  HomeVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import RxRelay
import Foundation

protocol HomeVMable: HomeVMInput, HomeVMOutput, AnyObject {}

protocol HomeVMInput {
    func getMovieList(keyword: String)
}

protocol HomeVMOutput {
    var isLoading: PublishRelay<Bool> { get }
    var showAlert: PublishRelay<String> { get }
    var searchFinished: PublishRelay<Void> { get }
    var keyword: String { get }
    var movieSectionList: [MovieList] { get }
}

final class HomeVM: HomeVMable {
    private let getMovieListUseCase: GetMovieListUseCase
    init(getMovieListUseCase: GetMovieListUseCase) {
        self.getMovieListUseCase = getMovieListUseCase
    }
    
    var keyword = ""
    var movieSectionList = [MovieList]()
    
    //MARK: Input
    func getMovieList(keyword: String) {
        if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
            showAlert.accept("검색어를 입력해 주세요.")
            return
        }
        
        isLoading.accept(true)
        self.keyword = keyword
        self.movieSectionList = []
        Task {
            do {
                try await requestList(searchType: .movie)
                try await requestList(searchType: .series)
                try await requestList(searchType: .episode)
                try await requestList(searchType: .all)
                await MainActor.run {
                    if movieSectionList.isEmpty {
                        showAlert.accept("검색 결과가 없습니다.")
                    }
                    searchFinished.accept(())
                    isLoading.accept(false)
                }
            } catch let error {
                await MainActor.run {
                    showAlert.accept(error.errorMessage)
                    isLoading.accept(false)
                }
            }
        }
    }
    
    private func requestList(searchType: MovieType) async throws {
        let list = try await getMovieListUseCase.execute(keyword: keyword, searchType: searchType, page: 1)
        if list.totalCount != 0 {
            if searchType == .all && list.movieList.count > 5 {
                var movieList = list.movieList
                movieList = Array(movieList.prefix(5))
                movieSectionList.append(MovieList(
                    movieType: .all,
                    totalCount: list.totalCount,
                    movieList: movieList
                ))
            } else {
                movieSectionList.append(list)
            }
        }
    }
    
    //MARK: - Output
    struct MovieSectionInfo {
        let searchKeyword: String
        let movieSectionList: [MovieList]
    }
    
    let isLoading = PublishRelay<Bool>()
    let showAlert = PublishRelay<String>()
    let searchFinished = PublishRelay<Void>()
}
