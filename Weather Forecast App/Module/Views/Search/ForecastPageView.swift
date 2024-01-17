//
//  ForecastPageView.swift
//  Weather Forecast App
//
//  Created by Apple on 16/01/24.
//

import SwiftUI

struct ForecastPageView: View {
    
    @ObservedObject var forecastServiceVM: ForecastWeatherServiceVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView{
                        Section {
                            SearchSubCellView(forecastServiceVM: forecastServiceVM)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.whiteColor).shadow(color: Color.blackColor.opacity(0.3), radius: 6, x: 0.0, y: 2)
                                }.padding(.horizontal, 15)
                                .padding(.vertical, 8)
                        } header: {
                            SearchAnotherView(forecastServiceVM: forecastServiceVM)//.padding(.horizontal, -10)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.whiteColor).shadow(color: Color.blackColor.opacity(0.3), radius: 6, x: 0.0, y: 2)
                                }.padding(.horizontal, 15)
                                .padding(.vertical, 8)
                        }
                        Section {
                            ForEach(Array(forecastServiceVM.forecastReqData.listData.sorted(by: { $0.key < $1.key })), id: \.key) { key,value in
                                Section {
                                    ForecastScrollView(timeList: value)
                                        .padding(15)
                                        .background {
                                            RoundedRectangle(cornerRadius: 15)
                                            // Diifernt between the color
                                                //.fill(Color.whiteColor).shadow(color: Color.blackColor.opacity(0.3), radius: 6, x: 0.0, y: 2)
                                                .fill(Color.orange.opacity(0.3)).shadow(color: Color.blackColor.opacity(0.3), radius: 6, x: 0.0, y: 2)
                                        }.padding([.leading,.trailing],15)
                                } header: {
                                    HStack {
                                        Text(key.formatDateString(currentForm: .dateMonYear, newForm: .dayDateWeek))
                                            .customText(fontSize: 16,fontWeight: .semibold)
                                        Spacer()
                                    }.padding(.horizontal, 16).padding(.top, 6)
                                }
                            }.padding(.horizontal, -5)
                                .listStyle(SidebarListStyle())
                                .listStyle(.plain)
                        } header: {
                            HStack {
                                Text("5 days Forecast").padding([.top,.bottom], 12)
                                    .customText(fontSize: 18,fontWeight: .medium).padding([.leading,.trailing],6)
                                Spacer()
                            }.background(Color.whiteColor)
                        }
                    }
                }
            }
        }
    }
}

//struct ForecastPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForecastPageView()
//    }
//}
