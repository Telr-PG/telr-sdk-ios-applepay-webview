//
//  encdata.swift
//  Shoe Store
//
//  Created by Maroof Saeed on 2/9/22.
//  Copyright © 2022 Pranav Wadhwa. All rights reserved.
//

import Foundation
import UIKit




class applePayEncData: Codable {
    
    var applepay_enc_pubkey: String
    

    private enum CodingKeys: String, CodingKey {
        case applepay_enc_pubkey
        
    }

    init(applepay_enc_pubkey: String) {
        self.applepay_enc_pubkey = applepay_enc_pubkey
        
    }

    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        applepay_enc_pubkey = try values.decode(String.self, forKey: .applepay_enc_pubkey)
        
    }
}



