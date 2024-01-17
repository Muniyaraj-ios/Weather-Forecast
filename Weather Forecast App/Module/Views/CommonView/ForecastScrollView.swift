//
//  ForecastScrollView.swift
//  Weather Forecast App
//
//  Created by Apple on 16/01/24.
//

import SwiftUI

struct ForecastScrollView: View {
    var timeList: [WeatherData.WeatherDetails]
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(timeList, id: \.dt) { value in
                        HStack(alignment: .center){
                            VStack(alignment: .center) {
                                Text(value.dt_txt.formatDate(with: .time))
                                    .customText(fontSize: 16,fontWeight: .regular)
                                ImageView(name: value.weather.first?.icon ?? "")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)//.padding(20).background(Circle().fill(Color.whiteColor)).shadow(color: Color.blackColor.opacity(0.2), radius: 4, x: 2, y: 2)
                                Text("\(value.main.tempMax.roundToDecimal(1).removeZerosFromEnd())\(UnitType.deg.deVal) / \(value.main.tempMin.roundToDecimal(1).removeZerosFromEnd())\(UnitType.deg.deVal)")
                                    .customText(fontSize: 15,fontWeight: .regular)
                                    .padding(.top, 3)
                                Text(value.weather.first?.description ?? "none")
                                    .customText(color: .gray,fontSize: 16,fontWeight: .regular)
                                    .padding(.top, 3)
                            }.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}

//struct ForecastScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForecastScrollView()
//    }
//}
