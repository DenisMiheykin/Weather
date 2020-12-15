import Foundation

class WeatherHourly: Decodable {
    var date: TimeInterval? = nil
    var temp: Int? = nil
    var image: String? = nil
}
