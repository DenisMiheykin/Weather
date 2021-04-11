import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentImageView: UIImageView!
    
    // MARK: - let
    private let locationManager = CLLocationManager()
    
    // MARK: - var
    var viewModel = ViewModel()
    var weather = Weather()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindUI()
        self.setapLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    // MARK: - IBActions
    @IBAction func getButtonPressed(_ sender: UIButton) {
        guard let city = self.cityTextField.text else {
            return
        }
        
        if city.isEmpty {
            self.showAlertWhenCityIsEmpty()
            return
        }
        
        viewModel.getWeather(for: city, alert: { self.showAlertWhenCityIsEmpty() })
    }
    
    // MARK: - flow funcs
    func bindUI() {
        viewModel.weather.bind { [weak self] (weather) in
            self?.weather = weather
            let image = weather.hourly?.first?.image ?? ""
            self?.backImageView.image = UIImage(named: "back\(image)")
            self?.cityLabel.text = weather.city
            self?.currentTempLabel.text = "\(weather.hourly?.first?.temp ?? 0)\(Constants.degreesSymbol)"
            self?.currentImageView.image = UIImage(named: image)
            
            self?.collectionView.reloadData()
            self?.tableView.reloadData()
        }
        
        viewModel.error.bind { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Error!", message: error, handler: nil)
            }
        }
    }
}

// MARK: - extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfDaysInWeek
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell else {
            return UITableViewCell()
        }

        if let weatherData = weather.data {
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let weatherHourly = weather.hourly, weatherHourly.count > 0 {
            cell.configure(with: weatherHourly[indexPath.item])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension ViewController {
    func setup() {
        self.cityTextField.layer.cornerRadius = 10
        self.cityTextField.layer.borderWidth = 1.0
        self.cityTextField.layer.borderColor = UIColor.gray.cgColor
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.alpha = 0.5
        self.cityTextField.leftViewMode = .always
        self.cityTextField.leftView = imageView
        
        self.getButton.layer.cornerRadius = 10
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
        locationManager.stopUpdatingLocation()
        
        viewModel.sendRequest(byСoordinates: location.latitude, longitude: location.longitude)
    }
}
