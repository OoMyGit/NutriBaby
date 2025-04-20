import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
struct homeView: View {
    // State to track the week offset for navigation
    @State private var weekOffset: Int = 0
    // State to track the selected date, defaulting to the current day
    @State private var selectedDate: Day? = nil

    var body: some View {
        NavigationView { // Wrap the entire view in NavigationView
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar Header with Navigation
                    CalendarHeaderView(weekOffset: $weekOffset, selectedDate: $selectedDate)
                                            
                    // Nutrition Section
                    if let selectedDay = selectedDate {
                        Text("Nutrition for \(selectedDay.day), \(selectedDay.date)")
                            .font(.title2)
                            .padding()
                        
                        NutritionSectionView()
                    }
                    
                    Spacer()
                    
                    // Meals Section
                    MealsSectionView()
                    
                    Spacer()
                }
                .padding(.top, 10)
                .navigationTitle("Home") // Navigation Bar Title
                .navigationBarTitleDisplayMode(.inline) // Center the title
                
                
                .toolbar(.visible, for: .tabBar)
                .onAppear {
                    // Set the selected date to today when the view appears
                    let days = Calendar.current.generateWeekDays(weekOffset: weekOffset)
                    selectedDate = days.first(where: { $0.isToday })
                }
            }
        }
    }
}

struct CalendarHeaderView: View {
    @Binding var weekOffset: Int
    @Binding var selectedDate: Day?

