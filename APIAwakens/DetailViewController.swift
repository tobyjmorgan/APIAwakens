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

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ExchangeRateViewControllerDelegate {

    @IBOutlet var smallestLabel: UILabel!
    @IBOutlet var largestLabel: UILabel!

    @IBOutlet var smallestNameLabel: UILabel!
    @IBOutlet var largestNameLabel: UILabel!
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mainNameLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func configureView() {
    }
    
    let defaults = UserDefaults.standard
    var detailItem: NSDate?
    var detailDelegate: DetailViewControllerDelegate?
    
    let client = StarWarsAPIClient()
    
    var content: [ [ String : AnyObject ] ] = []
    {
        didSet {
            if activityIndicator.isAnimating {
                
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }

            if oldValue.count == 0 {
                
                refreshEverything()
                
            } else {
                
                picker.reloadAllComponents()
                updateLowestAndHighest()
            }
        }
    }
    
    func refreshEverything() {
        
        setNameInitialValue()
        picker.reloadAllComponents()
        tableView.reloadData()
        updateLowestAndHighest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        navigationItem.backBarButtonItem?.title = " "
        
        if detailDelegate?.currentEntityContext != .characters {
            
            let rightButton = UIBarButtonItem(title: "Exch. Rate", style: .plain, target: self, action: #selector(DetailViewController.editExchangeRate))
            
            // Create two buttons for the navigation item
            navigationItem.rightBarButtonItem = rightButton
        }
        
        self.configureView()
    }

    // Thanks to Michael Garito on StackOverflow for this
    // http://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func setNameInitialValue() {
        
        if let stringValue = content.first?[ContentKey.name.rawValue] as? String {
            
            mainNameLabel.text = stringValue.capitalized
        }
    }
    
    func editExchangeRate() {
        performSegue(withIdentifier: "ExchangeRate", sender: nil)
    }
    
    
    
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let contentKey = detailDelegate?.currentEntityContext?.associatedKeys[indexPath.row],
            contentKey == .associatedVehicles {
            
            return 100
            
        } else {
            
            return 44
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
    
    func doNameLookUp(for cell: DetailCell, useCase: StarWarsAPIUseCase) {
        
        client.fetch(request: useCase.request, parse: useCase.getParser()) { result in
            
            switch result {
                
            case .success(let resultsPage):
                if let json = resultsPage.results.first,
                    let name = json[ContentKey.name.rawValue] as? String {
                    
                    if cell.valueLabel.text == "" {
                        
                        cell.valueLabel.text = name.capitalized

                    } else {
                    
                        cell.valueLabel.text = cell.valueLabel.text! + ", \(name.capitalized)"
                    }
                }
                
            case .failure:
                // fail quietly by not updating the value
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        // clearing out any residual stuff (for cell reuse)
        cell.descriptorLabel.text = ""
        cell.valueLabel.text = ""
        cell.toggleButtonView.isHidden = true

        // N.B. Each entity type (character, vehicle, starhsip) has a set
        // of associated keys (hair color, eye color etc) that are used to
        // drive the rows in this table.
        // So the first row might be "birth_year", so then we go get the value for 
        // birth_year from the JSON and process it for this cell

        // get the key from the associated keys that corresponds to this table row
        guard let contentKey = detailDelegate?.currentEntityContext?.associatedKeys[indexPath.row] else {
            return cell
        }
        
        // set the label for the descriptor to key description
        cell.descriptorLabel.text = contentKey.description
        
        let selectedItemIndex = picker.selectedRow(inComponent: 0)
        let selectedItemJSON = content[selectedItemIndex]
        
        if contentKey == .associatedVehicles {
            
            // this key doesn't actually exist in the API, so we have to derive it
            
            guard let vehiclesArray = selectedItemJSON["vehicles"] as? [String],
                  let starshipsArray = selectedItemJSON["starships"] as? [String] else {
                return cell
            }
            
            // iterate through vehicles arrays
            for urlString in vehiclesArray {
                
                guard let url = URL(string: urlString),
                      let id = Int(url.lastPathComponent) else {
                    break
                }
                
                // fetch the name for each concatenating it to the value for this cell
                let useCase = StarWarsAPIUseCase.vehicles(id)
                doNameLookUp(for: cell, useCase: useCase)
            }
            
            // iterate through starships arrays
            for urlString in starshipsArray {
                
                guard let url = URL(string: urlString),
                    let id = Int(url.lastPathComponent) else {
                        break
                }
                
                // fetch the name for each concatenating it to the value for this cell
                let useCase = StarWarsAPIUseCase.starships(id)
                doNameLookUp(for: cell, useCase: useCase)
            }
            
            
        } else {
            
            // this key does exist in the API, so just process the value
            
            // get the value from the JSON
            guard let contentValue = selectedItemJSON[contentKey.rawValue],
                  let stringValue = contentValue as? String else {
                return cell
            }
            
            switch contentKey {
                
            case .height, .length:
                if let doubleValue = Double(stringValue) {
                    
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
                if let doubleValue = Double(stringValue) {
                    
                    cell.toggleButtonView.isHidden = false
                    cell.leftToggleButton.setTitle("USD", for: .normal)
                    cell.rightToggleButton.setTitle("Credits", for: .normal)
                    
                    cell.valueWhenToggleIsRight = "\(Int(doubleValue))"
                    cell.valueWhenToggleIsLeft = "\(Int(doubleValue*(defaults.double(forKey: DefaultKeys.exchangeRate))))"
                    
                    cell.highlightRight()
                }
                
            case .homeworld:
                guard let url = URL(string: stringValue),
                      let id = Int(url.lastPathComponent) else {
                    return cell
                }
                
                let useCase = StarWarsAPIUseCase.planets(id)
                doNameLookUp(for: cell, useCase: useCase)
                
            case .birth_year:
                cell.valueLabel.text = stringValue.uppercased()
                
            default:
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
            returnName = name.capitalized
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
    
    
    
    // MARK: ExchangeRateViewControllerDelegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ExchangeRateViewController {
            target.delegate = self
        }
    }
    
    func onDismissExchangeRateVC() {
        dismiss(animated: true) { self.refreshEverything() }
    }

}

