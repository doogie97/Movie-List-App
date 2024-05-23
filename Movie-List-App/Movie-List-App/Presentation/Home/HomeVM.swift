//
//  HomeVM.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

protocol HomeVMable: HomeVMInput, HomeVMOutput {}

protocol HomeVMInput {
    func getMovieList(keyword: String)
}

protocol HomeVMOutput {}

final class HomeVM: HomeVMable {
    private let getMovieListUseCase: GetMovieListUseCase
    init(getMovieListUseCase: GetMovieListUseCase) {
        self.getMovieListUseCase = getMovieListUseCase
    }
    
    private var keyword = ""
    private var movieSectionList = [MovieList]()
    
    //MARK: Input
    func getMovieList(keyword: String) {
        self.keyword = keyword
        self.movieSectionList = []
        Task {
            do {
                try await requestList(searchType: .movie)
                try await requestList(searchType: .series)
                try await requestList(searchType: .episode)
                await MainActor.run {
                    if movieSectionList.isEmpty {
                        print("검색 결과가 없습니다.")
                    }
                }
            } catch let error {
                await MainActor.run {
                    print(error.errorMessage)
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
}
