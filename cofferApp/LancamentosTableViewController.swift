//
//  LancamentosTableViewController.swift
//  Lancamentos
//
//  Created by Bruno de Stefano on 3/26/18.
//  Copyright © 2018 Coffer. All rights reserved.
//

import UIKit
import FirebaseAuth

class LancamentosTableViewController: UITableViewController {
    
    var listData = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://www.coffer.com.br:8001/api/lancamento/uid/" + (Auth.auth().currentUser?.uid)! + "?format=json"
        
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print(error.debugDescription)
            }
            else {
                do {
                    self.listData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        as! [[String : AnyObject]]
                    
                    self.tableView.reloadData()
                    
                } catch let error as NSError {
                    print(error)
                }
                
            }
            
        }).resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = self.listData[indexPath.row]
        cell.textLabel?.text = item["lancamento"] as? String
        cell.detailTextLabel?.text = item["data_pagamento"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
