//
//  ViewController.swift
//  Dose
//
//  Created by Jenny Swift on 21/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bloodSugarNowField: UITextField!
    @IBOutlet weak var bloodSugarGoalField: UITextField!
    @IBOutlet weak var netCarbsField: UITextField!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var lantusField: UITextField!
    @IBOutlet weak var novoRapidField: UITextField!
    @IBOutlet weak var netCarbsPerUnitField: UITextField!
    @IBOutlet weak var minutesWalkingField: UITextField!
    
    var bloodSugarNow: Float = 3.4
    var bloodSugarGoal: Float = 4.5
    var netCarbs: Float = 0.0
    var netCarbsPerUnit: Float = 44.1
    var minutesWalking: Float = 0
    var novoRapid: Float = 0
    var lantus: Float = 0
    var dose: Float = 0.0
    var correctionFactor: Float = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupKeyboardHiding()
        
        setValues()
        calculateDose()
    }
    
    func setupKeyboardHiding() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        calculateDose()
    }
    
    @objc func dismissKeyboard() {
        bloodSugarNowField.resignFirstResponder()
        bloodSugarGoalField.resignFirstResponder()
        netCarbsField.resignFirstResponder()
        lantusField.resignFirstResponder()
        novoRapidField.resignFirstResponder()
        netCarbsPerUnitField.resignFirstResponder()
        minutesWalkingField.resignFirstResponder()
    }
    
    func setValues() -> Void {
        bloodSugarNowField.text = "\(bloodSugarNow)"
        bloodSugarGoalField.text = "\(bloodSugarGoal)"
        minutesWalkingField.text = "\(minutesWalking)"
        novoRapidField.text = "\(novoRapid)"
        lantusField.text = "\(lantus)"
        netCarbsPerUnitField.text = "\(netCarbsPerUnit)"
        netCarbsField.text = "\(netCarbs)"
    }
    
    func calculateDose() -> Void {
        getFloatValuesFromFields()
        
        var correction = bloodSugarNow - bloodSugarGoal
        correction = correction / correctionFactor
        
        let walkingFactor = minutesWalking / 60
        
        dose = netCarbs / netCarbsPerUnit
        dose += correction
        dose -= walkingFactor
        dose -= novoRapid
        dose -= lantus
        
        dose = round(dose * 100) / 100
        
        updateDoseLabel()
    }
    
    func updateDoseLabel() -> Void {
        doseLabel.text = "Dose: \(dose)"
    }
    
    func getFloatValuesFromFields() -> Void {
        guard let a = bloodSugarNowField.text else { return }
        bloodSugarNow = NSString(string: a).floatValue
        
        guard let b = bloodSugarGoalField.text else { return }
        bloodSugarGoal = NSString(string: b).floatValue
        
        guard let c = netCarbsField.text else { return }
        netCarbs = NSString(string: c).floatValue
        
        guard let d = netCarbsPerUnitField.text else { return }
        netCarbsPerUnit = NSString(string: d).floatValue
        
        guard let e = minutesWalkingField.text else { return }
        minutesWalking = NSString(string: e).floatValue
        
        guard let f = novoRapidField.text else { return }
        novoRapid = NSString(string: f).floatValue
        
        guard let g = lantusField.text else { return }
        lantus = NSString(string: g).floatValue
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

