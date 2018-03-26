//
//  LogInViewController.swift
//  Most Popular GitHub Repos
//
//  Created by Alex Balas on 3/21/18.
//  Copyright © 2018 Alex Balas. All rights reserved.
//

import UIKit
import GithubAPI
import DAKeychain


class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func submitLogin(_ sender: Any) {
        
        let name = self.usernameTextField.text!
        let pass = self.passwordTextField.text!
        
        let authentication = BasicAuthentication(username: name, password: pass)
        
        
        UserAPI(authentication: authentication).getUser { (response, error) in
            if let response = response?.url {
                print(response)
              
                
                DAKeychain.shared["username"] = name
                DAKeychain.shared["password"] = pass

                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    let previousViewController = self.navigationController?.viewControllers.last as! ReposTableViewController
                    previousViewController.didLogin()
                }
                
            }
            else{
                if let error = error{
                    self.showError(error: error.localizedDescription)
                }
                else{
                    self.showError(error: "Something is wrong with the input.")
                }
                
                
            }
            
            
        }
        
        
    }
    
    func showError(error: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
