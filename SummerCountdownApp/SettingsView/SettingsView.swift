//
//  SettingsView.swift
//  SummerCountdownApp
//
//  Created by Kendall Bryant on 1/16/24.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    static let selectedSchoolKey = "selectedSchool"
    static let schoolEndingTimeKey = "schoolEndingTime"

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            Section(header: Text("School information")) {
                Picker("School System", selection: $viewModel.selectedSchool) {
                    ForEach(viewModel.schools, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: viewModel.selectedSchool) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: Self.selectedSchoolKey)
                }
            }
            
            
            Section() {
                DatePicker("What time does your school day end?", selection: $viewModel.schoolEndingTime, displayedComponents: .hourAndMinute)
                    .onChange(of: viewModel.schoolEndingTime) { oldValue, newValue in
                        UserDefaults.standard.set(newValue, forKey: Self.schoolEndingTimeKey)
                    }
            }
            
            Section(header: Text("summer countdown info"), footer: Text("Summer Countdown is based on January 2024 data and is not intended to be a replacement for the official school calendar. If your school calendar has changed since January 2024, please use the website linked above to submit an update request")) {
                Link("Website", destination: URL(string: "https://www.summercountdownapp.com/")!)
                    .frame(maxWidth: .infinity, alignment: .center)
                Link("Privacy policy", destination: URL(string: "https://www.summercountdownapp.com/privacypolicy/")!)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Settings")
        }
    }



struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}

