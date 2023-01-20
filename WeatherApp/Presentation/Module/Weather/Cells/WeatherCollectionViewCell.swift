import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var weatherIconImage: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    func configureWith(weatherDetail: WeatherForeCastDetails, isNow: Bool) {
        timeLabel.text = isNow ? "Now" : weatherDetail.time
        weatherIconImage.image = UIImage(named: weatherDetail.weatherIcon)
        temperatureLabel.text = "\(weatherDetail.temperature)°"
    }
}
