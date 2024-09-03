import SwiftUI
import AVFoundation
import AVKit
import SDWebImage
import SDWebImageSwiftUI

struct SearchResultView: View {
    @State private var selection: UUID?
    @State private var openMovie: Bool = false
    @Namespace private var bottomID
    @Binding var pokemonList: [SearchResultItem]
    @Binding var updateList: Bool

    var body: some View {
        ZStack{
            ScrollViewReader { proxy in
                ScrollView(.vertical){
                    LazyVGrid(
                        columns: [GridItem(spacing: 0), GridItem(spacing: 0)],
                        spacing: 16
                    )  {
                        ForEach(pokemonList) { pokemon in
                            VStack {
                                Text( pokemon.name)
                                    .font(.custom("pokemon-emerald", size: 18)).bold()
                                    .foregroundStyle(Color(hex: "f4fdff"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                Text( "#\(pokemon.parseCode())")
                                    .font(.custom("pokemon-emerald", size: 16)).bold()
                                    .foregroundStyle(Color(hex: "4f8231"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                
                               WebImage(url: URL(string: pokemon.imgUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity) // Activity Indicator
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .scaledToFit()
                                .frame(width: 60, height: 60, alignment: .center)
                                .padding(.top, -16)
                            }.onTapGesture {
                                selection = pokemon.id
                            }
                            .frame(width: 160, height:120)
                            .background(Color(hex: "63e6c6"))
                            .cornerRadius(20.0)
                        }
                    }
                    .onChange(of: selection) { _, newValue in
                        let item = pokemonList.filter({$0.id == selection}).first
                        self.openMovie = true
                    } .fullScreenCover(isPresented: $openMovie, content: {
                        let item = pokemonList.filter({$0.id == selection}).first
                        FullScreenVide(item?.name ?? "", closeWindow: $openMovie)
                    })
                    Text("").id(bottomID)
                }.onAppear(perform: {
                    proxy.scrollTo(bottomID)
                })
                .refreshable {
                    updateList.toggle()
                }
            }
        }
    }
}
