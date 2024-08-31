import Foundation
import Moya

public enum SendRequest : TargetType{
    case search(param: String)
    case detail(id: String)
    case list(param: String)
    case listbyType(type: String)
}

extension SendRequest {

    public var baseURL: URL {
        return URL(string: Configuration.baseUrl)!
    }
    
    public var path: String{
        switch self {
        case .search(let param):
            return String(format:"pokemon/%@/", param)
        case .detail(let id):
            return String(format:"pokemon/%@/", id)
        case .list(_):
            return "pokemon/"
        case .listbyType(let type):
            return String(format:"type/%@/", type)
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .search, .detail, .list, .listbyType:
            return .get
        }
    }
    
    public var task: Moya.Task {
        var parameters = [String: String]()
        switch self {
        case .search:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .detail:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .list(let page):
            parameters["limit"] = "20"
            parameters["offset"] = page
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .listbyType(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]?{
        return ["Content-type": "text/plain"]
    }
    
    public var sampleData: Data {
            return Data()
    }
    
}

