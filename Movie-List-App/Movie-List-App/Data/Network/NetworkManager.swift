//
//  NetworkManager.swift
//  Movie-List-App
//
//  Created by Doogie on 5/23/24.
//

import Foundation
import Alamofire

protocol NetworkManageralbe {
    func request<T: Decodable>(_ requestable: Requestable, resultType: T.Type) async throws -> T
}

struct NetworkManager: NetworkManageralbe {
    func request<T>(_ requestable: Requestable, resultType: T.Type) async throws -> T where T : Decodable {
        let response = await requestable.dataTask(resultType: resultType).response
        
        switch response.error {
        case .sessionTaskFailed(_):
            throw APIError.timeOut
        case .responseSerializationFailed(_):
            throw APIError.decodingError
        default:
            break
        }
        
        guard let status = response.response else {
            throw APIError.transportError
        }
        
        guard (200...299).contains(status.statusCode) else {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data ?? Data())
                throw APIError.responseError(errorResponse)
            } catch let error {
                throw error
            }
        }
        
        switch response.result {
        case .success(let response):
            return response
        case .failure(let error):
            debugPrint(error)
            throw APIError.transportError
        }
    }
}
