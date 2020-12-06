import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var dayLable: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    @IBOutlet weak var speedLable: UILabel!
    @IBOutlet weak var imageViewBackground: UIImageView!
    
    // MARK: - lifecycle funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - flow funcs
    func configure(with weather: WeatherData) {
        if let date = weather.date {
            self.dayLable.text = WeatherData.getDay(from: date).localized
        }
        if let temp = weather.temperature {
            self.tempLable.text = "\(temp) \u{00B0}C"
        }
        if let humidity = weather.humidity {
            self.humidityLable.text = "\(humidity) %"
        }
        if let speedWind = weather.speedWind {
            self.speedLable.text = "\(speedWind) \("mps".localized)"
        }
        if let image = weather.image {
            self.imageViewBackground.image = UIImage(named: image)
        }
    }
}
