//
//  EntityContextListController.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import UIKit

class EntityContextListController: UITableViewController, DetailViewControllerDelegate {

    var model = MasterModel()
    
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

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let entityContext = EntityContext(rawValue: indexPath.row) else {
                return
            }
            
            model.currentEntityContext = entityContext
            
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailDelegate = self
            controller.navigationItem.title = entityContext.description
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

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
    
    func onDetailWillDismiss() {
        model.currentEntityContext = nil
    }

}

