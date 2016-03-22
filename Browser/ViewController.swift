//
//  ViewController.swift
//  Browser
//
//  Created by Alex on 12/22/15.
//  Copyright © 2015 Alex Barcenas. All rights reserved.
//

import WebKit
import UIKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    /*
     * Function Name: loadView
     * Parameters: None
     * Purpose: This method creates and displays a view that can browse the web.
     * Return Value: None
     */
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method loads the default web page on the browser and sets up the view to allow the user
     *   to navigate to other web pages. This method also creates a progress bar and refresh button for the web page.
     * Return Value: None
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "https://" + websites[0])!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: "reload")
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.toolbarHidden = false
    }
    
    /*
     * Function Name: openTapped
     * Parameters: None
     * Purpose: This method creates a view controller and displays a view that allows the user to open
     *   web pages on the web browser that comes from a list of web pages.
     * Return Value: None
     */
    
    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .Default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /*
     * Function Name: openPage
     * Parameters: action - the action associated with the web page that the user wants to open.
     * Purpose: This method opens the web page that the user chose in the alert controller.
     * Return Value: None
     */
    
    func openPage(action: UIAlertAction!) {
        let url = NSURL(string: "https://" + action.title!)!
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    /*
     * Function Name: webView
     * Parameters: webView - the web view that we are changing, navigation - tracks whether or not the
     *   web page has loaded.
     * Purpose: This method changes the title of the view contoller to the title of the web page.
     * Return Value: None
     */
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Function Name: observeValueForKeyPath
     * Parameters: keyPath - The key path, relative to object, to the value that has changed.
     *   object - The source object of the key path keyPath. 
     *   change - A dictionary that describes the changes that have been made to the value of
     *   the property at the key path keyPath relative to object. Entries are described in Change Dictionary Keys.
     *   context - The value that was provided when the receiver was registered to receive key-value observation notifications.
     * Purpose: This method updates the progress bar as the web page is loading.
     * Return Value: None
     */
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    /*
     * Function Name: webView
     * Parameters: webView - the web view that called this method.
     *   navigationAction - the action that triggered the navigation request.
     *   decisionHandler - a method that decides whether or not the navigation will be allowed.
     * Purpose: This method checks if a navigation request is allowed.
     * Return Value: None
     */
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.URL
        
        if let host = url!.host {
            for website in websites {
                if host.rangeOfString(website) != nil {
                    decisionHandler(.Allow)
                    return
                }
            }
        }
        
        decisionHandler(.Cancel)
    }

}

