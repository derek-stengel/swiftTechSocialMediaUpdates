//
//  PostManager.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/2/24.
//

import Foundation

class PostsManager {
    static let shared = PostsManager()
    
    private init() {
        posts = [
            Post(id: 1, user: "Thomas Mullins", date: "12/25/23", handle: "theThomasMullins", title: "First post", body: "Went for a hike today. Very cool sunrise.", numberOfComments: "3", numberOfLikes: "0"),
            Post(id: 2, user: "Carter Stengel", date: "1/23/24", handle: "carter.stengel", title: "Second Post", body: "Set up my new PC this morning.", numberOfComments: "1", numberOfLikes: "0"),
            Post(id: 3, user: "Apple Inc.", date: "5/25/24", handle: "Apple", title: "Third Post", body: "We have huge news. Tune in at apple.com/random for a huge annoucement concerning the Apple Vision Pro.", numberOfComments: "32", numberOfLikes: "0")
        ]
        myPosts = [
            Post(id: 1, user: "Derek Stengel", date: "5/12/24", handle: "derekstengel", title: "MAIN First Post", body: "This is my first ever post!", numberOfComments: "0", numberOfLikes: "0"),
            Post(id: 2, user: "Derek Stengel", date: "7/4/24", handle: "derekstengel", title: "MAIN Second Post", body: "Happy 4th of July guys! Hope you guys are having fun BBQ's and being around those you love.", numberOfComments: "0", numberOfLikes: "0")
        ]
    }
    
    var posts = [Post]()
    var myPosts = [Post]()
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(API.url)/posts") else {
            print("The API URL is incorrect")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
//                completion(.failure(error))
                print("Error message?")
                return
            }
            
            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                print("Could not retrieve data")
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                self.posts = posts
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension PostsManager {
    func createPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(API.url)/posts") else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            print("Incorrect URL when creating post")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let postData = try JSONEncoder().encode(post)
            request.httpBody = postData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                print("No data was recieved by the API")
                return
            }
            
            do {
                let createdPost = try JSONDecoder().decode(Post.self, from: data)
                self.posts.append(createdPost)
                self.myPosts.append(createdPost)
                completion(.success(createdPost))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func deletePost(postId: Int, userSecret: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(API.url)/post") else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            print("Invalid url when deleting post.")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "postid", value: "\(postId)")
        ]
        
        guard let url = urlComponents.url else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            print("Invalid URL when deleting")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete post"])))
                print("Failed to delete post.")
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
    func editPost(post: Post, userSecret: UUID, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(API.url)/editPost") else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            print("Invalid URL when editing post.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyParameters: [String: Any] = [
            "userSecret": userSecret.uuidString,
            "post": [
                "postid": post.id,
                "title": post.title,
                "body": post.body
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                print("No data recieved when editing post.")
                return
            }
            
            do {
                let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                    self.posts[index] = updatedPost
                }
                if let index = self.myPosts.firstIndex(where: { $0.id == post.id }) {
                    self.myPosts[index] = updatedPost
                }
                completion(.success(updatedPost))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}



//import Foundation
//
//class PostsManager {
//    static let shared = PostsManager()
//
//    private init() {
//        posts = [
//            Post(user: "Thomas Mullins", date: "12/25/23", handle: "theThomasMullins", body: "Went for a hike today. Very cool sunrise.", numberOfComments: "3", numberOfLikes: "0"),
//            Post(user: "Carter Stengel", date: "1/23/24", handle: "carter.stengel", body: "Set up my new PC this morning.", numberOfComments: "1", numberOfLikes: "0"),
//            Post(user: "Apple Inc.", date: "5/25/24", handle: "Apple", body: "We have huge news. Tune in at apple.com/random for a huge annoucement concerning the Apple Vision Pro.", numberOfComments: "32", numberOfLikes: "0")
//        ]
//        myPosts = [
//            Post(user: "Derek Stengel", date: "5/12/24", handle: "derekstengel", body: "This is my first ever post!", numberOfComments: "0", numberOfLikes: "0"),
//            Post(user: "Derek Stengel", date: "7/4/24", handle: "derekstengel", body: "Happy 4th of July guys! Hope you guys are having fun BBQ's and being around those you love.", numberOfComments: "0", numberOfLikes: "0")
//        ]
//    }
//
//    var posts = [Post]()
//    var myPosts = [Post]()
//}
