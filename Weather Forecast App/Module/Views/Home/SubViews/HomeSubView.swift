//
//  HomeSubView.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct HomeSubView: View {
    var mainWeather: WeatherResponse.Main
    var body: some View {
        HStack {
            VStack {
                Text("Feels Like")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .medium)
                    .padding(.bottom, 3)
                Text("\(mainWeather.feelsLike.removeZerosFromEnd())\(UnitType.metric.deVal)")
                //Text("24\(UnitType.metric.deVal)")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .bold)
            }.frame(maxWidth: .infinity)
            Rectangle()
               .frame(width: 2,height: 80)
               .foregroundColor(Color.whiteColor)
               .padding(.horizontal, 15)
            VStack {
                Text("Max Temp")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .medium)
                    .padding(.bottom, 3)
                Text("\(mainWeather.tempMax.removeZerosFromEnd())\(UnitType.metric.deVal)")
                //Text("30\(UnitType.metric.deVal)")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .bold)
            }.frame(maxWidth: .infinity)
            Rectangle()
               .frame(width: 2,height: 80)
               .foregroundColor(Color.whiteColor)
               .padding(.horizontal, 15)
            VStack {
                Text("Min Temp")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .medium)
                    .padding(.bottom, 3)
                Text("\(mainWeather.tempMin.removeZerosFromEnd())\(UnitType.metric.deVal)")
                //Text("33\(UnitType.metric.deVal)")
                    .customText(color: .whiteColor,fontSize: 16,fontWeight: .bold)
            }.frame(maxWidth: .infinity)
        }
    }
}

//struct HomeSubView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSubView()
//    }
//}
