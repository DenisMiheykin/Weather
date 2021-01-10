import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlyLable: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
        
    func configure(with weather: WeatherHourly) {
        if let date = weather.date {
            self.hourlyLable.text = WeatherData.getHour(from: date)
        }
        if let temp = weather.temp {
            self.tempLable.text = "\(temp)\(Constants.degreesSymbol)"
        }
        if let image = weather.image {
            self.imageView.image = UIImage(named: image)
        }
    }
    
}
