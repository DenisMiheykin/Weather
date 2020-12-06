import Foundation

class JsonParseManager {
    
    static let shared = JsonParseManager()
    private init(){}
    
    func JsonParse(_ data: Data) -> Weather {
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
        weather.data = [WeatherData]()
        
        if let timezone = dictionary["timezone"] as? String {
            weather.city = timezone
        }
        
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
        
        return weather
    }
    
    func getCoordinates(_ data: Data) -> (Double, Double) {
        var coordinates = (0.0, 0.0)
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                if let city = dictionary["city"] as? [String: Any],
                    let coord = city["coord"] as? [String: Any] {
                    if let lat = coord["lat"] as? Double {
                        coordinates.0 = lat
                    }
                    
                    if let lon = coord["lon"] as? Double {
                        coordinates.1 = lon
                    }
                }
                
                return coordinates
            }
        } catch {
            print(error)
        }
        
        return coordinates
    }
    
    private func getWeather_old(from dictionary: [String: Any]) -> Weather {
        
        let weather = Weather()
        weather.data = [WeatherData]()
        
        if let city = dictionary["city"] as? [String: Any],
            let name = city["name"] as? String {
            weather.city = name
        }
        
        if let list = dictionary["list"] as? [[String: Any]] {
            for item in list {
                
                let weatherData = WeatherData()
                
                if let date = item["dt"] as? TimeInterval {
                    weatherData.date = date
                }
                
                if let main = item["main"] as? [String: Any] {
                    if let temperature = main["temp"] as? Double {
                        weatherData.temperature = Int(round(temperature))
                    }
                    if let humidity = main["humidity"] as? Double {
                        weatherData.humidity = Int(round(humidity))
                    }
                }
                
                if let wind = item["wind"] as? [String: Any] {
                    if let speed = wind["speed"] as? Double {
                        weatherData.speedWind = Int(round(speed))
                    }
                }
                
                if let clouds = item["clouds"] as? [String: Any] {
                    if let all = clouds["all"] as? Int {
                        weatherData.clouds = all
                    }
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
        
        return weather
    }
}
