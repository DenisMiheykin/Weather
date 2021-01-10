import Foundation

class ViewModel {
    
    // MARK: - let
    let weather: Bindable<Weather> = Bindable(Weather())
    let error: Bindable<String?> = Bindable(nil)
    
    // MARK: - flow funcs
    func getWeather(for city: String, alert: @escaping () -> ()) {
        self.sendRequestByCity(city, alert: alert) { (weather) in
            self.weather.value = weather
        }
    }
    
    func sendRequest(byСoordinates latitude: Double, longitude: Double) {
        self.sendRequestByСoordinates(latitude: latitude, longitude: longitude) { (weather) in
            self.weather.value = weather
        }
    }
    
    private func sendRequestByCity(_ city: String, alert: () -> (), completion: @escaping (Weather) -> ()) {
        guard let city = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
            return
        }
        
        if city.isEmpty {
            alert()
            return
        }
        
        let endPoint = "/data/2.5/forecast"
        let cnt = 1
        let parameters = "?q=\(city)&cnt=\(cnt)&appid=\(Constants.appid)"
        
        guard let url = URL(string: "\(Constants.baseURL)\(endPoint)\(parameters)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.get
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                let result = JsonParseManager.shared.getCoordinates(data)
                if result.error == nil {
                    self.sendRequestByСoordinates(latitude: result.latitude, longitude: result.longitude, completion: completion)
                } else {
                    self.error.value = result.error
                }
                
            }
        }
        task.resume()
    }
    
    private func sendRequestByСoordinates(latitude: Double, longitude: Double, completion: @escaping (Weather) -> ()) {
        
        let endPoint = "/data/2.5/onecall"
        let exclude = "minutely,current"
        let units = "metric"
        let cnt = 7
        let parameters = "?lat=\(latitude)&lon=\(longitude)&exclude=\(exclude)&units=\(units)&cnt=\(cnt)&appid=\(Constants.appid)"
        
        let urlString = "\(Constants.baseURL)\(endPoint)\(parameters)"
        
        self.sendRequestByURL(byURL: urlString, completion: completion)
    }
    
    private func sendRequestByURL(byURL value: String, completion: @escaping (Weather) -> ()) {
        guard let url = URL(string: value) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.get
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                let weather = JsonParseManager.shared.jsonParse(data)
                completion(weather)
            }
        }
        task.resume()
    }
}
