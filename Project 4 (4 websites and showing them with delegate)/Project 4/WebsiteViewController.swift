//
//  WebsiteViewController.swift
//  Project 4
//
//  Created by Maksat Baiserke on 12.08.2022.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var web: UIView!    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var notAllowed: String?
    var selectedWebsite: [String]?
    var safe: [String]?
    var x: Int?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().isTranslucent = true
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.view.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
                                   
                                   
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit() // will take as much place as it needs to show its                          progressView
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, progressButton, spacer, refresh, forward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let which = x {
            if let webx = selectedWebsite {
                let url = URL(string: "https://" + webx[which])!
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
            }
        }
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Opening...", message: nil, preferredStyle: .actionSheet)
        if let webx = selectedWebsite {
        for website in webx {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
            }
        
        
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
            present(ac, animated: true)
        }
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {return}
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
        notAllowed = actionTitle
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let safewebx = safe {
        if let host = url?.host {
            for website in safewebx {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
            let ac = UIAlertController(title: "\(host) is prohibited website", message: "KNB is coming after you better to click \"cancel\" ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
        }
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
