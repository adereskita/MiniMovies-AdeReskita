//
//  BaseAPI.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation
import Alamofire

public class BaseAPI<T:TargetType> {
    
    public func fetchData<M: Codable>(target: T, responseClass: M.Type, completionHandler: @escaping (Result<M, APIError>)-> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).validate().responseData {
            response in
            
            guard let statusCode = response.response?.statusCode else {
                print("StatusCode not found")                
                completionHandler(.failure(APIError(success: false, statusCode: 0, statusMessage: "StatusCode not found")))
                return
            }
            
            if statusCode == 200 || statusCode == 401 {
                guard let jsonData = response.data else {
                    completionHandler(.failure(APIError(success: false, statusCode: statusCode, statusMessage: "error JsonData")))
                    return
                }
                do {
                    let responseCodableObject = try JSONDecoder().decode(M.self, from: jsonData)
                    completionHandler(.success(responseCodableObject))
                } catch let error {
                    completionHandler(.failure(APIError(success: false, statusCode: statusCode, statusMessage: "error decode response")))
                }
                
            } else {
                print("error statusCode: \(statusCode)")
                if let data = response.data {
                    // MARK: Decode Api Error Response
                    guard let responseJSON = try? JSONDecoder().decode(APIError.self, from: data) else {
                        completionHandler(.failure(APIError(success: false, statusCode: statusCode, statusMessage: "failed decode response error")))
                        return
                    }
                    
                    completionHandler(.failure(responseJSON))
                }
            }
        }
    }
    
    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
}
