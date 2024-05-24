//
//  MovieType.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

enum MovieType: String {
    case movie
    case series
    case episode
    case realTimeBest
    case all
    
    var title: String {
        switch self {
        case .movie:
            return "영화"
        case .series:
            return "시리즈"
        case .episode:
            return "에피소드"
        case .realTimeBest:
            return "실시간 베스트"
        case .all:
            return "전체"
        }
    }
}
