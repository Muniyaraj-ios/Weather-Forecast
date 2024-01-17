//
//  SearchSubCellView.swift
//  Weather Forecast App
//
//  Created by Apple on 16/01/24.
//

import SwiftUI

struct SearchSubCellView: View {
    @ObservedObject var forecastServiceVM: ForecastWeatherServiceVM
    @State private var homeList: [CurrentWeatherSplit] = .init()
    var body: some View {
        HStack{
            ScrollView(.horizontal, showsIndicators: true) {
                if let weatherData = forecastServiceVM.weatherReqData.weatherData{
                    HStack {
                        VStack {
                            Text("Feels Like")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                .padding(.bottom, 3)
                            Text("\(weatherData.main.feelsLike)"+" \(UnitType.deg.deVal)")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                        }
                        Rectangle()
                            .frame(width: 2,height: 80)
                            .foregroundColor(Color.blackColor)
                            .padding(.horizontal, 15)
                        VStack {
                            Text("Temp")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                .padding(.bottom, 3)
                            Text("\(weatherData.main.tempMax.roundToDecimal(1).removeZerosFromEnd()) \(UnitType.deg.deVal) / \(weatherData.main.tempMin.roundToDecimal(1).removeZerosFromEnd()) \(UnitType.deg.deVal)")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                        }
                        Rectangle()
                            .frame(width: 2,height: 80)
                            .foregroundColor(Color.blackColor)
                            .padding(.horizontal, 15)
                        VStack {
                            Text("Humidity")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                .padding(.bottom, 3)
                            Text(weatherData.main.humidity.description+" %")
                                .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                        }
                        Rectangle()
                            .frame(width: 2,height: 80)
                            .foregroundColor(Color.blackColor)
                            .padding(.horizontal, 15)
                        HStack {
                            VStack {
                                Text("Wind Speed")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                    .padding(.bottom, 3)
                                Text(weatherData.wind.speed.description+" km/h")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                            }
                            Rectangle()
                                .frame(width: 2,height: 80)
                                .foregroundColor(Color.blackColor)
                                .padding(.horizontal, 15)
                            VStack {
                                Text("Visibility")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                    .padding(.bottom, 3)
                                Text(weatherData.visibility.meterToKiloMeter().description+" km")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                            }
                            Rectangle()
                                .frame(width: 2,height: 80)
                                .foregroundColor(Color.blackColor)
                                .padding(.horizontal, 15)
                            VStack {
                                Text("Air Pressure")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .medium)
                                    .padding(.bottom, 3)
                                Text(weatherData.main.pressure.description+" hPa")
                                    .customText(color: .blackColor,fontSize: 16,fontWeight: .bold)
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct SearchSubCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchSubCellView()
//    }
//}
