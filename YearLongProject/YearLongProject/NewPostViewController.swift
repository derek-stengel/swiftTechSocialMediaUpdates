//
//  NewPostViewController.swift
//  YearLongProject
//
//  Created by Derek Stengel on 6/25/24.
//

import UIKit

class NewPostViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var newPostTextView: UITextView!
    @IBOutlet var createPostButton: UIButton!
    
    weak var delegate: PostCreationNotifcationDelegate?
    weak var profileDelegate: PostCreationNotifcationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        guard let body = newPostTextView.text, !body.isEmpty else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.string(from: Date())
        
        let post = Post(id: 1, user: "Derek Stengel", date: date, handle: "derekstengel", title: "Test 1", body: body, numberOfComments: "0", numberOfLikes: "0")
        
        PostsManager.shared.createPost(post: post) { result in
            switch result {
            case .success(let createdPost):
                DispatchQueue.main.async {
                    self.delegate?.didCreatePost(createdPost)
                    self.profileDelegate?.didCreatePost(createdPost)
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("Failed to create post", error)
            }
        }
        
        delegate?.didCreatePost(post)
        profileDelegate?.didCreatePost(post)
        
        dismiss(animated: true, completion: nil)
    }
}












//import UIKit
//
//class NewPostViewController: UIViewController, UINavigationControllerDelegate {
//    
//    @IBOutlet var newPostTextView: UITextView!
//    @IBOutlet var createPostButton: UIButton!
//    
//    weak var delegate: NewPostViewControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBAction func createButtonPressed(_ sender: Any) {
//        guard let body = newPostTextView.text,
//              !body.isEmpty else {
//            return
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let date = dateFormatter.string(from: Date())
//        
//        let post = Post(user: "Derek Stengel", date: date, handle: "derekstengel", body: body, numberOfComments: "0", numberOfLikes: "0")
//        
//        delegate?.didCreatePost(post)
//        
////        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//    }
//}
