import Foundation
import SwiftUI

func randomFakeFirstName() -> String {
    let firstNameList = ["Henry", "William", "Geoffrey", "Jim", "Yvonne", "Jamie", "Leticia", "Priscilla", "Sidney", "Nancy", "Edmund", "Bill", "Megan"]
    return firstNameList.randomElement()!
}

func randomLocation() -> String {
    let locations = [
        "LA, United States",
        "NYC, United States",
        "Chicago, United States",
        "San Francisco, United States",
        "Miami, United States",
        "Seattle, United States",
        "Austin, United States",
        "Las Vegas, United States",
        "Orlando, United States",
        "Denver, United States",
        "Boston, United States",
        "Philadelphia, United States",
        "San Diego, United States",
        "Nashville, United States",
        "Dallas, United States",
        "Portland, United States",
        "Atlanta, United States",
        "Phoenix, United States",
        "Detroit, United States",
        "New Orleans, United States",
    ]

    return locations.randomElement()!
}

func randomDate() -> Date {
    let day = arc4random_uniform(30) + 1
    let month = arc4random_uniform(12) + 1
    let year = 2023
    let hour = arc4random_uniform(24)
    let minute = arc4random_uniform(60)

    var dateComponents = DateComponents()
    dateComponents.year = Int(year)
    dateComponents.month = Int(month)
    dateComponents.day = Int(day)
    dateComponents.hour = Int(hour)
    dateComponents.minute = Int(minute)

    let userCalendar = Calendar.current
    return userCalendar.date(from: dateComponents)!
}

func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> Color {
    let randomColorGenerator = { () -> CGFloat in
        CGFloat(arc4random() % 256) / 256
    }

    var red: CGFloat = randomColorGenerator()
    var green: CGFloat = randomColorGenerator()
    var blue: CGFloat = randomColorGenerator()

    if let mixColor = mixColor {
        var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0
        mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)

        red = (red + mixRed) / 2
        green = (green + mixGreen) / 2
        blue = (blue + mixBlue) / 2
    }

    return Color(uiColor: UIColor(red: red, green: green, blue: blue, alpha: 1))
}
