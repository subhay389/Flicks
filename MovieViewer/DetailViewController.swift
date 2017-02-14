//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Subhay Manandhar on 2/7/17.
//  Copyright © 2017 Subhay Manandhar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    var current_movie: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        print(current_movie)
        let title = current_movie["title"] as! String
        let overview = current_movie["overview"] as! String
    
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        if let posterPath = current_movie["poster_path"] as? String{
            let imageURL = NSURL(string: baseURL + posterPath)
            posterImageView.setImageWith(imageURL as! URL)
        }
        
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
