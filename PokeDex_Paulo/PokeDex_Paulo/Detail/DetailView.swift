import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewState: DetailViewState
    @State var backToMan = false
    @Binding var closeWindows: Bool
    @Binding var pokemonTypeFilter: PokemonType
    
    var body: some View {
        ZStack{
            backgroundShapes
            VStack{
                header
                data
                avatar
                stats
            }.frame(height: UIScreen.main.bounds.height)
        }
        .background((Color(hex:viewState.viewBackgroundColor)))
        .alert(isPresented: $viewState.hasError, content: {
            Alert(
                title: Text(""),
                message: Text(viewState.errorMessage),
                dismissButton: .default(Text("Ok"))
            )
        }).dialogIcon(Image("pokebola"))
    }
    
    var backgroundShapes: some View {
        VStack{
            Circle()
                .trim(from: 0.50, to: 1.0)
                .fill(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.bottom], -UIScreen.main.bounds.width*1.25)
                .padding([.leading, .trailing], -UIScreen.main.bounds.width*0.25)
            Rectangle()
                .fill(.white)
                .frame(height: UIScreen.main.bounds.height * 0.5, alignment: .bottom)
            
        }.frame(maxHeight: UIScreen.main.bounds.height, alignment: .bottom)
    }
    
    var header: some View{
        HStack{
            HStack{
                Button{
                    closeWindows.toggle()
                }label: {
                    Image(systemName: "arrow.left").tint(.white)
                }
            }
            .padding(.leading, 16)
            Spacer()
            Header(whiteColor: true)
                .padding(.leading, -45)
                .frame(alignment: .center)
            Spacer()
        }
        .padding(.top, 24)
    }
    
    var data: some View{
        VStack{
            HStack{
                Text( "#" + viewState.code)
                    .font(.custom("pokemon-emerald", size: 18)).fontWidth(.compressed)
                    .foregroundColor(.white)
                    .frame(width: 70, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Button(viewState.pokemonType + " \u{1F50D}"){
                    self.closeAndFilterByType()
                }
                .font(.custom("pokemon-emerald", size: 20)).bold()
                .foregroundColor(.white)
                .frame(width: 100, alignment: .leading)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text( viewState.name.firstCapitalized)
                .font(.custom("pokemon-emerald", size: 32)).bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding([.top], -6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading], 16)
        .padding([.top], 16)
    }
    
    var avatar: some View{
        ScrollView (.horizontal, showsIndicators: true) {
             HStack {
                 AsyncImage(url: URL(string: viewState.sprit ),
                            content: { phase in
                     switch phase {
                     case .empty:
                         ProgressView()
                     case .success(let image):
                         image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 250, maxHeight: 250)
                     case .failure:
                         Image(systemName: "photo")
                     @unknown default:
                         EmptyView()
                     }
                 })
                 AsyncImage(url: URL(string: viewState.spritShiny ),
                            content: { phase in
                     switch phase {
                     case .empty:
                         ProgressView()
                     case .success(let image):
                         image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 250, maxHeight: 250)
                     case .failure:
                         Image(systemName: "photo")
                     @unknown default:
                         EmptyView()
                     }
                 })
             }
        }
        .padding([.bottom], 4)
        .padding([.leading ,.leading], 4)

        
    }
    
    var stats: some View{
        VStack{
            Text( String(localized:"Stats"))
                .font(.custom("pokemon-emerald", size: 22)).bold()
                .foregroundColor(Color(hex: viewState.viewBackgroundColor))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 16)
            Divider()
                .background(Color(hex: "60635e"))
                .padding([.leading, .trailing], 16)
            
            List( viewState.stats ) { item in
                HStack {
                    Text( (item.stat?.name ?? "") + ":"  )
                        .font(.custom("pokemon-emerald", size: 14))
                        .foregroundColor(Color(hex: "60635e"))
                    Text( String(item.baseStat ?? 0))
                        .font(.custom("pokemon-emerald", size: 18)).bold()
                        .foregroundColor(Color(hex: viewState.viewBackgroundColor))
                }
                .listRowSeparator(.hidden)
                .padding([.leading], -16)
                .padding([.top], -8)

            }.listRowSpacing(-8)
            .padding([.top], -30)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
    
    private func closeAndFilterByType(){
        DispatchQueue.main.async {
            closeWindows.toggle()
            pokemonTypeFilter = viewState.pokemonRawType
        }
    }
    
    init(_ id: String, closeWindow: Binding< Bool>, _ pokemonTypeFilter: Binding<PokemonType>) {
        self.viewState = DetailViewState(id)
        self._closeWindows = closeWindow
        self._pokemonTypeFilter = pokemonTypeFilter
    }
}
