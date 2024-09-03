import SwiftUI

struct Header: View {
    let whiteColor: Bool
    
    var body: some View {
        HStack{
            Image("pokebola")
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.leading, 24)
                .foregroundColor(whiteColor ? .white : Color(hex: "7c9aa3"))
            Text(String(localized:"Paulo Pokedex"))
                .font(.custom("pokemon-emerald", size: 18))
                .foregroundColor(whiteColor ? .white : Color(hex: "60635e"))
                .cornerRadius(15.0)
        }
    }
}
