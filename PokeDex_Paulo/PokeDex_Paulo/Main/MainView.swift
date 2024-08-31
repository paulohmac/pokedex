import SwiftUI


struct MainView: View {
    @ObservedObject var viewState = MainViewState()
    @State private var favoriteColor = 0
    @State var currentSelection = "Bug"
    
    var pokemonType  =  [
        "Normal",
        "Fighting",
        "Flying",
        "Poison",
        "Ground",
        "Rock",
        "Bug",
        "Ghost",
        "Steel",
        "Fire",
        "Water",
        "Grass",
        "Electric",
        "Psychic",
        "Ice",
        "Dragon",
        "Dark",
        "Fairy",
        "Unknown",
        "Shadow"
    ]
    
    var body: some View {
      
        Picker("Pick a language", selection: $currentSelection) { // 3
                    ForEach(pokemonType, id: \.self) {
                        Text($0) // 5
                    }
                }
        
            VStack {
                VStack {
                    HStack{
                        Image("pokebola")
                          .renderingMode(.template)
                          .resizable()
                          .frame(width: 20, height: 20)
                          .padding(.leading, 24)
                          .foregroundColor(Color(hex: "7c9aa3"))
                        Text("Paulo Pokedex")
                            .font(.custom("pokemon-emerald", size: 18))
                            .foregroundColor(Color(hex: "60635e"))
                            .cornerRadius(15.0)
                    }
                    
                    VStack{
                        ZStack(alignment: .leading ){
                            TextField("type pokemon name or number", text: $viewState.searchTerm)
                                .frame(height: 30.0)
                                .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 16))
                                .textCase(.lowercase)
                                .font(.custom("pokemon-emerald", size: 18))
                                .onSubmit {
                                    viewState.enterpressed.toggle()
                                }
                                .background(Color(hex: "f5f5f5"))
                                .cornerRadius(15.0)
                                .padding([.bottom], 4)
                                .padding([.leading,.trailing ], 16)

                            Image("lupa")
                              .renderingMode(.template)
                              .resizable()
                              .frame(width: 20, height: 20)
                              .padding(.leading, 24)
                              .foregroundColor(Color(hex: "7c9aa3"))
                        }
                    }

                    Button("Search") {}
                    .background(Color(hex: "e0d250"))
                    .frame(width: 80)
                    .cornerRadius(4.0)
                    .overlay(RoundedRectangle(cornerRadius: 4.0).strokeBorder(Color(hex: "dfdcd8"), lineWidth: 2))
                    .padding(2.0)
                    .overlay(RoundedRectangle(cornerRadius: 6.0).strokeBorder(Color(hex: "b2b0ae"), lineWidth: 1))
                    .font(.custom("pokemon-emerald", size: 18))
                    .foregroundColor(Color(hex: "b5a36c"))
                    .padding([.leading, .trailing ], 32)
                    .padding([.bottom], 4)
                }
                .padding([.top], 16)
                .onAppear{
                    viewState.nextPage()
                }
                SearchResultView(pokemonList: $viewState.pokemonList, updateList: $viewState.changePage)
            }.background(.white)

    }
    

}

#Preview {
    MainView(viewState: MainViewState())
}
