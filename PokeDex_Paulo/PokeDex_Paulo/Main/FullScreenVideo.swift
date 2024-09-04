import SwiftUI
import AVFoundation
import AVKit

struct FullScreenVide: View {
    @State var player: AVPlayer? = AVPlayer(url:  Bundle.main.url(forResource: "pokemon-ash", withExtension: "mp4")! )
    @State var opa = 0.0
    @State var opendDetail: Bool = false
    @Binding var closeWindow: Bool
    @Binding var pokemonTypeFilter: PokemonType
    private var pub = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    private var name = ""
    @Environment(\.dismiss) private var dismiss
    
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
                DetailView(name, closeWindow: $closeWindow, $pokemonTypeFilter)
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
    
    init(_ id: String, closeWindow: Binding< Bool>,_ pokemonTypeFilter: Binding<PokemonType>){
        name = id
        self._closeWindow = closeWindow
        self._pokemonTypeFilter = pokemonTypeFilter
    }
}


struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
