//
//  Endpoint.swift
//  ysTestableNetwork
//
//  Created by Ethan Lee on 2022/05/13.
//

import Foundation
import Moya

enum APIEndpoints {
    case movieList(String, Int)
}

extension APIEndpoints: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.themoviedb.org")!
    }
    
    var path: String {
        switch self {
        case .movieList:
            return "/3/search/movie"
        }
    }
    
    var parameters: [String: Any] {
        var parameter: [String: Any] = ["api_key" : "2696829a81b1b5827d515ff121700838"]
        
        switch self {
        case .movieList(let query, let page):
            return parameter.append(["query" : query, "page" : page])
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var sampleData: Data {
        switch self {
        case .movieList(_, _):
            return Data(
                """
                {"page":1,"results":[{"adult":false,"backdrop_path":null,"genre_ids":[99],"id":547081,"original_language":"it","original_title":"Meet the Maker: Umberto Lenzi on Almost Human","overview":"An interview of Umberto Lenzi discussing the making of his film Almost Human.","popularity":0.6,"poster_path":"/2DvOyuWwGosfhvqUS769pdn8II4.jpg","release_date":"2017-04-24","title":"Meet the Maker: Umberto Lenzi on Almost Human","video":false,"vote_average":0,"vote_count":0}],"total_pages":1,"total_results":1}
                """.utf8
            )
        }
    }
    
}
