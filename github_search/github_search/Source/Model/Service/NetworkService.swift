//
//  NetworkService.swift
//  github_search
//
//  Created by JSilver on 2019/10/24.
//  Copyright © 2019 JSilver. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case urlNotCorrect
    case emptyData
    case parseError
}

protocol NetworkServiceProtocol {
    // TODO: Github user search
    // TODO: Github user info (public repo)
}

class NetworkService: BaseService, NetworkServiceProtocol {
    
}

struct ApiProvider<API: ApiType> {
    static func request<Model: Codable>(_ api: API) -> Single<Model> {
        Logger.info("request api : \(api.url.absoluteString)", tag: "NETWORK")
        
        return Single.create { emitter in
            DispatchQueue.global().async {
                AF.request(api.url,
                           method: api.method,
                           parameters: api.parameters,
                           headers: api.headers)
                    .response { data in
                        if let error = data.error {
                            Logger.error(error.errorDescription ?? "network error occured!", tag: "NETWORK")
                            emitter(.error(error))
                        }
                        
                        // Unwrap response data
                        guard let jsonData = data.data else {
                            emitter(.error(NetworkError.emptyData))
                            return
                        }

                        // Parse json data to model object
                        guard let model = JSONCodec.decode(jsonData, type: Model.self) else {
                            emitter(.error(NetworkError.parseError))
                            return
                        }
                        
                        // Emit succes through main thread
                        DispatchQueue.main.async {
                            emitter(.success(model))
                        }
                }
            }
            
            return Disposables.create()
        }
    }
}

protocol ApiType {
    /// Base url of api
    var baseUrl: URL { get }
    
    /// Specific path of api
    var path: String { get }
    
    /// Request method of http api
    var method: HTTPMethod { get }
    
    /// Parameters of http api
    var parameters: Parameters? { get }
    
    /// Header of http api
    var headers: HTTPHeaders? { get }
}

extension ApiType {
    var url: URL { baseUrl.appendingPathComponent(path) }
}
