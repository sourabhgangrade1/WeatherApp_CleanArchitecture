//
//  WeatherForeCastTableViewCell.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

class WeatherForeCastTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weatherIconImage: UIImageView!
    @IBOutlet private weak var maxTemperature: UILabel!
    @IBOutlet private weak var minTemperature: UILabel!
    @IBOutlet private weak var weatherCollectionView: UICollectionView!
    private var weatherForeCastDetails: [WeatherForeCastDetails] = []
    private var isToday = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(viewModel: WeatherForeCastViewModel, index: Int) {
        dayLabel.text = viewModel.getTodaysDay(index: index)
        weatherIconImage.image = UIImage(named: viewModel.getTemperatureTypeImage(index: index))
        maxTemperature.text = viewModel.getMaxTemperature(index: index)
        minTemperature.text = viewModel.getMinTemperature(index: index)
        weatherForeCastDetails = viewModel.getWeatherDetailsForFullDay(day: index)
        isToday = index == 0
        weatherCollectionView.reloadData()
    }
}

extension WeatherForeCastTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForeCastDetails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath as IndexPath) as? WeatherCollectionViewCell else {
            return WeatherCollectionViewCell()
        }
        cell.configureWith(weatherDetail: weatherForeCastDetails[indexPath.item], isNow: (isToday && indexPath.item == 0))
        return cell
    }
}
