import Foundation

class Weather: Decodable {
    var city: String? = nil
    var hourly: [WeatherHourly]? = nil
    var data: [WeatherData]? = nil
}
