//
//  ReposTableViewController.swift
//  Most Popular GitHub Repos
//
//  Created by Alex Balas on 3/11/18.
//  Copyright © 2018 Alex Balas. All rights reserved.
//

import UIKit
import Alamofire
import GithubAPI
import DAKeychain

class ReposTableViewController: UITableViewController {

    var allRepos = [RepositoryResponse]()
    var filteredRepos = [RepositoryResponse]()
    var currentLanguage = " "
    var languages = [String]()
    
    
    @IBAction func didPressChooseLanguageButton(_ sender: Any) {
        
        let languageViewController = storyboard?.instantiateViewController(withIdentifier: "LanguagesTableViewController") as! LanguagesTableViewController
        
        languageViewController.currentLanguage = self.currentLanguage
        languageViewController.languages = self.languages
        
        self.navigationController?.pushViewController(languageViewController, animated: true)
    }
    func didChooseLanguage(language: String){
        self.currentLanguage = language
        self.navigationItem.title = language
        filterRepos()
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func didPressLogInButton(_ sender: Any) {
        let logInViewController = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
    
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    
    @objc func refresh(sender:AnyObject){
        getRepos()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        checkIfLoggedIn()
        getRepos()
     
    }
    
    func getRepos(){
        
        if let username = DAKeychain.shared["username"]
        {
            print(username )
            if let password = DAKeychain.shared["password"]
            {
                print(password)
                RepositoriesAPI(authentication: BasicAuthentication(username: username , password: password )).repositories(user: username ) { (responses, error) in
                    if let responses = responses {
                        print("primit repos")
                        print(responses.count)
                        
                        
                        self.allRepos = responses.sorted(by: { $0.stargazersCount! > $1.stargazersCount!})
                        
                        var languages = [String]()
                        for repo in self.allRepos{
                            if repo.language != nil{
                                if !languages.contains(repo.language!){
                                    languages.append(repo.language!)
                                }
                            }
                            else{
                                if !languages.contains("Unknown"){
                                    languages.append("Unknown")
                                }
                            }
                        }
                        self.languages = languages
                        
                        if self.currentLanguage == " "{
                            if languages.contains("Swift"){
                                self.currentLanguage = "Swift"
                                
                            }
                            else{
                                self.currentLanguage = languages[0]
                                
                            }
                            
                        }
                        self.navigationItem.title = self.currentLanguage
                        self.filterRepos()
                        
                    }
                    else{
                        print("eroare")
                        self.showError(error: error!.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.refreshControl?.endRefreshing()
                        self.tableView.reloadData()
                    }
                    
                    
                }
            }else{            
                self.refreshControl?.endRefreshing()
                showError(error: "Password not found. Login")
            }
        }
        else{
            self.refreshControl?.endRefreshing()
            showError(error: "Username not found. Login.")
            
        }
    }
    
    func filterRepos(){
        var repos = [RepositoryResponse]()
        for repo in self.allRepos{
            if repo.language != nil && repo.language! == self.currentLanguage{
                repos.append(repo)
            }
            if repo.language == nil && self.currentLanguage == "Unknown"{
                repos.append(repo)
            }
            
        }
        self.filteredRepos = repos
    }
    
    func checkIfLoggedIn(){
        if DAKeychain.shared["username"] != nil{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        }
        
    }
    
    @objc func logout(){
        DAKeychain.shared["username"] = nil
        DAKeychain.shared["password"] = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(ReposTableViewController.didPressLogInButton(_:)))
        
        self.allRepos = [RepositoryResponse]()
        self.filteredRepos = [RepositoryResponse]()
        self.currentLanguage = " "
        self.title = "Repos"
        self.languages = [String]()
        self.tableView.reloadData()
      
    }
    
    func didLogin(){
        
        refresh(sender: self)
        //self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
    }
    
    func showError(error: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
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
       
        return self.filteredRepos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        
        let repo = self.filteredRepos[indexPath.item]
        cell.nameLabel.text = repo.name
        cell.descriptionLabel.text = repo.descriptionField
        cell.starsLabel.text = "\(repo.stargazersCount!)  ⭐️"
        
        // Configure the cell...

        return cell
    }
}
