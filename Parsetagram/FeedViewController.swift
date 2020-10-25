//
//  FeedViewController.swift
//  Parsetagram
//
//  Created by Avni Avdulla on 10/24/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: UIControl.Event.valueChanged)
        
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let query = PFQuery(className: "Posts")
        
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    @objc func onRefresh(_ refreshControl: UIRefreshControl){
        let query = PFQuery(className: "Posts")
        
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
          // Reload the tableView now that there is new data
          tableView.reloadData()

          // Tell the refreshControl to stop spinning
          refreshControl.endRefreshing()
      }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let user = post["author"] as! PFUser
         
        cell.usernameLabel.text = user.username
        cell.descriptionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        
        let imageUrl = URL(string: imageFile.url!)!
        
        cell.photoView.af_setImage(withURL: imageUrl)
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
