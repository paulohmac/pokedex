import UIKit
import Moya

extension MoyaProvider {
    
    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }

    class MoyaConcurrency {
        
        private let provider: MoyaProvider
        
        init(provider: MoyaProvider) {
            self.provider = provider
        }
   
        func sendRequest<T: Codable>(_ target: Target, retType : T.Type) async throws -> RequestResult {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success(let response):
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        do {
                            let res = try decoder.decode( T.self , from: response.data)
                            continuation.resume(returning: .success(codable: res))
                        } catch DecodingError.dataCorrupted(let context) {
                            print(context)
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                        } catch DecodingError.keyNotFound(let key, let context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                        } catch DecodingError.valueNotFound(let value, let context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                        } catch DecodingError.typeMismatch(let type, let context) {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                        }catch{
                            print(error.localizedDescription)
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                        }
                    case .failure(let error):
                        continuation.resume(returning: .error(error: ResponseError(code: error.errorCode, message: error.errorDescription ?? "")))
                    }
                }
            }
        }
    }

}

