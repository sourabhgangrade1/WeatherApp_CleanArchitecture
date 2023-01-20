//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var weatherForeCastTableView: UITableView!
    private var viewModel: WeatherForeCastViewModel!
    
    static func getInstance(with viewModel: WeatherForeCastViewModel) -> HomeViewController {
        let view: HomeViewController = UIStoryboard(identifier: .main).instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard isNetworkConnectionExist() else {
            self.showNoInternetAlert()
            return
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isNetworkConnectionExist() else {
            return
        }
        self.showLoader()
        viewModel.fetchWeatherDetails(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dataBinding()
                self.weatherForeCastTableView.reloadData()
                self.removeLoader()
            }
        })
    }

    private func dataBinding() {
        locationButton.setTitle(viewModel.getCityName(), for: .normal)
        weatherTypeImage.image = UIImage(named: viewModel.getTemperatureTypeImage(index: 0))
        weatherTypeLabel.text = viewModel.getTemperatureType(index: 0)
        temperatureLabel.text = viewModel.getCurrentTemperature(index: 0)
        dateLabel.text = self.viewModel.getTodaysDate(index: 0)
    }

    @IBAction func changeLocationTapped(_ sender: Any) {
        viewModel.showLocationChangeScreen()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.viewModel.weatherDetailsModel?.WeatherForeCastByDate.count else {
            return 0
        }
        return min(count - 1, 4)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForeCastTableViewCell", for: indexPath) as? WeatherForeCastTableViewCell else {
            return WeatherForeCastTableViewCell()
        }
        cell.configureWith(viewModel: viewModel, index: (indexPath.row + 1))
        cell.selectionStyle = .none
        return cell
    }
}
