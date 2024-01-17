//
//  SearchAnotherView.swift
//  Weather Forecast App
//
//  Created by Apple on 16/01/24.
//

import SwiftUI

struct SearchAnotherView: View {
    
    @ObservedObject var forecastServiceVM: ForecastWeatherServiceVM
    
    var body: some View {
        VStack {
            if let weatherdata = forecastServiceVM.weatherReqData.weatherData{
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Image("pinIcon")
                                        .renderingMode(.template).resizable()
                                        .foregroundColor(.blackColor.opacity(0.8))
                                        .frame(width: 25, height: 25)
                                        .aspectRatio(contentMode: .fit)
                                    Text(weatherdata.name+", \(weatherdata.sys.country)")
                                        .customText(fontSize: 20,fontWeight: .semibold)
                                        .padding(.bottom, 3)
                                    Spacer()
                                }
                                HStack(alignment: .top) {
                                    Text(weatherdata.main.temp.description)
                                        .customText(fontSize: 30,fontWeight: .bold)
                                        .padding(.bottom, 2)
                                    Text("\(UnitType.metric.deVal)")
                                        .customText(fontSize: 18,fontWeight: .bold)
                                        .padding(.bottom, 2)
                                    Text(weatherdata.weather.first?.description ?? "none")
                                        .customText(fontSize: 16,fontWeight: .regular).padding(.top, 10)
                                        .padding(.bottom, 2)
                                }
                            }
                            HStack {
                                ImageView(name: weatherdata.weather.first?.icon ?? "")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120,height: 120)
                                    .padding(.vertical, -28).padding(.leading, -10)
                                    .background(
                                        Circle()
                                            .fill(Color.whiteColor.opacity(0.8))
                                    )
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(.vertical, 20)
                    Spacer()
                }
            }
        }
        .padding(.leading, 12)
        //.background(Color.indigo.opacity(0.6))
    }
}

//struct SearchAnotherView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchAnotherView()
//    }
//}
