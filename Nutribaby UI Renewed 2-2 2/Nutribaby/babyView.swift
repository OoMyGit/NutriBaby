//
//  babyView.swift
//  Nutribaby
//
//  Created by Juan Sebastian on 21/11/24.
//
import SwiftUI

struct babyView: View {
    @AppStorage("babyWeight") private var savedWeight: String = ""
    @AppStorage("babyAge") private var savedAge: String = ""
    
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var calorieNeeds: Double = 0
    @State private var proteinNeeds: Double = 0
    @State private var carbohydrateNeeds: Double = 0
    @State private var fatNeeds: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Baby Nutrition Tracker")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter Baby's Information:")
                        .font(.headline)

                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Age (months)", text: $age)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding([.leading, .trailing])

                Divider()
                    .padding(.vertical, 10)

                Button(action: {
                    calculateNutritionNeeds()
                    saveInputToStorage()
                }) {
                    Text("Calculate Nutrition Needs")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing])

                if calorieNeeds > 0 {
                    NutritionOutputView(
                        calorieNeeds: calorieNeeds,
                        proteinNeeds: proteinNeeds,
                        carbohydrateNeeds: carbohydrateNeeds,
                        fatNeeds: fatNeeds
                    )
                    .padding([.leading, .trailing])
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Baby Nutrition", displayMode: .inline)
        .onAppear {
            // Populate fields with saved values if any exist
            self.weight = savedWeight
            self.age = savedAge
        }
    }

    func calculateNutritionNeeds() {
        guard let weightVal = Double(weight), weightVal > 0,
              let ageVal = Int(age), ageVal > 0 else {
            // Show an alert or error message
            return
        }

        // Adjust nutrition needs based on baby's age
        var caloriesPerKg: Double = 0
        var proteinPerKg: Double = 0
        var fatPercentage: Double = 0.35 // Default fat percentage
        let proteinCalPerGram = 4.0
        let fatCalPerGram = 9.0
        let carbCalPerGram = 4.0

        if ageVal <= 6 {
            caloriesPerKg = 90.0 // Average kcal/kg/day
            proteinPerKg = 1.5
            fatPercentage = 0.40
        } else if ageVal <= 12 {
            caloriesPerKg = 85.0
            proteinPerKg = 1.2
            fatPercentage = 0.35
        } else if ageVal <= 36 { // 1-3 years
            caloriesPerKg = 80.0
            proteinPerKg = 1.05
            fatPercentage = 0.30
        }

        // Calculate calorie and macronutrient needs
        calorieNeeds = weightVal * caloriesPerKg
        proteinNeeds = weightVal * proteinPerKg
        fatNeeds = (calorieNeeds * fatPercentage) / fatCalPerGram
        let remainingCalories = calorieNeeds - (proteinNeeds * proteinCalPerGram) - (fatNeeds * fatCalPerGram)
        carbohydrateNeeds = remainingCalories / carbCalPerGram
    }


    func saveInputToStorage() {
        savedWeight = weight
        savedAge = age
        // Save calculated results
        UserDefaults.standard.set(calorieNeeds, forKey: "calorieNeeds")
        UserDefaults.standard.set(proteinNeeds, forKey: "proteinNeeds")
        UserDefaults.standard.set(carbohydrateNeeds, forKey: "carbohydrateNeeds")
        UserDefaults.standard.set(fatNeeds, forKey: "fatNeeds")
    }
}


// Nutrition Output Section
struct NutritionOutputView: View {
    var calorieNeeds: Double
    var proteinNeeds: Double
    var carbohydrateNeeds: Double
    var fatNeeds: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Nutrition Analysis")
                .font(.headline)

            // Macronutrient Breakdown
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: percentageWidth(for: proteinPercentage()), height: 20)
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: percentageWidth(for: carbsPercentage()), height: 20)
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: percentageWidth(for: fatPercentage()), height: 20)
            }
            .cornerRadius(5)

            // Macronutrient Details
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Protein:")
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(proteinNeeds, specifier: "%.1f") g (\(Int(proteinPercentage()))%)")
                        .foregroundColor(.blue)
                }
                HStack {
                    Text("Carbohydrates:")
                        .foregroundColor(.orange)
                    Spacer()
                    Text("\(carbohydrateNeeds, specifier: "%.1f") g (\(Int(carbsPercentage()))%)")
                        .foregroundColor(.orange)
                }
                HStack {
                    Text("Fat:")
                        .foregroundColor(.purple)
                    Spacer()
                    Text("\(fatNeeds, specifier: "%.1f") g (\(Int(fatPercentage()))%)")
                        .foregroundColor(.purple)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)

            // Calories
            Text("Calories: \(calorieNeeds, specifier: "%.0f") kcal")
                .font(.subheadline)
        }
    }

    func proteinPercentage() -> Double {
        return (proteinNeeds / totalMacros()) * 100
    }

    func carbsPercentage() -> Double {
        return (carbohydrateNeeds / totalMacros()) * 100
    }

    func fatPercentage() -> Double {
        return (fatNeeds / totalMacros()) * 100
    }

    func totalMacros() -> Double {
        return proteinNeeds + carbohydrateNeeds + fatNeeds
    }

    func percentageWidth(for percentage: Double) -> CGFloat {
        let totalWidth: CGFloat = UIScreen.main.bounds.width - 40
        return totalWidth * CGFloat(percentage / 100)
    }
}

#Preview {
    babyView()
}

