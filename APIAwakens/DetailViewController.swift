//
//  DetailViewController.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import UIKit

extension Double {
    var metersToInches: Int {
        return Int(self*39.3701)
    }
}

typealias Feet = Int
typealias Inches = Int

extension Int {
    var inchesToFeetAndInches: (Feet, Inches) {
        let feet = Int(self / 12)
        let inches = self % 12
        
        return (feet, inches)
    }
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var smallestLabel: UILabel!
    @IBOutlet var largestLabel: UILabel!

    @IBOutlet var smallestNameLabel: UILabel!
    @IBOutlet var largestNameLabel: UILabel!
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mainNameLabel: UILabel!
    
    func configureView() {
    }
    
    var detailItem: NSDate?
    var detailDelegate: DetailViewControllerDelegate?
    var exchangeRate: Double = 1000.0
    
    var content: [ [ String : AnyObject ] ] = []
    {
        didSet {
            picker.reloadAllComponents()
            tableView.reloadData()
            updateLowestAndHighest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
    }

    // Thnaks to Michael Garito on StackOverflow for this
    // http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        detailDelegate?.onDetailWillDismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum ExtremeType {
        case highest
        case lowest
        
        var startValue: Double {
            switch self {
            case .highest:
                return Double.leastNonzeroMagnitude
            case .lowest:
                return Double.greatestFiniteMagnitude
            }
        }
    }
    
    func getNameOfExtremeValue(for key: ContentKey, extreme: ExtremeType) -> String {
        
        var mostExtreme: Double = extreme.startValue
        var name: String = ""
        
        for item in content {
            
            guard let stringValue = item[key.rawValue] as? String,
                  let doubleValue = Double(stringValue),
                  let nameString = item[ContentKey.name.rawValue] as? String else {
                break
            }
            
            switch extreme {
            
            case.highest:
                if doubleValue > mostExtreme {
                    mostExtreme = doubleValue
                    name = nameString
                }
                
            case.lowest:
                if doubleValue < mostExtreme {
                    mostExtreme = doubleValue
                    name = nameString
                }
            }
        }
        
        return name
    }
    
    func updateLowestAndHighest() {
        
        if let entityContext = detailDelegate?.currentEntityContext {
            
            switch entityContext {
            
            case .characters:
                smallestLabel.text = "Shortest"
                largestLabel.text = "Tallest"

                smallestNameLabel.text = getNameOfExtremeValue(for: .height, extreme: .lowest)
                largestNameLabel.text = getNameOfExtremeValue(for: .height, extreme: .highest)

            case .vehicles, .starships:
                smallestLabel.text = "Smallest"
                largestLabel.text = "Largest"

                smallestNameLabel.text = getNameOfExtremeValue(for: .length, extreme: .lowest)
                largestNameLabel.text = getNameOfExtremeValue(for: .length, extreme: .highest)
            }
        }
        
    }

    
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let keyCount = detailDelegate?.currentEntityContext?.associatedKeys.count,
              content.count > 0 else {
            return 0
        }
        
        return keyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        // clearing out any residual stuff (for cell reuse)
        cell.descriptorLabel.text = ""
        cell.valueLabel.text = ""
        cell.toggleButtonView.isHidden = true

        
        guard let contentKey = detailDelegate?.currentEntityContext?.associatedKeys[indexPath.row],
              let contentValue = content[picker.selectedRow(inComponent: 0)][contentKey.rawValue] else {
            return cell
        }
        
        // set the label for the descriptor to key description
        cell.descriptorLabel.text = contentKey.description
        
        switch contentKey {
            
        case .height, .length:
            if let stringValue = contentValue as? String,
               let doubleValue = Double(stringValue) {
                
                cell.toggleButtonView.isHidden = false
                cell.leftToggleButton.setTitle("English", for: .normal)
                cell.rightToggleButton.setTitle("Metric", for: .normal)
                
                let (feet, inches): (Int, Int)
                
                if contentKey == .height {
                    cell.valueWhenToggleIsRight = "\(doubleValue/100)m"
                    (feet, inches) = (doubleValue/100).metersToInches.inchesToFeetAndInches
                } else {
                    cell.valueWhenToggleIsRight = "\(doubleValue)m"
                    (feet, inches) = doubleValue.metersToInches.inchesToFeetAndInches
                }

                cell.valueWhenToggleIsLeft = "\(feet)' \(inches)"
                
                cell.highlightRight()
            }
            
        case .cost_in_credits:
            
            if let stringValue = contentValue as? String,
               let doubleValue = Double(stringValue) {
                
                cell.toggleButtonView.isHidden = false
                cell.leftToggleButton.setTitle("USD", for: .normal)
                cell.rightToggleButton.setTitle("Credits", for: .normal)
                
                cell.valueWhenToggleIsRight = "\(Int(doubleValue))"
                cell.valueWhenToggleIsLeft = "\(Int(doubleValue*exchangeRate))"
                
                cell.highlightRight()
            }
            
        default:
            if let stringValue = contentValue as? String {
                cell.valueLabel.text = stringValue.capitalized
            }
        }
        
        return cell
    }


    
    
    // MARK: UIPickerViewDataSource
    
    func getNameFromContent(row: Int) -> String {
        
        var returnName: String = ""
        
        let item = content[row]
        
        if let name = item[ContentKey.name.rawValue] as? String {
            returnName = name
        }
        
        return returnName
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return content.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getNameFromContent(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainNameLabel.text = getNameFromContent(row: row)
        tableView.reloadData()
    }
    
}

