//
//  ViewController.swift
//  YearLongProject
//
//  Created by Derek Stengel on 2/29/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCreationNotifcationDelegate {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        PostsManager.shared.fetchPosts { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    PostsManager.shared.posts = posts // Update the posts array here
                    self.table.reloadData()
                }
            case .failure(let error):
                print("Failed to reload with posts.", error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsManager.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = PostsManager.shared.posts[indexPath.row]
        customCell.configure(with: post)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func deletePost(at indexPath: IndexPath) {
        let post = PostsManager.shared.posts[indexPath.row]
        let userSecret = UUID() // Replace with actual user secret
        
        PostsManager.shared.deletePost(postId: post.id, userSecret: userSecret) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    PostsManager.shared.posts.remove(at: indexPath.row)
                    self.table.deleteRows(at: [indexPath], with: .automatic)
                }
            case .failure(let error):
                print("Failed to delete post:", error)
            }
        }
    }
    
    func editPost(post: Post) {
        let userSecret = UUID() // Replace with actual user secret
        
        PostsManager.shared.editPost(post: post, userSecret: userSecret) { result in
            switch result {
            case .success(let updatedPost):
                DispatchQueue.main.async {
                    if let index = PostsManager.shared.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                        PostsManager.shared.posts[index] = updatedPost
                        self.table.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            case .failure(let error):
                print("Failed to edit post:", error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewPostViewController {
            destinationVC.delegate = self
            if let tabBarController = self.tabBarController,
               let viewControllers = tabBarController.viewControllers {
                for viewController in viewControllers {
                    if let navController = viewController as? UINavigationController,
                       let profileVC = navController.viewControllers.first as? MyProfileTableViewController {
                        destinationVC.profileDelegate = profileVC
                    }
                }
            }
        }
    }
    
    func didCreatePost(_ post: Post) {
        PostsManager.shared.posts.append(post)
        table.reloadData()
    }
}

