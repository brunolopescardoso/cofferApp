//
//  ViewController3.swift
//  cofferApp
//
//  Created by Bruno de Stefano on 17/04/18.
//  Copyright © 2018 Coffer Tech. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    var titularId:Int?
    
    @IBOutlet weak var lancamentoText: UITextField!
    @IBOutlet weak var titularText: UITextField!
    @IBOutlet weak var efetuadoText: UITextField!
    @IBOutlet weak var categoriaText: UITextField!
    @IBOutlet weak var dataPagamentoText: UITextField!
    @IBOutlet weak var carteiraText: UITextField!
    @IBOutlet weak var valorText: UITextField!
    @IBOutlet weak var inserirButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lancamentoText.text = "Teste"
        efetuadoText.text = "Pend"
        categoriaText.text = "Contas Residenciais"
        dataPagamentoText.text = "2018-01-01"
        valorText.text = "100.00"
        carteiraText.text = "Santander"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func inserirLancamento(_ sender: Any) {
        
        let parameters = ["titular": titularId!, "lancamento" : lancamentoText.text!, "valor_pagamento" : valorText.text!, "efetuado" : efetuadoText.text!, "nm_carteira" : carteiraText.text!, "des_categoria" : categoriaText.text!, "data_pagamento" : dataPagamentoText.text!] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://coffer.com.br:8001/api/lancamento/")!
        
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
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        performSegue(withIdentifier: "segue4", sender:self)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
