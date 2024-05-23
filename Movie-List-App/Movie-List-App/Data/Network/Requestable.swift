//
//  Requestable.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var headers: [String : String] { get }
    var params: [String : Any] { get }
    var httpMethod: HTTPMethod { get }
    var encodingType: EncodingType { get }
}

extension Requestable {
    func dataTask<T: Decodable>(resultType: T.Type) -> DataTask<T> {
        return request.serializingDecodable(resultType)
    }
    
    private var request: DataRequest {
        return AF.request(self.baseURL + self.path,
                          method: self.httpMethod,
                          parameters: self.params,
                          encoding: self.encodingType.parameterEncoding,
                          headers: HTTPHeaders(self.headers)) { urlRequest in
            urlRequest.timeoutInterval = 10
        }
    }
}

enum BaseURLCase {
    case movieAPI
    
    var url: String {
        switch self {
        case .movieAPI:
            return "http://www.omdbapi.com"
        }
    }
}

enum EncodingType {
    case jsonEncoding
    case urlEncoding
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .jsonEncoding:
            return JSONEncoding.default
        case .urlEncoding:
            return URLEncoding.default
        }
    }
}
