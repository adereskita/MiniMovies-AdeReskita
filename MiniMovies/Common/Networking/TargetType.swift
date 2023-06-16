//
//  TargetType.swift
//  MiniMovies
//
//  Created by Ade on 6/13/23.
//

import Foundation
import Alamofire

public enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//The header fields API
public enum HttpHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

//The content type (JSON)
public enum ContentType: String {
    case json = "application/json"
}

public enum Task {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}


public protocol TargetType {
    
    var baseURL: String {get}
    
    var path: String {get}
    
    var method: HTTPMethods {get}
    
    var task: Task {get}
    
    var headers: [String: String]? {get}
}
