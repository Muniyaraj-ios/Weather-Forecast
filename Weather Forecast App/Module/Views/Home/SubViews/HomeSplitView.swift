//
//  HomeSplitView.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct HomeSplitView: View {
    let column: [GridItem] = [
        GridItem(.flexible(), spacing: 15, alignment: .center),
        GridItem(.flexible(), spacing: 15, alignment: .center)
    ]
    @State private var homeList: [CurrentWeatherSplit] = .init()
    var weatherData: WeatherResponse
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: column, alignment: .center, spacing: 30, pinnedViews: []) {
                    ForEach(homeList, id: \.id) { item in
                        HStack {
                            VStack{
                                if item.image.isEmpty{
                                    Image("Pressure".lowercased())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                }else{
                                    Image(systemName: item.image)
                                        .resizable()
                                        .foregroundColor(.blackO)
                                        .tint(.blackColor)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                }
                                Text(item.name)
                                    .customText(color: .blackO,fontSize: 16,fontWeight: .medium)
                                Text(item.deg.description)
                                    .padding(.top, 3)
                                    .customText(color: .blackO,fontSize: 15,fontWeight: .bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background {
                                LinearGradient(colors: [.mint.opacity(0.8),.white], startPoint: .bottomTrailing, endPoint: .topLeading)
                                    .edgesIgnoringSafeArea(.all)
                                    .cornerRadius(20)
                                    .shadow(color: Color.mint, radius: 4, x: 2, y: 2)
                            }
                        }
                    }
                }
                .padding(12)
                .onAppear {
                    homeList.removeAll()
                    let otherList: [CurrentWeatherSplit] = [
                        .init(name: "Humidity", desc: "", deg: weatherData.main.humidity.description+" %", image: "humidity"),
                        .init(name: "Wind Speed", desc: "", deg: weatherData.wind.speed.description+" km/h", image: "wind"),
                        .init(name: "Visibility", desc: "", deg: weatherData.visibility.meterToKiloMeter().description+" km", image: "eye.slash.fill"),
                        .init(name: "Air Pressure", desc: "", deg: weatherData.main.pressure.description+" hPa", image: "")
                    ]
                    homeList.append(contentsOf: otherList)
            }
                Spacer()
            }
        }
    }
}
struct CurrentWeatherSplit: Hashable{
    var id = UUID()
    var name: String
    var desc: String
    var deg: String
    var image: String
}

//struct HomeSplitView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSplitView()
//    }
//}
