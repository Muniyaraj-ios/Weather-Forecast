//
//  HomePerceView.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import SwiftUI

struct HomePerceView: View {
    var weatherData: WeatherResponse
    //@State private var downloadedImage: UIImage? = nil
    var body: some View {
        HStack {
            Spacer()
            ImageView(name: weatherData.weather.first?.icon ?? "")
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
            /*if let downloadedImage{
                Image(uiImage: downloadedImage)
                    .renderingMode(.original).resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    //.padding(30)
                    /*.background {
                        Circle()
                            .fill(.teal.opacity(0.8))
                            .shadow(color: Color.teal.opacity(0.8), radius: 4, x: 2, y: 2)
                        /*Image(systemName: "sun.min.fill")
                            .renderingMode(.original).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .padding(30)
                            .background {
                                Circle()
                                    .fill(.teal.opacity(0.8))
                                    .shadow(color: Color.teal.opacity(0.8), radius: 4, x: 2, y: 2)
                            }*/
                    }*/
            }else{
                Image(systemName: "cloud.sun.fill")
                    .renderingMode(.original).resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(30)
                    .background {
                        Circle()
                            .fill(.teal.opacity(0.8))
                            .shadow(color: Color.teal.opacity(0.8), radius: 4, x: 2, y: 2)
                    }.onAppear {
                        if let icon = weatherData.weather.first?.icon{
                            loadImageFromURL(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
                        }
                    }
            }*/
            VStack(alignment: .leading) {
                HStack {
                    Text("\(weatherData.main.temp.removeZerosFromEnd())\(UnitType.metric.deVal)")
                        .customText(fontSize: 35,fontWeight: .bold)
                    .padding(.bottom, 2)
                    Text(weatherData.weather.first?.description ?? "")
                }
                /*Text(weatherData.weather.first?.main ?? "")
                    .customText(fontSize: 20,fontWeight: .semibold)*/
            }
            Spacer()
        }
    }
    /*private func loadImageFromURL(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.downloadedImage = uiImage
                }
            }
        }.resume()
    }*/
}

//struct HomePerceView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePerceView(weatherData: [])
//    }
//}

private func getIconURL(iconName: String) -> URL? {
    let baseURL = "https://openweathermap.org/img/wn/50n@2x.png"
    let fileExtension = "@2x.png"
    let iconURLString = baseURL + iconName + fileExtension

    return URL(string: iconURLString)
}
//weather =     (
//            {
//        description = mist;
//        icon = 50n;
//        id = 701;
//        main = Mist;
//    }
//)
