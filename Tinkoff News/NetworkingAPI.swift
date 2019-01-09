//
//  NetworkingAPI.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 09/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import UIKit

struct Response : Decodable {
    let response: News
}

struct News : Decodable{
    let news : [TestNews]
    let total: Int
}

struct TestNews : Decodable {
    //    let id : Int
    let text : String
    let title : String
}

protocol NewsBring: class {
    func newsContainer (news: Response)
}

class NetworkingAPI {
    var delegate : NewsBring?

    let decoder = JSONDecoder()

    func test (initial: Int) {
   
        
        guard let url = URL(string: "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=20&pageOffset=\(initial)") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
        if let response = response {
           print(response)
        }
        
        guard let data = data else {return}
        //        print (data)
            
        do {
            let start = try self.decoder.decode(Response.self, from: data)
            dump(start)
           self.delegate?.newsContainer(news: start)
        } catch {
            print (error)
        }
        }.resume()
        }
}


// MARK: - HTML Test

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

