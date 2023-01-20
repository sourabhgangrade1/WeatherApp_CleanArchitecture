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
    var expandedIndexPath = IndexPath()

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
        expandedIndexPath = IndexPath(row: 0, section: 0)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchWeatherDetails(completion: { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isSuccess {
                    self.dataBinding()
                    self.weatherForeCastTableView.reloadData()
                }
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
        if indexPath == expandedIndexPath {
            return 150
        }
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.viewModel.getDayCount(), 5)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForeCastTableViewCell", for: indexPath) as? WeatherForeCastTableViewCell else {
            return WeatherForeCastTableViewCell()
        }
        cell.configureWith(viewModel: viewModel, index: (indexPath.row))
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()

        if indexPath == expandedIndexPath {
            expandedIndexPath = IndexPath()
        } else {
            expandedIndexPath = indexPath
        }

        tableView.endUpdates()
    }
}
