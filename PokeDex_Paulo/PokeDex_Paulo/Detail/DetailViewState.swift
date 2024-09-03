import UIKit

class DetailViewState: ObservableObject {
    private lazy var service: PokeAPIService = PokeAPIHTTPService()
    private var id = ""
    private var pokemonData : Pokemon?
    @Published var sprit: String = ""
    @Published var name: String = ""
    @Published var stats: [Stat] = []
    @Published var code: String = ""
    @Published var viewBackgroundColor: String = ""
    @Published var hasError = false
    @Published var errorMessage = "houve uma falha"
    
    init(_ id: String){
        self.id = id
        loadPokemonData(id)
    }
  
    private func loadPokemonData(_ term: String) {
        service.perfomrGetDetail(search: .detail(id: id.lowercased()),completion: { result in
            switch result {
            case .success(let pokemon):
                self.pokemonData = pokemon
                self.setData()
            case .failure(let error):
                print(error)
                self.showError(error: error)
            }
        })
    }

    private func setData(){
        self.name = pokemonData?.name  ?? ""
        self.sprit = pokemonData?.sprites?.frontDefault  ?? ""
        self.stats = pokemonData?.filterStats ?? []
        self.code = String(pokemonData?.apiId ?? 0)
        self.viewBackgroundColor = pokemonTypeColors[pokemonData?.types?[0].type?.name.firstCapitalized ?? ""] ?? ""
    }
    
    public func showError(error : Error){
        self.hasError = true
        let errorMesage = error.localizedDescription
        self.errorMessage = errorMesage == "" ? "Houve um erro" : errorMesage
        print(error)
    }
}
