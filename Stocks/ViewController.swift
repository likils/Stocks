//
//  ViewController.swift
//  Stocks
//
//  Created by likils on 09.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var requestService: RequestService?
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func loadView() {
        super.loadView()
        textView.isEditable = false
        requestService = RequestService()
    }
    

    @IBAction func button(_ sender: UIButton) {
        requestService?.getNews(category: .company(symbol: "AAPL"), completion: { news in
            DispatchQueue.main.async {
                self.textView.text = "\(news)"
            }
        })
    }
}

