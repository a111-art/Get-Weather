//
//  WeatherViewController.swift
//  get-weather
//
//  Created by a111 on 2021/3/15.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SnapKit
import SVProgressHUD

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChooseCityDelegate {
    
    //Constants
    let Weather_URL = "http://api.openweathermap.org/data/2.5/weather"
    let App_ID = "7b643fc01dba49085eb94a09965a2f18"
    
    //UI
    let temperatureLabel = UILabel()
    let cityLabel = UILabel()
    let goChooseCityBtn = UIButton()
    
    //Declare instance variables here
    let locationManager = CLLocationManager()
    let dataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "WEATHER"
        
        //create UI
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .right
        self.view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ (make) -> Void in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
        }
        
        cityLabel.textColor = .black
        cityLabel.textAlignment = .right
        self.view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints{ (make) -> Void in
            make.right.height.equalTo(temperatureLabel)
            make.bottom.equalTo(temperatureLabel.snp.top)
        }
        
        goChooseCityBtn.setTitle("Search Weather", for: .normal)
        goChooseCityBtn.setTitleColor(.blue, for: .normal)
        goChooseCityBtn.addTarget(self, action: #selector(goChooseCityView), for: .touchUpInside)
        self.view.addSubview(goChooseCityBtn)
        goChooseCityBtn.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
        }
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    //MARK: - Networking
    //Write the getWeatherData method here:
    func getData(url: String, parameters: [String:String]) {
        SVProgressHUD.show()
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                print("get data successfully")
                let weatherJSON: JSON = JSON(response.value!)
                self.updateData(json: weatherJSON)
            case let .failure(error):
                print(error)
                self.cityLabel.text = "Link error"
            }
            SVProgressHUD.dismiss()
        }
    }
    //MARK: - JSON Parsing
    //Write the updateWeatherData method here:
    func updateData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            dataModel.temperature = Int(tempResult - 273.15)
            dataModel.city = json["name"].stringValue
            dataModel.condition = json["weather"]["id"].intValue
            updateUIWithData()
        }else{
            cityLabel.text = "the data can't be used"
        }
    }
    //MARK: - UI Updates
    //Write the updateUIWithWeatherData method here:
    func updateUIWithData() {
        cityLabel.text = dataModel.city
        temperatureLabel.text = String(dataModel.temperature) + "°"
    }
    //MARK: - Location Manager Delegate Methods
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            print("longitude = \(longitude) , latitude = \(latitude)")
            
            let params: [String:String] = ["lat": latitude, "lon": longitude, "appid": App_ID]
            getData(url: Weather_URL, parameters: params)
        }
    }
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Get location failed"
    }
    
    //MARK: - Change City Delegate methods
    //Write the userEnteredANewCityName Delegate method here:
    func userChooseNewCity(city: String) {
        let params: [String:String] = ["q": city, "appid": App_ID]
        getData(url: Weather_URL, parameters: params)
    }
    //Write the go to chooseCityView
    @objc func goChooseCityView() {
        let vc = ChooseCityViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

