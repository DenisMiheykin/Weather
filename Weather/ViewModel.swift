import UIKit
import CoreLocation

class ViewModel {
    
    // MARK: - let
    let city: Bindable<String> = Bindable("")
    let weather: Bindable<Weather> = Bindable(Weather())
    
    let locationManager = CLLocationManager()
    
    // MARK: - var
    var reloadTableView: (() -> ())?
    
    // MARK: - flow funcs
    func getWeather() {
        self.sendRequest { (weather) in
            self.showWeather(weather)
        }
    }
    
    func sendRequest(byСoordinates latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.sendRequest(byСoordinates: latitude, longitude: longitude) { (weather) in
            self.showWeather(weather)
        }
    }
    
    private func sendRequest(completion: @escaping (Weather) -> ()) {
        guard let correctCity = city.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
            correctCity.isEmpty else {
            return
        }
        
        let baseURL = "http://api.openweathermap.org"
        let endPoint = "/data/2.5/forecast?q=\(correctCity)&cnt=1&appid=16adcfd37a1c8c0311e556b7f1077f8d"
        
        guard let url = URL(string: "\(baseURL)\(endPoint)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                let coor = JsonParseManager.shared.getCoordinates(data)
                self.sendRequest(byСoordinates: coor.0, longitude: coor.1, completion: completion)
            }
        }
        task.resume()
    }
    
    private func sendRequest(byСoordinates latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Weather) -> ()) {
        
        let appid = "16adcfd37a1c8c0311e556b7f1077f8d"
        let baseURL = "https://api.openweathermap.org"
        let endPoint = "/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,current&units=metric&cnt=7&appid=\(appid)"
        
        let urlString = "\(baseURL)\(endPoint)"
        
        self.sendRequestByURL(byURL: urlString, completion: completion)
    }
    
    private func sendRequestByURL(byURL value: String, completion: @escaping (Weather) -> ()) {
        guard let url = URL(string: value) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                let weather = JsonParseManager.shared.JsonParse(data)
                completion(weather)
            }
        }
        task.resume()
    }
    
    func showWeather(_ weather: Weather) {
        self.weather.value = weather
        self.city.value = weather.city ?? ""
        self.reloadTableView?()
    }
}
