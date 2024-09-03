import UIKit

public struct Pokemon: Codable,Identifiable {
    public var id = UUID()
    var apiId: Int? = 0
    let name: String
    let sprites: Sprites?
    let stats: [Stat]?
    let forms: [Form]?
    let types: [Types]?

    let statsFilter = ["attack", "defense", "special-defense"]

    var filterStats: [Stat] {
        get{
            self.stats?.filter({ stats in statsFilter.contains( stats.stat?.name ?? "" ) }).compactMap{$0} ?? []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case sprites
        case name
        case stats
        case forms
        case types
    }
}

struct Types: Codable,Identifiable{
    public var id = UUID()
    let type: Type?
    enum CodingKeys: String, CodingKey {
        case type
    }
}

struct Type: Codable,Identifiable{
    public var id = UUID()
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct Form : Codable{
    let name: String
    let url: String
}

struct Sprites: Codable{
    let frontDefault: String
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Stat: Codable,Identifiable{
    public var id = UUID()
    let baseStat: Int?
    let stat: StatInfo?
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat = "stat"
    }
}

struct StatInfo: Codable,Identifiable {
    public var id = UUID()
    let name: String
    enum CodingKeys: String, CodingKey {
        case name
    }
}

public struct SearchResult: Codable {
    var results: [SearchResultItem]?
}

struct SearchResultItem: Codable,Identifiable {
    let id = UUID()
    var apiId: String? = ""
    var name: String
    let url: String
    var pokemonData : Pokemon?

    var imgUrl: String  {
        get{
            var ret = ""
            if url != ""{
                let urlPathArray = url.components(separatedBy: "/")
                let code = urlPathArray[urlPathArray.count-2]
                ret = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(code).png"
            }
            return ret
        }

    }

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case name = "name"
        case url = "url"
    }

    func parseCode() -> String{
        var ret = ""
        if url != ""{
            let urlPathArray = url.components(separatedBy: "/")
            ret = urlPathArray[urlPathArray.count-2]
        }
        return ret
    }
}

struct SearchByType: Codable,Identifiable {
    let id = UUID()
    let pokemon : [SearchByTypeItem]?
    enum CodingKeys: String, CodingKey {
        case pokemon
    }
}

struct SearchByTypeItem: Codable,Identifiable {
    let id = UUID()
    let pokemon : [String:String]?
    enum CodingKeys: String, CodingKey {
        case pokemon
    }
}
