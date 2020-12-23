import Foundation

class ViewModel {
    
    // MARK: - let
    let weather: Bindable<Weather> = Bindable(Weather())
    
    // MARK: - var
    var reloadTableView: (() -> ())?
    var city: Bindable<String> = Bindable("")
    
    // MARK: - flow funcs
    func getWeather(for city: String) {
        self.city = Bindable(city)
        self.sendRequest { (weather) in
            self.showWeather(weather)
        }
    }
    
    func sendRequest(byСoordinates latitude: Double, longitude: Double) {
        self.sendRequest(byСoordinates: latitude, longitude: longitude) { (weather) in
            self.showWeather(weather)
        }
    }
    
    private func sendRequest(completion: @escaping (Weather) -> ()) {
        guard let city = city.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
            return
        }
        
        if city.isEmpty {
            return
        }
        
        let baseURL = "http://api.openweathermap.org"
        let endPoint = "/data/2.5/forecast"
        let cnt = 1
        let appid = "16adcfd37a1c8c0311e556b7f1077f8d"
        let parameters = "?q=\(city)&cnt=\(cnt)&appid=\(appid)"
        
        guard let url = URL(string: "\(baseURL)\(endPoint)\(parameters)") else {
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
    
    private func sendRequest(byСoordinates latitude: Double, longitude: Double, completion: @escaping (Weather) -> ()) {
        
        let appid = "16adcfd37a1c8c0311e556b7f1077f8d"
        let baseURL = "https://api.openweathermap.org"
        let endPoint = "/data/2.5/onecall"
        let exclude = "minutely,current"
        let units = "metric"
        let cnt = 7
        let parameters = "?lat=\(latitude)&lon=\(longitude)&exclude=\(exclude)&units=\(units)&cnt=\(cnt)&appid=\(appid)"
        
        let urlString = "\(baseURL)\(endPoint)\(parameters)"
        
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
