//
//  TwitchViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 5/4/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit

class TwitchViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var loadedBool:Bool = false
    var myTimer: Timer!
    var barTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        loadWebView(request: URLRequest(url: URL(string: "http://twitch.tv/brainwashsports")!))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadWebView(request: URLRequest) {
        
        
        webView.loadRequest(request)
        //progressBar.isHidden = true
    }
    
    func timerCallback(){
        
        if progressBar.progress < 0.4 {
            progressBar.progress += 0.001
        }
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressBar.progress = 0
        progressBar.alpha = 1
        progressBar.isHidden = false
        progressBar.setProgress(0.01, animated: true)
        loadedBool = false
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(WebViewController.timerCallback), userInfo: nil, repeats: true)
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadedBool = true
        progressBar.setProgress(1, animated: true)
        myTimer.invalidate()
        let _:Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            
            
            self.fadeBar()
            
            
        }
        //progressBar.isHidden = true
    }
    
    func fadeBar() {
        
        barTimer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(WebViewController.alphaFade), userInfo: nil, repeats: true)
        
        
        
        
    }
    func alphaFade () {
        if progressBar.alpha > 0 {
            
            progressBar.alpha -= 0.05
        } else {
            
            barTimer.invalidate()
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
