//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Meagan Olsen on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray =  [NSDictionary]()
    var numTweets:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweet()
        
    }
    func loadTweet(){
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { ( tweets:  [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
           self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf:imageUrl!)
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        cell.setFavorited(_isFavorited: tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(_isRetweeted: tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

   
}
