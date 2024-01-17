//
//  Extension+Views.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct CustomTextModifier: ViewModifier {
    var color: Color?
    var fontName: String
    var fontSize: CGFloat
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        content
            .foregroundColor(color == .black ? nil : color)
            .font(Font.custom(fontName, size: fontSize))
            .fontWeight(weight)
    }
}

extension View {
    func customText(color: Color? = nil, fontName: String = "AmericanTypeWriter", fontSize: CGFloat, fontWeight: Font.Weight = .regular) -> some View {
        self.modifier(CustomTextModifier(color: color, fontName: fontName, fontSize: fontSize, weight: fontWeight))
    }
    func dismissKeyboardOnTap() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ImageView: View {
    let name: String

    var body: some View {
        AsyncImage(url: URL(string: ImageURL.logo(name: name).imageName)!) { phase in
            switch phase {
            case .success(let image):
                image
                    .renderingMode(.original).resizable()
                    //.scaledToFit()
            case .failure:
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
}

extension Color{
    static let blackColor = Color("BlackColor")
    static let whiteColor = Color("WhiteColor")
    static let blackO = Color("BlackOnly")
    static let whiteO = Color("WhiteOnly")
}

enum ImageURL{
    case logo(name: String)
    var imageName: String{
        switch self{
        case .logo(name: let name): return "https://openweathermap.org/img/wn/\(name)@2x.png"
        }
    }
}
