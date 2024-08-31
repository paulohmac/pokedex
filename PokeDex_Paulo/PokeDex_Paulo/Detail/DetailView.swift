import SwiftUI

struct DetailView: View {
    @Binding var closeWindows: Bool
    @ObservedObject var viewState: DetailViewState
    
    @Environment(\.dismiss) var dismiss
    @State var backToMan = false
    
    var body: some View {
        Button("Voltar"){
            closeWindows.toggle()
            //backToMan.toggle()
        }
            VStack{
                AsyncImage(url: URL(string: viewState.sprit  )).frame(width: 40.0, height: 40.0)
                    .padding([.bottom], 4)
                    .padding([.leading ,.leading], 4)
                Text( viewState.name)
                    .padding([.bottom], 4)
                    .padding([.leading ,.leading], 4)
                
                List( viewState.stats ) { item in
                    HStack {
                        Text( item.stat?.name ?? "")
                        Text( String(item.baseStat ?? 0))
                    }
                }
        }.fullScreenCover(isPresented: $backToMan, content: {
            
//            MainView()
        })
    }

    init(_ id: String, closeWindow: Binding< Bool>) {
        self.viewState = DetailViewState(id)
        self._closeWindows = closeWindow
    }
}
