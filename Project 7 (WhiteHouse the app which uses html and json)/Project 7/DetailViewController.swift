//
//  DetailViewController.swift
//  Project 7
//
//  Created by Maksat Baiserke on 24.08.2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else {return}
        
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style> body {
                        background: white;
                        font-size:150%;
                        color: black;
                        margin:0;
                        padding: 0;
                    }   header {
                        font-size:90%;
                        background: black;
                        color:white;
                        padding: 0px 10px 0px 20px;
                    }  section{
                        padding: 10px;
                        } footer {
                        background: black;
                        padding: 10px 20px;
                    }
                    </style>
            </head>
        <body>
            <header>
                <h1><i>White House Press</i></h1>
            </header>
            <section>
            \(detailItem.body)
            </section>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 

