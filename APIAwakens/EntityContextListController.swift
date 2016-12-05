//
//  EntityContextListController.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import UIKit

class EntityContextListController: UITableViewController, DetailViewControllerDelegate {

    var sounds = SoundManager()
    var model = MasterModel()
    var networkClient = StarWarsAPIClient()
    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // handle errors by displaying an appropriate message
    func handleError(error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SoundManager.Notifications.notificationPlayAlertSound.rawValue), object: nil)
        
        var message: String?
        
        if let netError = error as? APIClientError {
            switch netError {
            case .missingHTTPResponse:
                message = "Missing HTTP Response."
            case .unableToSerializeDataToJSON:
                message = "Unable to serialize returned data to JSON format."
            case .unableToParseJSON(let json):
                message = "Unable to parse JSON data: returned JSON data printed to console for inspection."
                print(json)
            case .unexpectedHTTPResponseStatusCode(let code):
                message = "Unexpected HTTP response: \(code)"
            case .noDataReturned:
                message = "No data returned by HTTP request."
            case .unknownError:
                message = "Dang! There was somekind of unknown error"
            }
        }
        
        if let message = message {
            
            let alert = UIAlertController(title: "Ouch!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let entityContext = EntityContext(rawValue: indexPath.row) else {
                return
            }
            
            // set the current context
            model.currentEntityContext = entityContext
            
            // play a fun sound!
            entityContext.playSound()
            
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailDelegate = self
            controller.navigationItem.title = entityContext.description
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true

            // fetch the results we want based on the entity context's associated use case
            let useCase = entityContext.useCase
            networkClient.fetch(request: useCase.request, parse: useCase.getParser()) { result in
                
                self.handleResults(for: controller, result: result)
            }
            
        }
    }
    
    // this method allows us to fetch subsequent pages
    func handleResults(for controller: DetailViewController, result: APIResult<ResultsPage>) {
        
        switch result {
        case .failure(let error):
            self.handleError(error: error)
        case .success(let resultsPage):
            
            // append these results
            controller.content.append(contentsOf: resultsPage.results)
            
            // try to get additional results
            if let nextPage = resultsPage.nextPageURLString {
                
                let useCase = StarWarsAPIUseCase.nextPage(nextPage)
                networkClient.fetch(request: useCase.request, parse: useCase.getParser()) { result in
                    
                    self.handleResults(for: controller, result: result)
                }
            }
        }
    }



    // MARK: - Table View

    // N.B. made the menu a data driven table view, so additional entities
    // could be added easily in the future
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntityContext.allValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityContextCell", for: indexPath) as! EntityContextCell

        let entityContext = EntityContext(rawValue: indexPath.row)
        cell.icon.image = entityContext?.icon
        cell.titleLabel.text = entityContext?.description
        cell.titleLabel.tintColor = .gray

        return cell
    }

    // MARK: DetailViewControllerDelegate
    
    var currentEntityContext: EntityContext? {
        return model.currentEntityContext
    }
    
}

