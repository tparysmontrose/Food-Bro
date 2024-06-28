//
//  ResultViewModel.swift
//  Food Bro
//
//  Created by Tomasz Parys on 28/06/2024.
//

import Foundation
import Combine
import OpenAI

class ResultViewModel {
    
    private var resultText: String = ""
    var meal = PassthroughSubject<String, Never>()
    
    private let openAI = OpenAI(apiToken: AppConfig.apiKey)
    private let person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    private func activityDesc(activityLevel: ActivityLevel?) -> String {
        guard let activityLevel = activityLevel else {return ""}
        switch activityLevel {
        case .sedentary:
            return "The level of daily activity is at a very low level. The person does little physical activity or non activity."
        case .lightly:
            return "The level of daily activity is low. A person performs light sports activities 1-3 days a week."
        case .moderately:
            return "The level of daily activity is moderate. A person performs moderate sports activities 3-5 days a week."
        case .veryActive:
            return "The level of daily activity is height. A person performs hard sports activities 6-7 days a week."
        case .extraActive:
            return "The level of daily activity is very height. A person performs very hard sports activities twice per day."
        }
    }
    
    private func foodPreferencesDesc(preferences: String) -> String {
        guard preferences == " " else {
            return "Do not include special food preferences."
        }
        return "The answer must include food preferences: \(preferences)."
    }
    
    private func foodAllergiesDesc(allergies: String) -> String {
        guard allergies == " " else {
            return "The person is not allergic to any ingredient."
        }
        return "The person is allergic to: \(allergies)."
    }
    
    private func sportGoalsDesc(goals: String) -> String {
        guard goals == " " else {
            return ""
        }
        return "person has the following goals: \(goals)"
    }
    
    func getMealPlan() {
        let example = "General requirements: \n\n-Meal plan has to be generated for 1 day. \n\n- print out only the meal plan, meal preparation instructions and on At the very bottom a list of all products as a shopping list. Please add preparation time. Answer must take into food preferences and the following goals. \n\n- In the example below you can see how the final output should look like. \n\nExample of answer: \n\n 🍽️ Breakfast: scrambled eggs with spinach and avocado \n\n 🍌 Ingredients \n- 2 eggs\n- 1/2 avocado\n- 1 cup spinach\n\n 🫕 Preparation (⏰ preparation time: about 15 minutes) \n- heat the pan\n- scramble the eggs\n- add spinach to the pan\n- serve with avocado\n\n Nutrition\n- calories: 300\n- protein: 20g\n- carbs: 10g\n- fats: 15g\n\n=================================n\n.... and more\n\n=================================\n\n=================================\n\nTotal nutrition\n- calories: 1300\n- protein: 55g\n- carbs: 50g\n- fats: 35g\n\n=================================\n\n 📋 Groceries list 🛒\n- 6 eggs\n- 1 avocado\n- 2 cups spinach\n- 1 cup quinoa\n- 1 cup cherry tomatoes\n- 1 cucumber\n- 1 bell pepper"
        
        let prompt = "Please generate list of 5 meals for only one day and calculated calories for each meal. All meals together should have about \(person.dailyCalories) calories. \(activityDesc(activityLevel: person.activityLevel)) Meals must be balanced and healthy, include enough protein, carbs and fats. Person is a \(person.gender) have \(person.age) years old and \(person.height) cm height, \(person.weight) kg weight and with Body Mass Index \(person.bmi). \(foodPreferencesDesc(preferences: person.foodPreferences)) \(foodAllergiesDesc(allergies: person.foodAllergies)) \(sportGoalsDesc(goals: person.sportGoals)) Please at the end, write the total calories of all meals. \(example)"
        
        guard let msg = ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt) else {return}
        let chatQuary = ChatQuery(messages: [msg], model: .gpt3_5Turbo, temperature: 0.5)
        
        openAI.chatsStream(query: chatQuary) {[weak self] partialResult in
            guard let self = self else {return}
            switch partialResult {
            case .success(let result):
                let answers = result.choices
                for x in answers {
                    resultText += x.delta.content ?? ""
                }
                
                meal.send(resultText)
                
            case .failure(let error):
                print("error-> \(error)")
            }
        } completion: { error in
            print(error?.localizedDescription ?? "NO ERROR")
        }
    }
}
