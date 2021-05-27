//
//  WeatherViewController.swift
//  Weather
//
//  Created by Nicholas Angelo Petelo on 5/19/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var locationService: LocationService!
    var weatherService: WeatherService!
    
    private var cityLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = label.font.withSize(50)
        label.text = "- -"
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = label.font.withSize(40)
        label.text = "- -"
        return label
    }()
    
    init(locationService: LocationService, weatherService: WeatherService) {
        super.init(nibName: nil, bundle: nil)
        self.locationService = locationService
        self.weatherService = weatherService
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureViews()
        configureConstraints()
        createObservers()
    }
    
    @objc private func fetchWeather() {
        locationService.getLocation { [weak self] cityName, location in
            self?.weatherService.getCurrentWeatherWithCityAndCoords(cityName: cityName, coords: location.coordinate) { [weak self] temperature in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.cityLabel.fadeInLabel(newText: cityName)
                    self.temperatureLabel.fadeInLabel(newText: String(format: "%.1f", temperature) + "º")
                }
            }
        }
    }
    
    private func configureViews() {
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
    }
    
    private func configureConstraints() {
        var constraints = [NSLayoutConstraint]()
        //cityLabel
        constraints.append(cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50))
        constraints.append(cityLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(cityLabel.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(cityLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9))
        //temperatureLabel
        constraints.append(temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10))
        constraints.append(temperatureLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(temperatureLabel.heightAnchor.constraint(equalToConstant: 40))
        constraints.append(temperatureLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor))
        view.addConstraints(constraints)
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchWeather), name: NSNotification.Name(rawValue: "locationAuthorized"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension UILabel {
    
    func fadeInLabel(newText: String) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.text = newText}, completion: nil)
    }
}
