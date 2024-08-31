import UIKit

class DetailViewState: ObservableObject {
    private lazy var service: PokeAPIService = PokeAPIHTTPService()
    private var id = ""
    private var pokemonData : Pokemon?
    @Published var sprit: String = ""
    @Published var name: String = ""
    @Published var stats: [Stat] = []

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
//                showError(error: error)
            }
        })
    }

    private func setData(){
        self.name = pokemonData?.name  ?? ""
        self.sprit = pokemonData?.sprites?.frontDefault  ?? ""
        self.stats = pokemonData?.filterStats ?? []
    }
    
    
    public func showError(error : Error){
//        errorHadling?.showError(msg: error)
        print(error)
    }
}
