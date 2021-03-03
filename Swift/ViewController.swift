//
//  ViewController.swift
//  Reddit Approver
//
//  Created by Michael Suarez on 8/2/20.
//  Copyright © 2020 Michael Suarez. All rights reserved.
//

import UIKit
import NotificationCenter

// Globals used to pass data to UpdateViewController
var globalId: String?
var globalTitle: String?
var globalPostID: String?
var globalUrl: String?
var globalCreated: String?
var globalUser: String?
var initialLoad = true
var initialTags = "#list #of #hashtags #included #in #every #post "
var hashtags = ["potentially", "very", "long", "list", "of", "relevant", "hashtags", "to", "whatever", "subreddit", "you", "are", "scraping", "that", "are", "chosen", "randomly"]

class customCell: UITableViewCell {
    var id: String?
    var title: String?
    var postID: String?
    var url: String?
    var created: String?
    var user: String?
}

class UpdateViewController: UIViewController, UITextViewDelegate {
    
    @objc func keyboardWillShow(notification: Notification) {
    //with line below ,we can get the keyboard size.
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
        
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardSize.height, right: 0)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        //performSegue(withIdentifier: "home", sender: nil)
        dismiss(animated: true, completion: nil) // new code
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var judgeImageView: UIImageView!
    @IBOutlet weak var judgeTextView: UITextView!
    @IBAction func judgeApprove(_ sender: UIButton) {
        print("approve")
        let request = NSMutableURLRequest(url: NSURL(string: "https://your_website_url.com/approve_post.php")! as URL)
        request.httpMethod = "POST"
        let postString = "postID=\(globalPostID!)&wrd=fjowiejfo584829jdj&postURL=\(globalUrl!)&postDescription=\(judgeTextView.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error = \(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response string = \(String(describing: responseString))")
        }
        
        task.resume()
        //performSegue(withIdentifier: "home", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func judgeDeny(_ sender: UIButton) {
        print("deny")
        let request = NSMutableURLRequest(url: NSURL(string: "https://your_website_url.com/deny_post.php")! as URL)
        request.httpMethod = "POST"
        //'wrd' is a secret word to ensure only those accessing your page while setting this variable
        //are able to make insert this data.
        let postString = "postID=\(globalPostID!)&wrd=fjowiejfo584829jdj"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error = \(String(describing: error))")
                return
            }
            
            print("response = \(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response string = \(String(describing: responseString))")
        }
        
        task.resume()
        //performSegue(withIdentifier: "home", sender: nil)
        dismiss(animated: true, completion: nil) // new code
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
            var tempHashtags = hashtags
            var tempHashtagsCount = tempHashtags.count
            var postHashTags = ""
            
            // Randomizing which hashtags are chosen as well as the number of them chosen
            for _ in 1...12 {
                let randInt = Int.random(in: 0...(tempHashtagsCount-1))
                print("randInt = \(randInt)")
                var newHashTag = tempHashtags[randInt]
                newHashTag = "#" + newHashTag
                postHashTags = postHashTags + newHashTag + " "
                tempHashtags.remove(at: randInt)
                tempHashtagsCount = tempHashtagsCount - 1
            }
        
            if (globalUrl != nil) {
            let postText = """
            \"\(globalTitle!)\"
            •  •  •  
            ✒️ Original post credit goes to u/\(globalUser!)
            •  •  •
            ✅ Follow @your_instagram_handle for the best posts from [insert_cool_subreddit_here :D]!
            •  •  •
            \(initialTags)\(postHashTags)
            """
            let url = URL(string: globalUrl!)
            judgeImageView.load(url: url!)
            judgeTextView.text = postText
        }
    }
}

extension UpdateViewController {
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeModelProtocol  {
    
    //Properties
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : PostModel = PostModel()
    @IBOutlet weak var listTableView: UITableView!

    func judgePost(cell: customCell) {
        globalId = cell.id
        globalTitle = cell.title
        globalUrl = cell.url
        globalPostID = cell.postID
        globalCreated = cell.created
        globalUser = cell.user
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "judgeVC") as! UpdateViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDefaults()
        
        //set delegates and initialize homeModel
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        self.listTableView.register(customCell.self, forCellReuseIdentifier: "BasicCell")
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set delegates and initialize homeModel
        resetDefaults()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        self.listTableView.register(customCell.self, forCellReuseIdentifier: "BasicCell")
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.downloadItems()
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell: customCell = tableView.cellForRow(at: indexPath)! as! customCell
        judgePost(cell: cell)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! customCell
        myCell.accessoryType = .detailButton
        // Get the location to be shown
        let item: PostModel = feedItems[indexPath.row] as! PostModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.title
        
        // Set all of the appropriate values for each cell
        myCell.id = item.id
        myCell.title = item.title
        myCell.postID = item.postID
        myCell.url = item.url
        myCell.created = item.created
        myCell.user = item.user
        
        return myCell
    }
    
}
