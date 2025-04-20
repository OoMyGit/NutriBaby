import SwiftUI

struct mealsView: View {

    var mealName: String // Either "Breakfast", "Lunch", or "Dinner"

    // AppStorage keys to persist meals list per eating time
    @AppStorage("eatenMealsBreakfast") private var eatenMealsBreakfastData: String = ""
    @AppStorage("eatenMealsLunch") private var eatenMealsLunchData: String = ""
    @AppStorage("eatenMealsDinner") private var eatenMealsDinnerData: String = ""

    @State private var eatenMeals: [(String, Int, Int, Int, Int)] = []

    @State private var selectedCategory: String? = nil
    @State private var availableMeals: [String: [(String, Int, Int, Int, Int)]] = [
        "Protein": [("Chicken Breast", 200, 40, 0, 3),
                    ("Eggs", 150, 12, 1, 10),
                    ("Tofu", 100, 10, 2, 5)],
        "Carbs": [("Rice", 200, 4, 45, 0),
                  ("Pasta", 250, 5, 50, 1),
                  ("Bread", 150, 5, 30, 2)],
        "Fat": [("Avocado", 160, 2, 5, 15),
                ("Almonds", 100, 4, 2, 9),
                ("Cheese", 250, 7, 1, 20)]
    ]

    // AppStorage for storing total calories, protein, carbs, fat
    @AppStorage("totalCaloriesBreakfast") private var totalCaloriesBreakfast: Int = 0
    @AppStorage("totalProteinBreakfast") private var totalProteinBreakfast: Int = 0
    @AppStorage("totalCarbsBreakfast") private var totalCarbsBreakfast: Int = 0
    @AppStorage("totalFatBreakfast") private var totalFatBreakfast: Int = 0

    @AppStorage("totalCaloriesLunch") private var totalCaloriesLunch: Int = 0
    @AppStorage("totalProteinLunch") private var totalProteinLunch: Int = 0
    @AppStorage("totalCarbsLunch") private var totalCarbsLunch: Int = 0
    @AppStorage("totalFatLunch") private var totalFatLunch: Int = 0

    @AppStorage("totalCaloriesDinner") private var totalCaloriesDinner: Int = 0
    @AppStorage("totalProteinDinner") private var totalProteinDinner: Int = 0
    @AppStorage("totalCarbsDinner") private var totalCarbsDinner: Int = 0
    @AppStorage("totalFatDinner") private var totalFatDinner: Int = 0

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(mealName) - Meals Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Choose a Food Category:")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(["Protein", "Carbs", "Fat"], id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding()
                                    .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Divider()

