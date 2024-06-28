//
//  Person.swift
//  Food Bro
//
//  Created by Tomasz Parys on 27/06/2024.
//

import Foundation

struct Person {
    let age: Int
    let weight: Double
    let height: Double
    let bmi: Double
    let gender: Gender
    var foodPreferences: String
    var foodAllergies: String
    var sportGoals: String
    var activityLevel: ActivityLevel?
    var dailyCalories: Double
}

enum Gender: Int, CaseIterable  {
    case male = 0
    case female = 1
}
