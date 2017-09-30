//
//  TableViewController.swift
//  WeatherApp
//
//  Created by Jose Melendez on 9/29/17.
//  Copyright © 2017 JoseMelendez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Cell
        self.tableView.register(CustomeTableViewCell.self, forCellReuseIdentifier: "resultsCell")
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! CustomeTableViewCell
        
        cell.textLabel?.text = "Jose"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3 
    }
    
    
    
}
