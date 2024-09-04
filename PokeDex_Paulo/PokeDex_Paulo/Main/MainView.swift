import SwiftUI


struct MainView: View {
    @ObservedObject var viewState = MainViewState()
    @State private var favoriteColor = 0
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    VStack {
                        Header(whiteColor: false)
                        searchField
                    }
                    .padding([.top], 16)
                    .onAppear{
                        viewState.nextPage()
                    }
                    SearchResultView(
                        pokemonList: $viewState.pokemonList,
                        updateList: $viewState.changePage,
                        selectedTypeColor: $viewState.selectedTypeColor,
                        selectedType: $viewState.currentSelection
                    )
                }.background(.white)
                progressBar
            }
        }.alert(isPresented: $viewState.hasError, content: {
            Alert(title: Text(""), message: Text(viewState.errorMessage), dismissButton: .default(Text(String(localized:"Ok"))))
        }).dialogIcon(Image("pokebola"))
    }
    
    var searchField: some View{
        VStack{
            ZStack(alignment: .leading ){
                TextField(String(localized:"search"), text: $viewState.searchTerm)
                    .frame(height: 30.0)
                    .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 16))
                    .textCase(.lowercase)
                    .font(.custom("pokemon-emerald", size: 18))
                    .onSubmit {
                        viewState.enterpressed = true
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
            typeSelection
        }
    }
    
    var progressBar: some View{
        ProgressView {
            Image("pokebola")
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(hex: "7c9aa3"))

        }
        .scaleEffect(3)
        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "60635e")))
        .opacity(viewState.hiddenLoading)

    }
    
    var typeSelection: some View{
        HStack{
            Picker(String(localized:"Pokemon type:"), selection: $viewState.currentSelection) {
                ForEach(PokemonType.allCases) { flavor in
                    Text(flavor.rawValue.capitalized)
                }
            }
            .frame(width: 200, alignment: .trailing)
            .accentColor(Color(hex: "60635e"))
            .padding([.leading, .trailing], 32)
            .pickerStyle(.navigationLink)
            .background(.white)
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview {
    MainView(viewState: MainViewState())
}


