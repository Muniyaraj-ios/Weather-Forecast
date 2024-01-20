//
//  SearchLocationView.swift
//  Weather Forecast App
//
//  Created by Apple on 15/01/24.
//

import SwiftUI

struct SearchLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchField: String = ""
    @StateObject var forecastServiceVM: ForecastWeatherServiceVM = .init()
    @State private var previousSearch: String = ""
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    HStack{
                        Image("pinIcon")
                            .renderingMode(.template).resizable()
                            .foregroundColor(.blackColor.opacity(0.6))
                            .frame(width: 28, height: 28)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 13)
                        HStack {
                            TextField("Search City or Zipcode", text: $searchField)
                                .customText(fontSize: 16)
                                .tint(.blackColor)
                            .padding([.top,.bottom,.trailing], 16)
                            if !searchField.isEmpty{
                                Button(action: {
                                    withAnimation {
                                        self.searchField = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 15)
                            }
                        }.disabled(forecastServiceVM.forecastReqData.isLoading)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.whiteColor.opacity(0.9))
                    ).padding(10).padding(.leading, 3)
                    Button {
                        self.previousSearch = searchField
                        forecastServiceVM.getWeatherData(city: searchField)
                        forecastServiceVM.getForecastFiveDayData(city: searchField)
                        hideKeyboard()
                        searchField = ""
                    } label: {
                        HStack{
                            Image(systemName: "location.magnifyingglass")
                                .resizable()
                                .tint(.blackColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22, alignment: .trailing)
                                .padding(15)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.whiteColor.opacity(0.9))
                        ).padding(.trailing, 10)
                    }.disabled(searchField.trimmingCharacters(in: .whitespaces).isEmpty || forecastServiceVM.forecastReqData.isLoading)

                }.padding(.vertical,15).background(Color.teal)
                if forecastServiceVM.forecastReqData.isLoading{
                        Spacer()
                        VStack{
                            ProgressView()
                                .frame(width: 40, height: 40)
                            Text("processing...\nWeather results based on your search '\(previousSearch)'")
                                .customText(fontSize: 17,fontWeight: .regular)
                                .padding(.horizontal, 14)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                }else if let error = forecastServiceVM.forecastReqData.isError{
                    Spacer()
                    VStack{
                        Text(error.localizedDescription)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 14)
                            .customText(fontSize: 18,fontWeight: .regular)
                    }
                    Spacer()
                }else if let _ = forecastServiceVM.forecastReqData.weatherData{
                    ForecastPageView(forecastServiceVM: forecastServiceVM)
                }
                Spacer()
            }.dismissKeyboardOnTap()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrowshape.backward.fill")
                            .renderingMode(.template).resizable()
                            .tint(.blackColor.opacity(0.8))
                    })
                )
        }
            
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct SearchLocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchLocationView()
//    }
//}
