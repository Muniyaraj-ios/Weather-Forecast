//
//  HomeHeadView.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct HomeHeadView: View {
    var cityNameCountry: String
    @ObservedObject var weatherServiceVM: WeatherServiceVM
    var body: some View {
        HStack {
            //Spacer()
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image("pinIcon")
                        .renderingMode(.template).resizable()
                        .foregroundColor(.blackColor)
                        .frame(width: 28, height: 28)
                        .aspectRatio(contentMode: .fit)
                    Text(cityNameCountry)
                        .customText(fontSize: 24,fontWeight: .bold)
                    .padding(.bottom, 3)
                }
                Text("Today (\(Date().currentFormattedDate(with: .dayDateWeekyear)))")
                    .customText(fontSize: 16,fontWeight: .medium)
                    .padding(.leading, 12)
            }.padding(.leading, 20)
            Spacer()
            NavigationLink {
                SearchLocationView()
            } label: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template).resizable()
                    .foregroundColor(.whiteColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(15)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.blackColor.opacity(0.8))
                            .shadow(color: Color.blackColor.opacity(0.3), radius: 6, x: 0.0, y: 2)
                    }
                    .padding(.trailing, 18)
            }
        }
    }
}

//struct HomeHeadView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeHeadView(cityNameCountry: "Chennai,TN")
//    }
//}
