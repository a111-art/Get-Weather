//
//  ChooseCityViewController.swift
//  get-weather
//
//  Created by a111 on 2021/3/16.
//

import UIKit
import SnapKit

//Write the protocol declaration here:
protocol ChooseCityDelegate {
    func userChooseNewCity(city: String)
}

class ChooseCityViewController: UIViewController, UITextFieldDelegate {

    var delegate: ChooseCityDelegate?
    
    //create UI
    let textField = UITextField()
    let getDataBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Choose City"
        
        // UI
        textField.delegate = self
        textField.placeholder = "city name"
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 60))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.setValue(UIFont.systemFont(ofSize: 20), forKeyPath: "placeholderLabel.font")
        self.view.addSubview(textField)
        textField.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(60)
        }
        
        getDataBtn.setTitle("Get Weather", for: .normal)
        getDataBtn.setTitleColor(.blue, for: .normal)
        getDataBtn.addTarget(self, action: #selector(getWeatherPressed), for: .touchUpInside)
        self.view.addSubview(getDataBtn)
        getDataBtn.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(textField)
        }
        
    }
    
    @objc func getWeatherPressed() {
        let cityName = textField.text!
        delegate?.userChooseNewCity(city: cityName)
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
