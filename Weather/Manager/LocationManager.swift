import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var callBackAfterStop: ((_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> ())?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationManager() {
        if let locationManager = self.locationManager {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(location.latitude) \(location.longitude)")
        
        if let locationManager = self.locationManager {
            locationManager.stopUpdatingLocation()
            
            if let callBackAfterStop = self.callBackAfterStop {
                callBackAfterStop(location.latitude, location.longitude)
            }
        }
        
    }
}
