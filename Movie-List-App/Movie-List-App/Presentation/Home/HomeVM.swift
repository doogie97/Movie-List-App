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
    var searchFinished: PublishRelay<Bool> { get }
    var showMovieList: PublishRelay<(keyword: String, searchType: MovieType)> { get }
    var showMovieDetail: PublishRelay<String> { get }
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
                    let isEmptyResult = movieSectionList.isEmpty || (movieSectionList.count == 1 && movieSectionList.first?.movieType == .realTimeBest)
                    searchFinished.accept(isEmptyResult)
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
            movieSectionList.append(list)
        }
    }
    
    func touchMoreButton(sectionIndex: Int) {
        guard let section = movieSectionList[safe: sectionIndex] else {
            return
        }
        showMovieList.accept((keyword: self.keyword, searchType: section.movieType))
    }
    
    func touchMovieItem(indexPath: IndexPath) {
        guard let movie = movieSectionList[safe: indexPath.section]?.movieList[safe: indexPath.row] else {
            showAlert.accept("해당 영화 정보를 불러올 수 없습니다.")
            return
        }
        
        showMovieDetail.accept(movie.id)
    }
    
    //MARK: - Output
    struct MovieSectionInfo {
        let searchKeyword: String
        let movieSectionList: [MovieList]
    }
    
    let isLoading = PublishRelay<Bool>()
    let showAlert = PublishRelay<String>()
    let searchFinished = PublishRelay<Bool>()
    let showMovieList = PublishRelay<(keyword: String, searchType: MovieType)>()
    let showMovieDetail = PublishRelay<String>()
    var keyword = ""
    var movieSectionList = [MovieList]()
}
