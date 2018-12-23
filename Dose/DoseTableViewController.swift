//
//  DoseTableViewController.swift
//  Dose
//
//  Created by Jenny Swift on 22/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

struct Row {
    let label: String
    var value: Float
    let tag: Int
}

class DoseTableViewController: UITableViewController {
    @IBOutlet weak var doseLabel: UILabel!
    
    @IBAction func resetFields(_ sender: Any) {
        print("reseting fields...")
        bloodSugarNow = 0
        
        bloodSugarGoal = 4.5
        netCarbs = 0
//        netCarbsPerUnit = 0
        minutesWalking = 0
        novoRapid = 0
        lantus = 0

        updateRowValues()
        tableView.reloadData()
        calculateDose()
    }
    
    func updateRowValues() -> Void {
        rows[0].value = bloodSugarNow
        rows[1].value = bloodSugarGoal
        rows[2].value = netCarbs
        rows[3].value = netCarbsPerUnit
        rows[4].value = minutesWalking
        rows[5].value = novoRapid
        rows[6].value = lantus
    }
    

    //Mark: Properties
    var bloodSugarNow: Float = 0.0
    var bloodSugarGoal: Float = 4.5
    var netCarbs: Float = 0.0
    var netCarbsPerUnit: Float = 44.1
    var minutesWalking: Float = 0
    var novoRapid: Float = 0
    var lantus: Float = 0
    var dose: Float = 0.0
    var correctionFactor: Float = 3.0
    
    var rows: [Row] = [
        Row(label: "Blood Sugar Now", value: 0.0, tag: 0),
        Row(label: "Blood Sugar Goal", value: 4.5, tag: 1),
        Row(label: "Net Carbs", value: 0.0, tag: 2),
        Row(label: "Net Carbs Per Unit", value: 0.0, tag: 3),
        Row(label: "Minutes Walking", value: 0.0, tag: 4),
        Row(label: "NovoRapid", value: 0.0, tag: 5),
        Row(label: "Lantus", value: 0.0, tag: 6),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupKeyboardHiding()
        setupKeyboardShowing()
        
        calculateDose()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NumberTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NumberTableViewCell else {
                fatalError("The dequeued cell is not an instance of NumberTableViewCell.")
        }

        let row = rows[indexPath.row]
        cell.tableCellLabel!.text = row.label
        cell.tableCellTextField!.text = String(row.value)
        cell.tableCellTextField.tag = row.tag

        cell.tableCellTextField.delegate = self

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupKeyboardShowing() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupKeyboardHiding() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        calculateDose()
    }

    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
    }
    
    @objc func dismissKeyboard() {
//        bloodSugarNowField.resignFirstResponder()
//        bloodSugarGoalField.resignFirstResponder()
//        netCarbsField.resignFirstResponder()
//        lantusField.resignFirstResponder()
//        novoRapidField.resignFirstResponder()
//        netCarbsPerUnitField.resignFirstResponder()
//        minutesWalkingField.resignFirstResponder()
    }
    
    func calculateDose() -> Void {
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

}

extension DoseTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field should return")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let x = textField.text else { return }
        let value = NSString(string: x).floatValue
        
        switch textField.tag {
        case 0:
            bloodSugarNow = value
            rows[0].value = value
        case 1:
            bloodSugarGoal = value
            rows[1].value = value
        case 2:
            netCarbs = value
            rows[2].value = value
        case 3:
            netCarbsPerUnit = value
            rows[3].value = value
        case 4:
            minutesWalking = value
            rows[4].value = value
        case 5:
            novoRapid = value
            rows[5].value = value
        case 6:
            lantus = value
            rows[6].value = value
        default:
            return
        }
        
        calculateDose()
    }
}


