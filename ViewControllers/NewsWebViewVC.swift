//
//  NewsWebViewVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 01.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var thisNewsArticle: NewsArticle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarItem.leftBarButtonItem = UIBarButtonItem(title: "Tilbake", style: .done, target: self, action: #selector(self.backBtn))
        navBarItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        
        
        newsWebView.uiDelegate = self
        newsWebView.navigationDelegate = self
        newsWebView.load(URLRequest(url: URL(string: thisNewsArticle.url)!))
        
    }
    
    @objc func backBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }

}
