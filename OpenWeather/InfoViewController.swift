//
//  InfoViewController.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
