//
//  APIError.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

enum APIError: Error {
    case responseError(_ errorResponse: ErrorResponse)
    case transportError
    case timeOut
    
    var errorMessage: String? {
        switch self {
        case .responseError(let errorResponse):
            return errorResponse.Error
        case .transportError:
            return "서버 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요"
        case .timeOut:
            return "요청 시간이 초과됐습니다.\n다시 시도해 주세요."
        }
    }
}

struct ErrorResponse: Decodable {
    let Error: String?
}
