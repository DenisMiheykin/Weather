import Foundation

class Weather: Decodable {
    var city: String? = nil
    var data: [WeatherData]? = nil
}
