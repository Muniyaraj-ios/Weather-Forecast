//
//  MainView.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var weatherVM: WeatherServiceVM = .init()
    @State private var bgColor: Color = .blue
    var body: some View {
        NavigationStack {
            ZStack {
                bgColor.opacity(0.2).ignoresSafeArea()
                if !weatherVM.isLocLoading{
                    VStack {
                        ProgressView()
                            .frame(width: 40, height: 40)
                        Text("Getting Location ")
                            .customText(fontSize: 18,fontWeight: .medium)
                    }
                }else{
                    if weatherVM.isLocDeny{
                        Text("Allow Location Permission to get your weather")
                            .customText(fontSize: 18,fontWeight: .medium)
                    }else if !weatherVM.weatherReqData.isLoading,let curWeather = weatherVM.weatherReqData.weatherData{
                        VStack {
                            HomeHeadView(cityNameCountry: "\(curWeather.name),\(curWeather.sys.country)", weatherServiceVM: weatherVM)
                                .padding(.top, 8)
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    VStack {
                                        HomePerceView(weatherData: curWeather)
                                        HomeSubView(mainWeather: curWeather.main)
                                            .frame(maxWidth: .infinity)
                                            .padding(12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(.secondary)
                                            }
                                            .padding([.leading,.trailing],15)
                                        HomeSplitView(weatherData: curWeather)
                                            .frame(maxWidth: .infinity)
                                            .padding(12)
                                            .background {
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(.secondary)
                                            }
                                            .padding(.all,15)
                                    }
                                    
                                    Section {
                                        ForEach(Array(weatherVM.forecastReqData.listData.sorted(by: { $0.key < $1.key })), id: \.key) { key,value in
                                            Section {
                                                //ForecastRowView(timeList: value)
                                                ForecastScrollView(timeList: value)
                                                    .padding(15)
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .fill(Color.cyan.opacity(0.3))
                                                    }.padding([.leading,.trailing],15)
                                            } header: {
                                                HStack {
                                                    Text(key.formatDateString(currentForm: .dateMonYear, newForm: .dayDateWeek))
                                                        .customText(fontSize: 16,fontWeight: .semibold)
                                                        .padding(.leading, 16)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    } header: {
                                        HStack{
                                            /*if let firstKey = weatherVM.forecastReqData.listData.keys.first,
                                               let dictArrFirst = weatherVM.forecastReqData.listData[firstKey],
                                               let firstDay = dictArrFirst.first?.dt_txt,
                                               let lastKey = weatherVM.forecastReqData.listData.keys.last,
                                               let dictArrLast = weatherVM.forecastReqData.listData[lastKey],
                                               let lastDay = dictArrLast.last?.dt_txt{
                                                Text("5 days Forecast"+" (\(firstDay.formatDateString(currentForm: .baseFormat, newForm: .dayDate)) - \(lastDay.formatDateString(currentForm: .baseFormat, newForm: .dayDate)))")
                                                    .padding([.top,.bottom], 12)
                                                    .customText(fontSize: 18,fontWeight: .semibold)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(6)
                                                    .background(Color.whiteColor)
                                            }else{*/
                                                Text("5 days Forecast").padding([.top,.bottom], 12)
                                                    .customText(fontSize: 18,fontWeight: .semibold)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(6)
                                                Spacer()
                                            /*}*/
                                        }
                                        .background(Color.whiteColor)
                                    }
                                }
                            }

                        }
                    }else if let error = weatherVM.weatherReqData.isError{
                        Text(error.localizedDescription)
                            .customText(fontSize: 18,fontWeight: .regular).padding(.horizontal, 12)
                            .multilineTextAlignment(.center)
                    }else if weatherVM.isLocLoading{
                        VStack{
                            ProgressView()
                                .frame(width: 40, height: 40)
                            Text("processing...\nWeather based on your Location ")
                                .multilineTextAlignment(.center)
                                .customText(fontSize: 18,fontWeight: .regular).padding(.horizontal, 12)
                        }.padding(.vertical, 20)
                    }
                }
            }
            .onAppear {
                print("Home Page on Appear triggered")
                weatherVM.setupLocationManager()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
