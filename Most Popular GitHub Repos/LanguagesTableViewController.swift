//
//  LanguagesTableViewController.swift
//  Most Popular GitHub Repos
//
//  Created by Alex Balas on 3/10/18.
//  Copyright © 2018 Alex Balas. All rights reserved.
//

import UIKit

class LanguagesTableViewController: UITableViewController {

    var currentLanguage = ""
    var languages = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.navigationController?.popViewController(animated: true)
        let previousViewController = self.navigationController?.viewControllers.last as! ReposTableViewController
        previousViewController.didChooseLanguage(language: self.languages[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.languages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let label = UILabel(frame: cell.bounds)
        
        label.text = self.languages[indexPath.item]
        label.textAlignment = NSTextAlignment.center
        
        
        
        cell.addSubview(label)
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == self.languages.index(of: self.currentLanguage)){
            cell.setSelected(true, animated: false)
        }
    }

}
