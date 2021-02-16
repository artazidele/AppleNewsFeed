//
//  SavedNewsTableViewController.swift
//  AppleNewsFeed
//
//  Created by arta.zidele on 15/02/2021.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {

    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do{
            savedItems = try (context?.fetch(request))!
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context?.save()
        } catch {
            //alert
            print(error.localizedDescription)
        }
        //loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        if let image = UIImage(data: item.image!) {
            cell.newsImageView.image = image
        }
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                
                let item = self.savedItems[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
                self.loadData()
                
            }))
            self.present(alert, animated: true)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
