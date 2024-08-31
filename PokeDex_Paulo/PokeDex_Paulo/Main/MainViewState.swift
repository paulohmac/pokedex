import SwiftUI

class MainViewState: ObservableObject {
    private var service: PokeAPIService = PokeAPIHTTPService()
    private var currentPage = -1
    @Published var filter  = ""
    @Published var pokemonList  = [SearchResultItem]()
    @Published var enterpressed  = false {
        willSet(newValue){
            if newValue {
               searchPokemon(searchTerm)
            }
        }
    }
    @Published var searchTerm = ""

    @Published var changePage = false {
        willSet(newValue){
            nextPage()
        }
    }


    
    @Published var selectedType : String = "Normal" {
        willSet(newValue){
            if selectedType != "" {
                self.pokemonList.removeAll()
                listByType(newValue.lowercased())
            }
        }
    }
    
    init(){
    }
    
    private func searchPokemon(_ term: String) {
        guard term.count > 0 else{
            return
        }
        search(term)
        enterpressed = false
    }
    
    private func search(_ term: String) {
        service.perfomrSearch(search: .search(param: term.lowercased()),completion: { result in
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList = pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
//                showError(error: error)
            }
        })
    }

    private func list() {
        service.perfomrList(search: .list(param: String(currentPage)),completion: { result in
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList += pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
//                showError(error: error)
            }
        })
    }

    private func listByType(_ type: String) {
        service.perfomrListByType(search: .listbyType(type: type),completion: { result in
            switch result {
            case .success(let pokemonRetList):
                self.pokemonList += pokemonRetList.results ?? []
            case .failure(let error):
                print(error)
//                showError(error: error)
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
//        errorHadling?.showError(msg: error)
        print(error)
    }
}
