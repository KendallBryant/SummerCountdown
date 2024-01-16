//
//  ContentView.swift
//  SummerCountdownApp
//
//  Created by Kendall Bryant on 1/16/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var contentViewModel = ContentViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var datesViewModel = DatesViewModel(viewModel: SettingsViewModel())
    
    @State private var showAlert = false
    
    private func shouldShowSummer() -> Bool {
        return datesViewModel.foundValue == "summer"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("lavender")
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    // this navlink just holds the little gear
                    NavigationLink(destination: SettingsView(viewModel: settingsViewModel)) {
                        Image(systemName: "gearshape.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 300, bottom: 30, trailing: -20))
                    }
                    // this decides if we see the countdown or summer message
                    if shouldShowSummer() {
                        SummerView(datesViewModel: datesViewModel, contentViewModel: contentViewModel)
                    } else {
                        CountdownView(datesViewModel: datesViewModel, contentViewModel: contentViewModel)
                    }
                }
                .onAppear {
                    datesViewModel.updateFoundValue()
                    // Check if monthly "this isn't an official calendar alert should be shown
                    if contentViewModel.shouldShowMonthlyAlert() {
                        showAlert = true
                    }
                    datesViewModel.scheduleDailyRefresh(at: settingsViewModel.schoolEndingTime)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Reminder"), message: Text("Please always check your\nschool system's calendar for the official school dates."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



