//
//  ViewController2.swift
//  cofferApp
//
//  Created by Bruno de Stefano on 06/04/18.
//  Copyright © 2018 Coffer Tech. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var listLancamento = [[String : AnyObject]]()
    var titularId:Int?

    @IBOutlet weak var tableViewLancamentos: UITableView!
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var buttonSair: UIBarButtonItem!
    
    @IBAction func novoLancamento(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segue3", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitular()
        self.tableViewLancamentos.setContentOffset(.zero, animated: true)
        
    }
    
    @IBAction func sair(_ sender: UIBarButtonItem) {
        try?Auth.auth().signOut()
        performSegue(withIdentifier: "segue2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController3 = segue.destination as! ViewController3
        viewController3.titularId = titularId
    }
    
    func loadTitular()
    {
        let url = "http://www.coffer.com.br:8001/api/titular/uid/" + (Auth.auth().currentUser?.uid)! + "?format=json"
        
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print(error.debugDescription)
            }
            else {
                do {
                    let titularJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String : AnyObject]]
                    
                    self.titularId = (titularJson[0]["id"] as? Int)!
                    self.loadLancamentos()
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
    
    func loadLancamentos() {
        let url = "http://www.coffer.com.br:8001/api/lancamento/uid/" + (Auth.auth().currentUser?.uid)! + "?format=json"
        
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print(error.debugDescription)
            }
            else {
                do {
                    self.listLancamento = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        as! [[String : AnyObject]]
                    
                        self.tableViewLancamentos.reloadData()

                } catch let error as NSError {
                    print(error)
                }
                
            }
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listLancamento.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewLancamentos.dequeueReusableCell(withIdentifier: "cellLancamento", for: indexPath)
        
        let item = self.listLancamento[indexPath.row]
        cell.textLabel?.text = item["lancamento"] as? String
        cell.detailTextLabel?.text = item["valor_pagamento"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listLancamento.remove(at: indexPath.row)
            tableViewLancamentos.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
