import SwiftUI

class MainViewState: ObservableObject {
    private var service: PokeAPIService = PokeAPIHTTPService()
    private var currentPage = -1

    @Published var filter  = ""
    @Published var pokemonList  = [SearchResultItem]()
    @Published var searchTerm = ""
    @Published var hiddenLoading = 0.0
    @Published var hasError = false
    @Published var errorMessage = "houve uma falha"

    @Published var showLoading  = false {
        willSet(newValue){
            hiddenLoading = newValue ? 1.0 : 0.0
            print("***\(hiddenLoading)")
        }
    }

    @Published var changePage = false {
        willSet(newValue){
            nextPage()
        }
    }
    @Published var enterpressed  = false {
        willSet(newValue){
            if newValue {
               searchPokemon(searchTerm)
            }
        }
    }
    @Published var currentSelection: PokemonType = .normal {
        didSet(newValue){
            self.pokemonList.removeAll()
            listByType(newValue.rawValue.lowercased())
        }
    }
    
    init(){
    }
    
    private func searchPokemon(_ term: String) {
        if term.count == 0 {
            currentPage = -1
            nextPage()
        }else{
            search(term)
            enterpressed = false
        }
            
    }
    
    private func search(_ term: String) {
        showLoading = true
        service.search(search: .search(param: term.lowercased()),completion: { result in
            self.showLoading = false
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList = pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
                self.showError(error: error)
            }
        })
    }

    
    private func list() {
        showLoading = true
        service.search(search: .list(param: String(currentPage)),completion: { result in
            self.showLoading = false
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList += pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
                self.showError(error: error)
            }
        })
    }

    private func listByType(_ type: String) {
        showLoading = true
        service.search(search: .listbyType(type: type),completion: { result in
            self.showLoading = false
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList += pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
                self.showError(error: error)
            }
        })
    }

    public func nextPage(){
        currentPage += 1
        self.list()
    }

    public func priorPage(){
        currentPage -= 1
        
        if currentPage < 0 {
            currentPage = 0
        }
        self.list()
    }
    
    public func showError(error : Error){
        self.hasError = true
        let errorMesage = error.localizedDescription
        self.errorMessage = errorMesage == "" ? "Houve um erro" : errorMesage
        print(error)
    }
}


