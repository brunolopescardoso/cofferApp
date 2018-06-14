//
//  ViewController.swift
//  cofferApp
//
//  Created by Bruno de Stefano on 06/04/18.
//  Copyright © 2018 Coffer Tech. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var erroLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentLogin: UISegmentedControl!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var celularText: UITextField!
    @IBOutlet weak var cpfText: UITextField!
    @IBOutlet weak var nomeText: UITextField!
    
    @IBAction func segmentLoginAction(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 // Login
        {
            emailText.text = "bruno.stefano@gmail.com"
            passwordText.text = "Ck2d14"
            celularText.isHidden = true
            cpfText.isHidden = true
            nomeText.isHidden = true
        }
        else
        {
            celularText.isHidden = false
            cpfText.isHidden = false
            nomeText.isHidden = false
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        
        if segmentControl.selectedSegmentIndex == 0 // Login
        {
            if emailText.text != "" && passwordText.text != ""
            {
                Auth.auth().signIn(withEmail:emailText.text!, password:passwordText.text!,  completion: { (user, error) in
                    if user != nil
                    {
                        self.performSegue(withIdentifier: "segue", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            self.erroLabel.text = myError
                        }
                        else
                        {
                            self.erroLabel.text = "ERROR"
                        }
                    }
                })
            }
        }
        else // Sign up
        {
            let nome = nomeText.text!
            let cpf = cpfText.text!
            let celular = celularText.text!
            let email = emailText.text!
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                if user != nil
                {
                    let parameters = ["Nome": nome, "CPF" : cpf, "DDI" : "XX", "DDD" : "XX", "Celular" : celular, "Email" : email, "uid_firebase" : (Auth.auth().currentUser?.uid)!] as [String : Any]
                    
                    if self.insertTitular(parameters) == true
                    {
                        self.performSegue(withIdentifier: "segue", sender: self)
                    }
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        self.erroLabel.text = myError
                    }
                    else
                    {
                        self.erroLabel.text = "ERROR"
                    }
                }
            })
        }
    }
    
    func insertTitular(_ parameters:Any) -> Bool {
        
        //create the url with URL
        let url = URL(string: "http://coffer.com.br:8001/api/titular/")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

