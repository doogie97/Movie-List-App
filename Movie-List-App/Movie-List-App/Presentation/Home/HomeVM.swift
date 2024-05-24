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
    func touchMoreButton(sectionIndex: Int)
    func touchMovieItem(indexPath: IndexPath)
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
                try await requestList(searchType: .realTimeBest)
                try await requestList(searchType: .all)
                await MainActor.run {
                    if movieSectionList.isEmpty || (movieSectionList.count == 1 && movieSectionList.first?.movieType == .realTimeBest) {
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
    
    func touchMoreButton(sectionIndex: Int) {
        print("\(sectionIndex)번 섹션 전체보기")
    }
    
    func touchMovieItem(indexPath: IndexPath) {
        guard let movie = movieSectionList[safe: indexPath.section]?.movieList[safe: indexPath.row] else {
            showAlert.accept("해당 영화 정보를 불러올 수 없습니다.")
            return
        }
        
        print(movie.title)
    }
    
    //MARK: - Output
    struct MovieSectionInfo {
        let searchKeyword: String
        let movieSectionList: [MovieList]
    }
    
    let isLoading = PublishRelay<Bool>()
    let showAlert = PublishRelay<String>()
    let searchFinished = PublishRelay<Void>()
    var keyword = ""
    var movieSectionList = [MovieList]()
}
