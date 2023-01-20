//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weatherIconImage: UIImageView!
    @IBOutlet private weak var maxTemperature: UILabel!
    @IBOutlet private weak var minTemperature: UILabel!


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
    }
}
