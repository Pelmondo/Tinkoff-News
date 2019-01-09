//
//  NewsTextViewController.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 09/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import UIKit

class NewsTextViewController: UIViewController,NewsBring {
    
    
    var choose : Int?
    var inital : Int?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
   
    func newsContainer(news: Response) {
        guard let row = choose else {return}
        print(row)
        DispatchQueue.main.async {
            let stri = news.response.news[row].text
            self.textView.text = stri.html2String
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.textView.isHidden = false
        }
    }

    let api = NetworkingAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        DispatchQueue.main.async {
            if let num = self.inital {
            self.api.test(initial: num)
            } else {
                self.api.test(initial: 0)
            }
            self.api.delegate = self
        }
        
        }
    
    
    
    
}
