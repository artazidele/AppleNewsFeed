//
//  ViewController.swift
//  AppleNewsFeed
//
//  Created by arta.zidele on 12/02/2021.
//

import UIKit
import Gloss


class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var items: [Item] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Apple News"
        //activityIndicatorView.isHidden = true
        activityIndicatorView.style = .large
        tableView.isHidden = true
        
    }

    @IBAction func getDataTapped(_ sender: Any) {
        handleData()
        activityIndicator(animated: true)
    }
    func activityIndicator(animated: Bool) {
        DispatchQueue.main.async {
            if animated {
                self.tableView.isHidden = false
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            } else {
                self.tableView.isHidden = true
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func handleData() {
        
        let jsonUrl = "http://newsapi.org/v2/everything?q=tesla&from=2021-02-11&sortBy=publishedAt&apiKey=f39cdb6f9a8e4abf8bdbad68f38be49d"
        
        guard let url = URL(string: jsonUrl) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            
            if let err = error {
                print("error: \(err.localizedDescription)")
            }
            
            guard let data = data else {
                print("Data error!!!")
                return
            }
            
            do {
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("dictData", dictData)
                    self.populateData(dictData)
                }
            } catch {
                print("err when converting JSON")
            }
            
        }
        task.resume()
        
    }
    func populateData(_ dict: [String: Any]) {
        guard let responseDict = dict["articles"] as? [Gloss.JSON] else {
            return
        }
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator(animated: false)
        }
    }
    
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        
       // cell.textLabel?.text = items[indexPath.row].title
       // cell.detailTextLabel?.text = items[indexPath.row].description
        
        let item = items[indexPath.row]
        if let image = item.image {
            cell.newsImageView.image = image
        }
        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        
        
        vc.contentString = items[indexPath.row].description
        vc.titleString = items[indexPath.row].title
        vc.webURLString = items[indexPath.row].url
        vc.newsImage = items[indexPath.row].image
            
        navigationController?.pushViewController(vc, animated: true)
            
        
    }
    
}