                if let category = selectedCategory, let meals = availableMeals[category] {
                    Text("Available \(category) Foods:")
                        .font(.headline)
                        .padding(.horizontal)

                    List {
                        ForEach(meals, id: \.0) { meal in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(meal.0) // Meal name
                                        .font(.headline)
                                    Spacer()
                                    Text("\(meal.1) calories") // Calories
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Protein: \(meal.2)g")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("Carbs: \(meal.3)g")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("Fat: \(meal.4)g")
                                        .foregroundColor(.secondary)
                                }
                                .font(.subheadline)

                                Button(action: {
                                    addMealToList(meal)
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.green)
                                        Text("Add")
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.top, 5)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

                Divider()

                Text("Your Eaten Meals")
                    .font(.headline)
                    .padding(.horizontal)

                // Total Calories Calculation
                Text("Total Calories: \(totalCalories)")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal)

                List {
                    ForEach(eatenMeals, id: \.0) { meal in
                        HStack {
                            Text(meal.0) // Meal name
                            Spacer()
                            Text("\(meal.1) calories, \(meal.2)g protein, \(meal.3)g carbs, \(meal.4)g fat")
                                .foregroundColor(.secondary)

                            Button(action: {
                                removeMealFromList(meal)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }

                Spacer()
            }
            .onAppear(perform: loadMeals)
            .navigationBarTitle("\(mealName)", displayMode: .inline)
        }
    }

    // Function to remove meals from the list
    
    var totalCalories: Int {
            switch mealName {
            case "Breakfast": return totalCaloriesBreakfast
            case "Lunch": return totalCaloriesLunch
            case "Dinner": return totalCaloriesDinner
            default: return 0
            }
        }
    func updateTotalCalories() {
        // Calculate the new total calories by summing up the calories of all eaten meals
        let newTotalCalories = eatenMeals.reduce(0) { sum, meal in
            return sum + meal.1 // meal.1 is already the calorie value as an Int
        }

        // Update the total calories based on the current mealName
        switch mealName {
        case "Breakfast":
            totalCaloriesBreakfast = newTotalCalories
        case "Lunch":
            totalCaloriesLunch = newTotalCalories
        case "Dinner":
            totalCaloriesDinner = newTotalCalories
        default:
            break
        }
    }

    /// Dynamically save data per eating type
    

    /// Dynamically load data depending on the current eating type
    func loadMeals() {
        let sourceData: String
        switch mealName {
        case "Breakfast":
            sourceData = eatenMealsBreakfastData
        case "Lunch":
            sourceData = eatenMealsLunchData
        case "Dinner":
            sourceData = eatenMealsDinnerData
        default:
            sourceData = ""
        }

        eatenMeals = sourceData.split(separator: ";").compactMap { item -> (String, Int, Int, Int, Int)? in
            let parts = item.split(separator: ",")
            guard parts.count == 5 else { return nil }
            let name = String(parts[0])
            let calories = Int(parts[1]) ?? 0
            let protein = Int(parts[2]) ?? 0
            let carbs = Int(parts[3]) ?? 0
            let fat = Int(parts[4]) ?? 0
            return (name, calories, protein, carbs, fat)
        }
    }



    /// Add a meal to the eaten meals list and save
    func addMealToList(_ meal: (String, Int, Int, Int, Int)) {
        // Ensure that we don't add the same meal more than once
        if !eatenMeals.contains(where: { $0.0 == meal.0 }) {
            // Add the meal to the list
            eatenMeals.append(meal)

            // Add values to the totals based on the current mealName
            switch mealName {
            case "Breakfast":
                totalCaloriesBreakfast += meal.1
                totalProteinBreakfast += meal.2
                totalCarbsBreakfast += meal.3
                totalFatBreakfast += meal.4

            case "Lunch":
                totalCaloriesLunch += meal.1
                totalProteinLunch += meal.2
                totalCarbsLunch += meal.3
                totalFatLunch += meal.4

            case "Dinner":
                totalCaloriesDinner += meal.1
                totalProteinDinner += meal.2
                totalCarbsDinner += meal.3
                totalFatDinner += meal.4

            default:
                break
            }

            // Save the updated meal list to UserDefaults
            saveMeals()
        }
    }




        /// Remove a meal and recalculate total calories
    func removeMealFromList(_ meal: (String, Int, Int, Int, Int)) {
        if let index = eatenMeals.firstIndex(where: { $0 == meal }) {
            // Remove the meal from the list
            eatenMeals.remove(at: index)

            // Subtract values from the totals based on the current mealName
            switch mealName {
            case "Breakfast":
                totalCaloriesBreakfast -= meal.1
                totalProteinBreakfast -= meal.2
                totalCarbsBreakfast -= meal.3
                totalFatBreakfast -= meal.4

                // Ensure the values don't go below zero
                totalCaloriesBreakfast = max(0, totalCaloriesBreakfast)
                totalProteinBreakfast = max(0, totalProteinBreakfast)
                totalCarbsBreakfast = max(0, totalCarbsBreakfast)
                totalFatBreakfast = max(0, totalFatBreakfast)

            case "Lunch":
                totalCaloriesLunch -= meal.1
                totalProteinLunch -= meal.2
                totalCarbsLunch -= meal.3
                totalFatLunch -= meal.4

                totalCaloriesLunch = max(0, totalCaloriesLunch)
                totalProteinLunch = max(0, totalProteinLunch)
                totalCarbsLunch = max(0, totalCarbsLunch)
                totalFatLunch = max(0, totalFatLunch)

            case "Dinner":
                totalCaloriesDinner -= meal.1
                totalProteinDinner -= meal.2
                totalCarbsDinner -= meal.3
                totalFatDinner -= meal.4

                totalCaloriesDinner = max(0, totalCaloriesDinner)
                totalProteinDinner = max(0, totalProteinDinner)
                totalCarbsDinner = max(0, totalCarbsDinner)
                totalFatDinner = max(0, totalFatDinner)

            default:
                break
            }

            // Save the updated meal list to UserDefaults
            saveMeals()
        }
    }


        /// Save meals to persistent storage
        func saveMeals() {
            let stringToSave = eatenMeals.map { "\($0.0),\($0.1),\($0.2),\($0.3),\($0.4)" }.joined(separator: ";")
            switch mealName {
            case "Breakfast": eatenMealsBreakfastData = stringToSave
            case "Lunch": eatenMealsLunchData = stringToSave
            case "Dinner": eatenMealsDinnerData = stringToSave
            default: break
            }
        }
    }


#Preview {
    mealsView(mealName: "Lunch")
}
