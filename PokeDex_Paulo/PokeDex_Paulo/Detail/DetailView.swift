import SwiftUI

struct DetailView: View {
    @Binding var closeWindows: Bool
    @ObservedObject var viewState: DetailViewState
    
    @Environment(\.dismiss) var dismiss
    @State var backToMan = false
    
    var body: some View {

        ZStack{
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

            VStack{
                HStack{
                    Button{
                        closeWindows.toggle()
                        //backToMan.toggle()
                    }label: {
                        Image(systemName: "arrow.left").tint(.white)
                    }.padding(.leading, 16)
                    Spacer()
                    HStack{
                        Image("pokebola")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 24)
                            .foregroundColor(Color(hex: "7c9aa3"))
                            .tint(.white)
                        Text("Paulo Pokedex")
                            .font(.custom("pokemon-emerald", size: 18))
                            .foregroundColor(.white)
                            .cornerRadius(15.0)
                    }
                    .frame(alignment: .center) 
                    Spacer()
                }.padding(.top, 24)
                
                VStack{
                    Text( "#" + viewState.code)
                        .font(.custom("pokemon-emerald", size: 18)).fontWidth(.compressed)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text( viewState.name.firstCapitalized)
                        .font(.custom("pokemon-emerald", size: 32)).bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding([.top], -12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading], 16)
                .padding([.top], 16)

               AsyncImage(url: URL(string: viewState.sprit ),
                          content: { phase in
                   switch phase {
                   case .empty:
                       ProgressView()
                   case .success(let image):
                       image.resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(maxWidth: 300, maxHeight: 300)
                   case .failure:
                       Image(systemName: "photo")
                   @unknown default:
                       // Since the AsyncImagePhase enum isn't frozen,
                       // we need to add this currently unused fallback
                       // to handle any new cases that might be added
                       // in the future:
                       EmptyView()
                   }
                   
               })
               .padding([.bottom], 4)
               .padding([.leading ,.leading], 4)
               

                Text( "Stats")
                    .font(.custom("pokemon-emerald", size: 18)).bold()
                    .foregroundColor(Color(hex: "60635e"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                Divider()
                    .background(Color(hex: "60635e"))
                    .padding([.leading, .trailing], 16)
                
                List( viewState.stats ) { item in
                   HStack {
                       Text( (item.stat?.name ?? "") + ":"  )
                           .font(.custom("pokemon-emerald", size: 12))
                           .foregroundColor(Color(hex: "60635e"))
                       Text( String(item.baseStat ?? 0))
                           .font(.custom("pokemon-emerald", size: 14)).bold()
                           .foregroundColor(Color(hex: "60635e"))
                   }.listRowSeparator(.hidden)
                        .padding([.top], -10)
               }
                .padding([.top], -30)
               .scrollDisabled(true)
               .scrollContentBackground(.hidden)
               .frame(maxWidth: .infinity, alignment: .bottom)
           }.frame(height: UIScreen.main.bounds.height)
        }
        .background(.orange)
    }

    init(_ id: String, closeWindow: Binding< Bool>) {
        self.viewState = DetailViewState(id)
        self._closeWindows = closeWindow
    }
}
