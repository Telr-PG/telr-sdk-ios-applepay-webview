//
//  encdata.swift
//  Shoe Store
//
//  Created by Maroof Saeed on 2/9/22.
//  Copyright © 2022 Pranav Wadhwa. All rights reserved.
//

import Foundation
import UIKit




class applePayEncData3: Codable {
    
    
    var applepay_enc_paysig: String

    private enum CodingKeys: String, CodingKey {
        
        case applepay_enc_paysig
    }

    init( applepay_enc_paysig: String) {
        
        self.applepay_enc_paysig = applepay_enc_paysig
    }

    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        applepay_enc_paysig = try values.decode(String.self, forKey: .applepay_enc_paysig)
    }
}



