//
//  NewsTextViewController.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 09/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import UIKit

protocol TextNewsDelegate: class {
    func textBring(news: Response, numberOfRow: Int)
}

class NewsTextViewController: UIViewController,TextNewsDelegate,NewsBring {
    func newsContainer(news: Response) {
        DispatchQueue.main.async {
            let stri = news.response.news[0].text
            self.textView.text = stri.html2String
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    
   
   
    
    let firstNewsList = NewsListViewController()
    let api = NetworkingAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.test()
        firstNewsList.delegate = self
        api.delegate = self
        }
    
    
    func textBring(news: Response, numberOfRow: Int) {
        
    }
    
    
}
