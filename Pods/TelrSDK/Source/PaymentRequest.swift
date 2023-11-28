//
//  PaymentRequest.swift
//  TelrSDK
//
//  Created by Telr Sdk on 10/02/2020.
//  Copyright (c) 2020 Telr Sdk. All rights reserved.
//

import UIKit

open class PaymentRequest:NSObject{
    
    public var store = String()
    
    public var key = String()
    
    public var deviceType = String()
    
    public var deviceId = String()
    
    public var appId = String()
    
    public var appName = String()
    
    public var appUser = String()

    public var appVersion = String()
    
    public var transTest = String()
    
    public var transType = String()
    
    public var transClass = String()
    
    public var transCartid = String()
    
    public var transDesc = String()
    
    public var transCurrency = String()
    
    public var transAmount = String()
    
    public var billingEmail = String()
    
    public var billingPhone = String()
    
    public var billingFName = String()
    
    public var billingLName = String()
    
    public var billingTitle = String()
    
    public var city = String()
    
    public var country = String()

    public var region = String()
    
    public var address = String()
    
    public var zip = String()
    
    public var language = String()
    
    public var transRef = String()
    
    public var transFirstRef = String()
    
    public var cardToken = String()
    
    public var api_custref = String()
    
    public var split_id = String()
    
    public override init(){}
       
    public func getCardsinfo(completion: @escaping(String) -> ()) {
        
        let params = ["api_storeid ":self.store, "api_authkey":self.key,"api_testmode":self.transTest,"api_custref":self.api_custref] as Dictionary<String, String>
        print(params)
        var request = URLRequest(url: URL(string: "https://secure.telr.com/gateway/savedcardslist.json")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = params.percentEncoded()
        URLSession.shared.dataTask(with: request) {data, res, err in
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyObject>
                print(json as Any)
                if let SavedCardListResponse = json?["SavedCardListResponse"] as?  Dictionary<String, AnyObject> {
                    if let code = SavedCardListResponse["Code"] as? Int {
                        if(code==200){
                            if let data2 = SavedCardListResponse["data"] as? [Any] {
                                guard let data = try? JSONSerialization.data(withJSONObject: data2, options: []) else {
                                    completion("")
                                    return
                                }
                                let convertedString = String(data: data, encoding: String.Encoding.utf8)
                                print(convertedString ?? "")
                                DispatchQueue.main.async {
                                    completion(convertedString ?? "")
                                }
                            }else {
                                completion("")
                            }
                        }else {
                            completion("")
                        }
                    }else {
                        completion("")
                    }
                }else {
                    completion("")
                }
            }
        }.resume()
        
    }
    
    // Dont send json request, send form post: post parameters - Deven
   
}



extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


//let urlString = "https://uat.testourcode.com/telr-sdk/jssdk/token_frame.html?sdk=ios&store_id=\(self.STOREID)&currency=\(currency)&test_mode=\(mode)&saved_cards=\(cardDetails.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) ?? "")"

