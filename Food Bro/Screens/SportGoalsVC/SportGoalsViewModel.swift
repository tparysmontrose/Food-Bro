//
//  SportGoalsViewModel.swift
//  Food Bro
//
//  Created by Tomasz Parys on 28/06/2024.
//

import Foundation

class SportGoalsViewModel {
    
    func calculateDailyCalories(person: Person) -> Double? {
        guard let activityLevel = person.activityLevel else {return nil}
        
        var bmr: Double = 0
        var calories: Double = 0
        let weight = 10.0 * person.weight
        let height = 6.25 * person.height
        let age = 5.0 * Double(person.age)
        
        switch person.gender {
        case .male:
            bmr = weight + height - age + 5.0
            break
        case .female:
            bmr = weight + height - age - 161.0
            break
        }
        
        switch activityLevel {
        case .sedentary:
            calories = bmr * 1.2
        case .lightly:
            calories = bmr * 1.375
        case .moderately:
            calories = bmr * 1.55
        case .veryActive:
            calories = bmr * 1.725
        case .extraActive:
            calories = bmr * 1.9
        }
        return calories
    }
}
