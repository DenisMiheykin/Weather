import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: - let
    private let locationManager = CLLocationManager()
    
    // MARK: - var
    var weather = Weather()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bug
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        //
        
        self.setapLocationManager()
    }
    
    // MARK: - IBActions
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        fatalError()
    }
    
    @IBAction func getButtonPressed(_ sender: UIButton) {
        self.sendRequest { (weather) in
            DispatchQueue.main.async {
                self.showWeather(weather)
            }
        }
    }
    
    // MARK: - flow funcs
    func sendRequest(completion: @escaping (Weather) -> ()) {
        guard let text = self.cityTF.text,
            let city = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
            return
        }
        
        if city.isEmpty {
            return
        }
        
        let baseURL = "http://api.openweathermap.org"
        let endPoint = "/data/2.5/forecast?q=\(city)&cnt=1&appid=16adcfd37a1c8c0311e556b7f1077f8d"
        
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
    
    func sendRequest(byСoordinates latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Weather) -> ()) {
        
        let appid = "16adcfd37a1c8c0311e556b7f1077f8d"
        let baseURL = "https://api.openweathermap.org"
        let endPoint = "/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,current&units=metric&cnt=7&appid=\(appid)"
        
        let urlString = "\(baseURL)\(endPoint)"
        
        self.sendRequestByURL(byURL: urlString, completion: completion)
    }
    
    func sendRequestByURL(byURL value: String, completion: @escaping (Weather) -> ()) {
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
        self.weather = weather
        self.cityTF.text = weather.city
        self.tableView.reloadData()
    }
    
}

// MARK: - extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        if let weatherData = self.weather.data {
            if weatherData.count > 0  {
                cell.configure(with: weatherData[indexPath.row])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 7
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setapLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(location.latitude) \(location.longitude)")
        locationManager.stopUpdatingLocation()
        
        self.sendRequest(byСoordinates: location.latitude, longitude: location.longitude) { (weather) in
            DispatchQueue.main.async {
                self.showWeather(weather)
            }
        }
    }
    
}
