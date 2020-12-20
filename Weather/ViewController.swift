import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: - let
    private let locationManager = CLLocationManager()
    
    // MARK: - var
    var viewModel = ViewModel()
    
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
        viewModel.getWeather()
    }
    
    // MARK: - flow funcs
    func bindUI() {
        viewModel.city.bind { (value) in self.cityTF.text = value }
        
        viewModel.weather.bind { [weak self] (value) in
            self?.collectionView.reloadData()
        }

        viewModel.reloadTableView = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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

        if let weatherData = viewModel.weather.value.data {
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
        return viewModel.weather.value.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let weatherHourly = viewModel.weather.value.hourly, weatherHourly.count > 0 {
            cell.configure(with: weatherHourly[indexPath.item])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setup() {
        self.cityTF.layer.cornerRadius = 10
        self.cityTF.layer.borderWidth = 1.0
        self.cityTF.layer.borderColor = UIColor.gray.cgColor
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.alpha = 0.5
        self.cityTF.leftViewMode = .always
        self.cityTF.leftView = imageView
        
        self.getButton.layer.cornerRadius = 10
    }
    
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
        
        viewModel.sendRequest(byСoordinates: location.latitude, longitude: location.longitude)
    }
    
}
