//
//  APIError.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

enum APIError: Error {
    case responseError(_ errorResponse: ErrorResponse)
    case statusCodeError(_ code: Int)
    case transportError
    case decodingError
    case timeOut
}

struct ErrorResponse: Decodable {
    let Error: String?
}

extension Error {
    var errorMessage: String {
        if let apiError = self as? APIError {
            switch apiError {
            case .responseError(let errorResponse):
                return errorResponse.Error ?? "알 수 없는 오류가 발생했습니다"
            case .statusCodeError(let code):
                return "서버 통신간 오류가 발생했습니다\nerrorCode: \(code)"
            case .transportError:
                return "서버 통신간 오류가 발생했습니다\nerrorCode: transportError"
            case .decodingError:
                return "서버 통신간 오류가 발생했습니다\nerrorCode: decodingError"
            case .timeOut:
                return "네트워크 연결이 원활하지 않습니다.\n잠시 후 다시 시도해 주세요."
            }
        }
        
        return "알 수 없는 오류가 발생했습니다"
    }
}
