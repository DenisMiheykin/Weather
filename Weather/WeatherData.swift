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
        
//        print(date)
        let nsDate = NSDate(timeIntervalSince1970: date) as Date
//        print(nsDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: nsDate)
    }
}
