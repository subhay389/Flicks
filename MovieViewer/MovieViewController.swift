//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by Subhay Manandhar on 2/5/17.
//  Copyright © 2017 Subhay Manandhar. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    
    var filteredData: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if searchBar != nil{
            searchBar.delegate = self
        }
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
//        addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        refreshControl.backgroundColor = UIColor.gray
        tableView.insertSubview(refreshControl, at: 0)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")

   
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                   // print(dataDictionary)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movies  = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    
                }
            }
        }
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredData = filteredData {
                return filteredData.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let baseURL = "http://image.tmdb.org/t/p/w500"

        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        if let posterPath = movie["poster_path"] as? String{
            let imageURL = NSURL(string: baseURL + posterPath)
            cell.posterView.setImageWith(imageURL as! URL)
        }
        


        //print("row \(indexPath.row)")
        return cell
        
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    // print(dataDictionary)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.movies  = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? movies : movies?.filter({(dataString: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = dataString["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredData = movies
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        let movie = movies?[indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.current_movie = movie!

        
    }


}
