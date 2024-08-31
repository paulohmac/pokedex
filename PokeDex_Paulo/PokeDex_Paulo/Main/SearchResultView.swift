import SwiftUI
import AVFoundation
import AVKit
import SDWebImage
import SDWebImageSwiftUI

struct SearchResultView: View {
    @Binding var pokemonList: [SearchResultItem]
    @Binding var updateList: Bool
    @State var selection: UUID?
    @State var openMovie: Bool = false
    @Namespace var bottomID
    
    var body: some View {
        ZStack{
            ScrollViewReader { proxy in
                ScrollView(.vertical){
                    LazyVGrid(
                        columns: [GridItem(spacing: 2), GridItem(spacing: 2)],
                        spacing: 8
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
                                    image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
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
                            .background(Color(hex: "49d3b2") )
                            .cornerRadius(20.0)
                        }
                        
                    }
                    .onChange(of: selection) { _, newValue in
                        let item = pokemonList.filter({$0.id == selection}).first
                        print(item?.url )
                        print(item?.pokemonData?.name )
                        self.openMovie = true
                    } .fullScreenCover(isPresented: $openMovie, content: {
                        let item = pokemonList.filter({$0.id == selection}).first
                        FullScreen(item?.name ?? "", closeWindow: $openMovie)
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
struct FullScreen: View {
    @State var player: AVPlayer? = AVPlayer(url:  Bundle.main.url(forResource: "pokemon-ash", withExtension: "mp4")! )
    @State var opa = 0.0
    @State var opendDetail: Bool = false
    @Binding var closeWindow: Bool
    var pub = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    var name = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                videoView
                    .onReceive(pub) { (output) in
                        self.opendDetail.toggle()
                    }
                    .opacity(opa)
                Spacer()
            } .fullScreenCover(isPresented: $opendDetail, content: {
                DetailView(name, closeWindow: $closeWindow)
            })
            
        }.onAppear{
            self.playVideo()
        }.onChange(of: closeWindow, {
            dismiss()
        })
    }
    var videoView: some View {
        VideoPlayer(player: player)
            .frame(width: 400, height: 300, alignment: .center)
    }

    private func playVideo(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            opa = 1.0
            player?.play()
        })
    }
    
    init(_ id: String, closeWindow: Binding< Bool>){
        name = id
        self._closeWindow = closeWindow
    }
}



//#Preview {
//    SearchResultView()
//}
