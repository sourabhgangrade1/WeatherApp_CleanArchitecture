//
//  LocationChangeViewController.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

class LocationChangeViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: LocationChangeViewModel!

    static func getInstance(with viewModel: LocationChangeViewModel) -> LocationChangeViewController {
        let view: LocationChangeViewController = UIStoryboard(identifier: .main).instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        self.showLoader()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchLocations(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeLoader()
            }
        })
    }
}

extension LocationChangeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCityDetails?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = viewModel.filteredCityDetails?[indexPath.row].cityName ?? ""
        let country = viewModel.filteredCityDetails?[indexPath.row].cityCountryCode ?? ""
        cell.textLabel?.text = name + ", " + country
        cell.selectionStyle = .default
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityDetails = viewModel.filteredCityDetails?[indexPath.row] else { return }
        viewModel.updateSelectedCity(cityDetails: cityDetails)
    }
}


extension LocationChangeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.dismissScreen()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let cityDetails = viewModel.cityDetails else { return }
        viewModel.filteredCityDetails = searchText.isEmpty ? cityDetails : cityDetails.filter({(cityDetail: CityDetails) -> Bool in
            // If dataItem matches the searchText, return true to include it
            //return cityDetail.cityName.range(of: searchText, options: .caseInsensitive) != nil
            return cityDetail.cityName.lowercased().hasPrefix(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

