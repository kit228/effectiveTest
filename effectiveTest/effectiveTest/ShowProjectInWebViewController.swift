//
//  ShowProjectInWebViewController.swift
//  effectiveTest
//
//  Created by Вениамин Китченко on 05.07.2020.
//  Copyright © 2020 Вениамин Китченко. All rights reserved.
//

import UIKit
import WebKit // для вебвью

class ShowProjectInWebViewController: UIViewController {
    
    var urlStringToLoad: String? // строка с url проекта (передается через сегвей)
    var webView: WKWebView! // переменная webView
    
    override func loadView() {
        webView = WKWebView()
        //webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlStringUnwrapped = urlStringToLoad else {return}
        guard let urlToLoad = URL(string: urlStringUnwrapped) else {return}
        webView.load(URLRequest(url: urlToLoad))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}
