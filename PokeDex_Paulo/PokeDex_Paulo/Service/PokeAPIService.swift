import Foundation
import Moya

public protocol PokeAPIService{
    func perfomrList(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ())
    func perfomrSearch(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ())
    func perfomrListByType(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ())
    func perfomrGetDetail(search: SendRequest, completion: @escaping (Result<Pokemon, Error>) -> ())
}

class PokeAPIHTTPService:  PokeAPIService{
    func perfomrGetDetail(search: SendRequest, completion: @escaping (Result<Pokemon, any Error>) -> ()) {
        self.requestDetail(target: search, retType: Pokemon.self, completion: { data in
            completion(data)
        })
    }

    func perfomrList(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ()){
        self.request(target: search, retType: SearchResult.self, completion: { data in
            completion(data)
        })
    }
    
    func perfomrListByType(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ()){
        self.requestByType(target: search, completion: { data in
            completion(data)
        })
    }
    

    func perfomrSearch(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ()){
        let provider = MoyaProvider<SendRequest>(plugins: [NetworkLoggerPlugin()])
        self.searchPokemons(target: search, retType: SearchResult.self, completion: { data in
            completion(data)
        })

    }
    
    private func searchPokemons<T: Decodable>(target: SendRequest, retType : T.Type, completion: @escaping (Result<SearchResult, Error>) -> ()) {
        var searchTerm = ""
        if case let .search(param: term) = target {
            searchTerm = term
        }
        let provider =  MoyaProvider<SendRequest>(plugins: [NetworkLoggerPlugin()])
        provider.request(.search(param: searchTerm)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                _ = moyaResponse.statusCode
                let jsonData = try! JSONDecoder().decode ( Pokemon.self , from: data)
                var ret  = SearchResult(results: [SearchResultItem(name: (jsonData as? Pokemon)?.forms?.first?.name ?? "", url: (jsonData as? Pokemon)?.forms?.first?.url  ?? "", pokemonData: jsonData)])
                completion(.success(ret))
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       }
    
    private func requestByType(target: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ()) {
        var fromtype = "0"
        if case let .listbyType(type) = target {
            fromtype = type
        }
        
        let provider =  MoyaProvider<SendRequest>(plugins: [NetworkLoggerPlugin()])
        provider.request(.listbyType(type: fromtype)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                let jsonData = try! JSONDecoder().decode ( SearchByType.self , from: data)
                completion(.success(
                    SearchResult(
                        results:
                            jsonData.pokemon?.map(
                                { SearchResultItem(name: $0.pokemon?["name"]  ?? "", url: $0.pokemon?["url"] ?? "") }
                            ) ?? []
                        )
                    )
                )
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       }

    
    private func request<T: Decodable>(target: SendRequest, retType : T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        var pagePosition = "0"
        if case let .list(page) = target {
            pagePosition = page
        }
        
        let provider =  MoyaProvider<SendRequest>(plugins: [NetworkLoggerPlugin()])
        provider.request(.list(param: pagePosition)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                let jsonData = try! JSONDecoder().decode ( retType.self , from: data)
                completion(.success(jsonData))
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       }
    
    private func requestDetail<T: Decodable>(target: SendRequest, retType : T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        var idDetail = "0"
        if case let .detail(id) = target {
            idDetail = id
        }
        let provider =  MoyaProvider<SendRequest>(plugins: [NetworkLoggerPlugin()])
        provider.request(.detail(id: idDetail)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                let jsonData = try! JSONDecoder().decode ( retType.self , from: data)
                completion(.success(jsonData))
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       }
/*    private func mapReturn<T : Codable>(requestReturn : Result<Response, MoyaError>, retType : T.Type) -> RequestResult{
        switch requestReturn {
        case let .success(moyaResponse):
            let statusCode = moyaResponse.statusCode
            let data = moyaResponse.data
            let jsonData = try! JSONDecoder().decode ( retType.self , from: data)
            return  .success(codable: jsonData)
        case let .failure(error):
            print(error.localizedDescription)
            return  .error(error: ResponseError(code: error.errorCode, message: error.errorDescription ?? ""))
        }
    }*/
}

public enum RequestResult {
    case success(codable : Codable)
    case error(error : Error)
}


struct ResponseError: Error {
    ///Http Codes mapping
    enum ApiHTTPCodes : Int {
        case invalidToken        = 401   //Status code 403
        case accessDenied        = 402   //Status code 403
        case forbidden           = 403   //Status code 403
        case notFound            = 404   //Status code 404
        case conflict            = 409   //Status code 409
        case internalServerError = 500   //Status code 500
    }

    let code: Int
    let message: String
}
