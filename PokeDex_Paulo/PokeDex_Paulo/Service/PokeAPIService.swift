import Foundation
import Moya

public protocol PokeAPIService{
    func perfomrGetDetail(search: SendRequest, completion: @escaping (Result<Pokemon, Error>) -> ())
    func search(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ())
}

class PokeAPIHTTPService:  PokeAPIService{
    func perfomrGetDetail(search: SendRequest, completion: @escaping (Result<Pokemon, any Error>) -> ()) {
        self.requestDetail(target: search, retType: Pokemon.self, completion: { data in
            completion(data)
        })
    }
    
    func search(search: SendRequest, completion: @escaping (Result<SearchResult, Error>) -> ()){
        switch search {
        case let .list(page):
            self.request(target: search, retType: SearchResult.self, completion: { data in
                completion(data)
            })
        case .search(param: let param):
            self.searchPokemons(target: search, retType: SearchResult.self, completion: { data in
                completion(data)
            })
        case .listbyType(type: let type):
            self.requestByType(target: search, completion: { data in
                completion(data)
            })
        default:
            ()
        }
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
                let statuCode = moyaResponse.statusCode
                do {
                    let data = moyaResponse.data
                    let jsonData = try JSONDecoder().decode ( Pokemon.self , from: data)
                    let ret  = SearchResult(results: [SearchResultItem(name: jsonData.forms?.first?.name ?? "", url: jsonData.forms?.first?.url  ?? "", pokemonData: jsonData)])
                    completion(.success(ret))
                } catch{
                    if statuCode == 404 {
                        completion(.failure(ResponseError(code: 400, message: "Not found")))
                        
                    }else{
                        completion(.failure(ResponseError(code: 500, message: "Error")))
                    }
                }
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
                let jsonData = try! JSONDecoder().decode ( retType.self , from: data)
                completion(.success(jsonData))
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

