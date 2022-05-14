//
//  Network.swift
//  ysTestableNetwork
//
//  Created by Ethan Lee on 2022/05/13.
//

import Foundation
import RxSwift
import Moya

enum NetworkServiceError: Error {
    case parseFailed(Error)
    case moyaError(MoyaError)
    case serverError(Response)
}

protocol NetworkServiceProtocol: AnyObject {
    associatedtype T: TargetType
    
    var provider: MoyaProvider<T>! { get set }
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((T) -> Endpoint)?)
}

extension NetworkServiceProtocol {

    func request<D: Decodable>(type: D.Type, target: T) -> Single<D> {
        provider.rx.request(target).map(type)
    }
    
}


class NetworkService: NetworkServiceProtocol {

    typealias T = APIEndpoints
    internal var provider: MoyaProvider<APIEndpoints>!
    
    required init(isStub: Bool = false, sampleStatusCode: Int = 200, customEndpointClosure: ((T) -> Endpoint)? = nil) {
        provider = initProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    private func initProvider(
        _ isStub: Bool = false,
        _ sampleStatusCode: Int = 200,
        _ customEndpointClosure: ((T) -> Endpoint)? = nil) -> MoyaProvider<T> {

        if isStub == false {
            return MoyaProvider<T>(
                endpointClosure: {
                    MoyaProvider<T>.defaultEndpointMapping(for: $0)
                },
                plugins: [CustomLoggerPlugin()]
            )
        } else {
            let endPointClosure = { (target: T) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }

                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            
            return MoyaProvider<T>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
    
}
