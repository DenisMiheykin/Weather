import Foundation

class WeatherData: Decodable {
    var date: TimeInterval? = nil
    var temperature: Int? = nil
    var humidity: Int? = nil
    var speedWind: Int? = nil
    var clouds: Int? = nil
    var rain: Double? = nil
    var snow: Double? = nil
    var image: String? = nil
    
    static func getDay(from date: TimeInterval) -> String {
        return self.getFormatDate(from: date, dateFormat: "EEEE")
    }
    
    static func getHour(from date: TimeInterval) -> String {
        return self.getFormatDate(from: date, dateFormat: "HH")
    }
    
    private static func getFormatDate(from date: TimeInterval, dateFormat: String) -> String {
        let nsDate = NSDate(timeIntervalSince1970: date) as Date
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: nsDate)
    }
}
