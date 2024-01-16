//
//  SettingsViewModel.swift
//  SummerCountdownApp
//
//  Created by Kendall Bryant on 1/16/24.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    static let schoolEndingTimeKey = "schoolEndingTime"
    static let selectedSchoolKey = "selectedSchool"
    
    @Published var schoolEndingTime: Date {
        didSet {
            UserDefaults.standard.set(schoolEndingTime, forKey: Self.schoolEndingTimeKey)
        }
    }

    @Published var selectedSchool: String {
        didSet {
            UserDefaults.standard.set(selectedSchool, forKey: Self.selectedSchoolKey)
        }
    }
    
    func refreshUserDefaults() {
        self.schoolEndingTime = UserDefaults.standard.object(forKey: Self.schoolEndingTimeKey) as? Date ?? defaultSchoolEndingTime
        self.selectedSchool = UserDefaults.standard.string(forKey: Self.selectedSchoolKey) ?? defaultSelectedSchool
    }
    
    let schools = ["Fairfax County Public Schools (VA)", "Chesapeake Public Schools (VA)", "Pennsville School District (NJ)"]
    
    private let defaultSchoolEndingTime = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
    private let defaultSelectedSchool = "Fairfax County Public Schools (VA)"

    init() {
        // Load values from UserDefaults or use default values
        self.schoolEndingTime = UserDefaults.standard.object(forKey: Self.schoolEndingTimeKey) as? Date ?? defaultSchoolEndingTime
        self.selectedSchool = UserDefaults.standard.string(forKey: Self.selectedSchoolKey) ?? defaultSelectedSchool
    }
}