    var body: some View {
        let days = Calendar.current.generateWeekDays(weekOffset: weekOffset)

        HStack {
            // Navigate to the previous week
            Button(action: {
                weekOffset -= 1
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .font(.title2)
            }

            Spacer()

            // Days in the week
            LazyHStack(spacing: 10) {
                ForEach(days, id: \.id) { day in
                    CalendarDayView(day: day, isSelected: day == selectedDate, onTap: {
                        selectedDate = day
                    })
                }
            }

            Spacer()

            // Navigate to the next week
            Button(action: {
                weekOffset += 1
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding() // Add padding inside the header
        .background(
            Color(hex: "#94d2df") // Background color
                .cornerRadius(10) // Rounded corners
        )
        .padding(.horizontal) // Same horizontal padding as MealView
    }
}

struct CalendarDayView: View {
    let day: Day
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack {
            Button(action: onTap) {
                VStack(spacing: 5) {
                    // Day Name
                    Text(day.day)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)

                    // Circle for the Date
                    Circle()
                        .frame(width: 35, height: 35)
                        .foregroundColor(day.isToday ? Color(hex: "#4A90E2") : .clear) // Blueish background for today's date
                        .overlay(
                            Text("\(day.date)")
                                .foregroundColor(day.isToday ? .white : .primary) // White text for today's date
                        )
                }
            }
            .buttonStyle(PlainButtonStyle()) // Removes default button style
        }
    }
}



struct NutritionSectionView: View {
    @AppStorage("calorieNeeds") private var calorieNeeds: Double = 0
    @AppStorage("proteinNeeds") private var proteinNeeds: Double = 0
    @AppStorage("carbohydrateNeeds") private var carbohydrateNeeds: Double = 0
    @AppStorage("fatNeeds") private var fatNeeds: Double = 0

    
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
        let totalCalories = totalCaloriesBreakfast + totalCaloriesLunch + totalCaloriesDinner
                let totalProtein = totalProteinBreakfast + totalProteinLunch + totalProteinDinner
                let totalCarbs = totalCarbsBreakfast + totalCarbsLunch + totalCarbsDinner
                let totalFat = totalFatBreakfast + totalFatLunch + totalFatDinner
        VStack {
            HStack(spacing: 20) {
                ZStack {
                    CircularProgressBar(progress: CGFloat(totalFat), maxProgress: CGFloat(fatNeeds), color: .yellow, lineWidth: 15, offset: 50)
                                        CircularProgressBar(progress: CGFloat(totalCarbs), maxProgress: CGFloat(carbohydrateNeeds), color: .blue, lineWidth: 15, offset: 35)
                                        CircularProgressBar(progress: CGFloat(totalProtein), maxProgress: CGFloat(proteinNeeds), color: .green, lineWidth: 15, offset: 20)
                                        CircularProgressBar(progress: CGFloat(totalCalories), maxProgress: CGFloat(calorieNeeds), color: .red, lineWidth: 15, offset: 5)
                }
                .frame(width: 150, height: 150)
                                
                VStack(alignment: .leading, spacing: 10) {
                    NutrientBar(label: "Calories", color: .red, value: "\(totalCalories) / \(Int(calorieNeeds))")
                                        NutrientBar(label: "Protein", color: .green, value: "\(totalProtein) / \(String(format: "%.1f", proteinNeeds))")
                                        NutrientBar(label: "Carbs", color: .blue, value: "\(totalCarbs) / \(String(format: "%.1f", carbohydrateNeeds))")
                                        NutrientBar(label: "Fat", color: .yellow, value: "\(totalFat) / \(String(format: "%.1f", fatNeeds))")
                }
                .font(.caption)
            }
            .padding()
        }
        .background(Color(hex: "#eceae4"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct MealsSectionView: View {
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
        VStack(spacing: 20) {
            MealView(
                mealName: "Breakfast",
                goalCalories: 440,
                totalCalories: totalCaloriesBreakfast,
                totalProtein: totalProteinBreakfast,
                totalCarbs: totalCarbsBreakfast,
                totalFat: totalFatBreakfast
            )
            MealView(
                mealName: "Lunch",
                goalCalories: 770,
                totalCalories: totalCaloriesLunch,
                totalProtein: totalProteinLunch,
                totalCarbs: totalCarbsLunch,
                totalFat: totalFatLunch
            )
            MealView(
                mealName: "Dinner",
                goalCalories: 1000,
                totalCalories: totalCaloriesDinner,
                totalProtein: totalProteinDinner,
                totalCarbs: totalCarbsDinner,
                totalFat: totalFatDinner
            )
        }
        .padding(.horizontal)
    }
}





// Helper Structs
struct NutrientBar: View {
    var label: String
    var color: Color
    var value: String

    var body: some View {
        HStack {
            Circle().frame(width: 10, height: 10).foregroundColor(color)
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

// Circular Progress Component
struct CircularProgressBar: View {
    @State private var currentProgress: CGFloat = 0 // State variable to control progress
    
    var progress: CGFloat
    var maxProgress: CGFloat
    var color: Color
    var lineWidth: CGFloat
    var offset: CGFloat = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: currentProgress / maxProgress) // Show the part of the circle based on current progress
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(-90)) // Rotate to start at the top
            .padding(offset) // Adjust padding for nested circles
            .animation(.easeInOut(duration: 1.0), value: currentProgress) // Smooth animation when progress changes
            .onAppear {
                // Animate progress when the view appears
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentProgress = progress
                }
            }
            .onChange(of: progress) { newProgress in
                // Animate progress change
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentProgress = newProgress
                }
            }
    }
}

// Extension for Calendar Date Generation
extension Calendar {
    func generateWeekDays(weekOffset: Int = 0) -> [Day] {
        let today = Date()
        let startOfWeek = self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let weekStart = self.date(byAdding: .weekOfYear, value: weekOffset, to: startOfWeek)!
        
        var days = [Day]()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Day format (e.g., Mon, Tue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // Date format (e.g., 18, 19)
        
        for offset in 0..<7 {
            if let date = self.date(byAdding: .day, value: offset, to: weekStart) {
                let day = formatter.string(from: date)
                let dayDate = Int(dateFormatter.string(from: date)) ?? 0
                let isToday = self.isDate(date, inSameDayAs: today)
                days.append(Day(day: day, date: dayDate, isToday: isToday))
            }
        }
        return days
    }
}

// Day Struct
struct Day: Identifiable, Equatable {
    let id = UUID()
    let day: String
    let date: Int
    let isToday: Bool
    
    // Equatable conformance
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MealView: View {
    var mealName: String
    var goalCalories: Int
    var totalCalories: Int
    var totalProtein: Int
    var totalCarbs: Int
    var totalFat: Int

    var body: some View {
        NavigationLink(destination: mealsView(mealName: mealName)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: getMealIcon(for: mealName))
                        .foregroundColor(getMealColor(for: mealName))
                    Text(mealName)
                        .font(.headline)
                    Spacer()
                    Text("Goal: \(goalCalories) cal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("Consumed: \(totalCalories) cal")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                HStack {
                    Text("Protein: \(totalProtein)g")
                    Spacer()
                    Text("Carbs: \(totalCarbs)g")
                    Spacer()
                    Text("Fat: \(totalFat)g")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(hex: "#ccf0f7"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
        }
    }
}

    // Helper Methods
    func getMealIcon(for meal: String) -> String {
        switch meal {
        case "Breakfast":
            return "sunrise.fill"
        case "Lunch":
            return "sun.max.fill"
        case "Dinner":
            return "moon.fill"
        default:
            return "fork.knife"
        }
    }

    func getMealColor(for meal: String) -> Color {
        switch meal {
        case "Breakfast":
            return .orange
        case "Lunch":
            return .blue
        case "Dinner":
            return .purple
        default:
            return .green
        }
    }


struct NutrientStat: View {
    var label: String
    var value: Int

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}


// Preview
struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView()
    }
}
