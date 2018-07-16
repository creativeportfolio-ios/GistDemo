
import Foundation
import UIKit

extension String {
    var getCommentTime : String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let commentedTime: Date = dateFormatter.date(from: self)!
        
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.minute, .hour, .day]
        let now = Date()
        let (earliest, latest) = (now <= commentedTime as Date) ? (now, commentedTime as Date) : (commentedTime as Date, now)
        let dateComponents = calendar.dateComponents(components, from: earliest, to: latest)
        
        let days = dateComponents.day!
        let hours = dateComponents.hour!
        let min = dateComponents.minute!
        
        if (days > 0) {
            if (days > 60) {
                return "Few months ago"
            }
            if (days > 14) {
                return "Few weeks ago"
            }
            else {
                return "\(days) days ago"
            }
        }
        else if (hours > 1) {
            return "\(hours) hours ago"
        }
        else if (hours == 1) {
            return "\(hours) hour ago"
        }
        else if (min > 1) {
            return "\(min) mins ago"
        }
        else if (min == 1) {
            return "\(min) min ago"
        }
        else {
            return "Few seconds ago"
        }
    }
}

extension Date {
    func getCurrentDateString() -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return dateFormatter.string(from: self)
    }
}
