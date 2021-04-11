import Foundation

class JsonParseManager {
    
    static let shared = JsonParseManager()
    private init(){}
    
    func jsonParse(_ data: Data) -> Weather {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return self.getWeather(from: dictionary)
            }
        } catch {
            print(error)
        }
        
        return Weather()
    }
    
    func getWeather(from dictionary: [String: Any]) -> Weather {
        
        let weather = Weather()
        weather.hourly = [WeatherHourly]()
        weather.data = [WeatherData]()
        
        if let timezone = dictionary["timezone"] as? String {
            weather.city = self.getCityFromString(timezone)
        }
        
        self.getHourly(weather, dictionary)
        self.getDaily(weather, dictionary)
        
        return weather
    }
    
    func getHourly(_ weather: Weather, _ dictionary: [String: Any]) {
        if let list = dictionary["hourly"] as? [[String: Any]] {
            for item in list {
                
                let weatherHourly = WeatherHourly()
                
                if let date = item["dt"] as? TimeInterval {
                    weatherHourly.date = date
                }
                
                if let temp = item["temp"] as? Double {
                    weatherHourly.temp = Int(round(temp))
                }
                
                if let weather = item["weather"] as? [Any],
                    let object = weather.first as? [String: Any],
                    let icon = object["icon"] as? String {
                    weatherHourly.image = icon
                }
                
                weather.hourly?.append(weatherHourly)
            }
        }
    }
    
    func getDaily(_ weather: Weather, _ dictionary: [String: Any]) {
        if let list = dictionary["daily"] as? [[String: Any]] {
            for item in list {
                
                let weatherData = WeatherData()
                
                if let date = item["dt"] as? TimeInterval {
                    weatherData.date = date
                }
                
                if let temp = item["temp"] as? [String: Any] {
                    if let day = temp["day"] as? Double {
                        weatherData.temperature = Int(round(day))
                    }
                }
                
                if let humidity = item["humidity"] as? Double {
                    weatherData.humidity = Int(round(humidity))
                }
                
                if let windSpeed = item["wind_speed"] as? Double {
                    weatherData.speedWind = Int(round(windSpeed))
                }
                
                if let weather = item["weather"] as? [Any],
                    let object = weather.first as? [String: Any],
                    let icon = object["icon"] as? String {
                    weatherData.image = icon
                }
                
                if let clouds = item["clouds"] as? Int {
                    weatherData.clouds = clouds
                }
                
                if let rain = item["rain"] as? Double {
                    weatherData.rain = rain
                }
                
                if let snow = item["snow"] as? Double {
                    weatherData.snow = snow
                }
                
                weather.data?.append(weatherData)
            }
        }
    }
    
    func getCoordinates(_ data: Data) -> (error: String?, latitude: Double, longitude: Double) {
        var result: (error: String?, latitude: Double, longitude: Double) = (nil, 0.0, 0.0)
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                guard let city = dictionary["city"] as? [String: Any] else {
                    if let message = dictionary["message"] as? String {
                        result.error = message
                    } else {
                        result.error = "Data not found."
                    }
                    return result
                }
                
                if let coord = city["coord"] as? [String: Any] {
                    if let latitude = coord["lat"] as? Double {
                        result.latitude = latitude
                    }
                    
                    if let longitude = coord["lon"] as? Double {
                        result.longitude = longitude
                    }
                }
                
                return result
            }
        } catch {
            print(error)
        }
        
        return result
    }
    
    func getCityFromString(_ value: String) -> String {
        guard let start = value.firstIndex(of: "/") else {
            return ""
        }
        
        let range = value.index(after: start)..<value.endIndex
        
        return String(value[range])
    }
}
