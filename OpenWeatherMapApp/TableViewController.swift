//
//  TableViewController.swift
//  OpenWeatherMapApp
//
//  Created by Ruslan Fatkhulov on 01/07/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var citysArray: [CitysArray] = []
    var city: String!
    var tPlusW: String!
    
    var networkManager: NetworkManager!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest: NSFetchRequest<CitysArray> = CitysArray.fetchRequest()
        
        do {
            citysArray = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager = NetworkManager()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func updateUI(cell: TableViewCell, city: String) {
        networkManager.dataRequest(city: city) { (json, error) in
            if let _ = error {
                self.showAlert(title: "Something went wrong", message: "We could not find the city \"\(city)\"")
                let cityToDelete = self.citysArray.last
                
                self.context.delete(cityToDelete!)
                
                do {
                    try self.context.save()
                    self.citysArray.removeLast()
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                cell.configureCell(cell: cell, json: json!)
            }
        }
    }
    
    private func saveInDataBase(city: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CitysArray", in: self.context)
        let citysArrayObject = NSManagedObject(entity: entity!, insertInto: self.context) as! CitysArray
        
        citysArrayObject.city = city
        
        do {
            try self.context.save()
            self.citysArray.append(citysArrayObject)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    @objc private func refresh() {
        tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citysArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let city = citysArray[indexPath.row].city!
        updateUI(cell: cell, city: city)

        return cell
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let cityToDelete = citysArray[indexPath.row]
            
            context.delete(cityToDelete)
            
            do {
                try context.save()
                citysArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print("Error: \(error), description \(error.userInfo)")
            }
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func unwindSegue(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? AddNewCityViewController else { return }

        saveInDataBase(city: sourceViewController.cityTextField.text!)
    }

    
    @IBAction func unwindWithLocation(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? AddNewCityViewController else { return }

        saveInDataBase(city: sourceViewController.currentCity!)
    }
}
