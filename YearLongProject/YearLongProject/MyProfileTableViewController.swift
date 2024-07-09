//
//  MyProfileTableViewController.swift
//  YearLongProject
//
//  Created by Derek Stengel on 6/28/24.
//

import UIKit

class MyProfileTableViewController: UITableViewController, SettingsDelegate, PostCreationNotifcationDelegate {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.leftBarButtonItem = editButtonItem // needs implimentation
    }
    
    // MARK: SettingsDelegate
    
    func didUpdateProfile(name: String?, handle: String?, bio: String?, interests: String?) {
        if let name = name {
            profile.name = name
        }
        if let handle = handle {
            profile.handle = handle
        }
        if let bio = bio {
            profile.bio = bio
        }
        if let interests = interests {
            profile.interests = interests
        }
        
        table.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            if let settingsVC = segue.destination as? SettingsViewController {
                settingsVC.delegate = self
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + PostsManager.shared.myPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 275
        } else {
            return 210
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            cell.configure(with: profile)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            let post = PostsManager.shared.myPosts[indexPath.row - 1]
            cell.configure(with: post)
            
            return cell
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }

    func didCreatePost(_ post: Post) {
        PostsManager.shared.myPosts.append(post)
        table?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PostsManager.shared.myPosts.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
