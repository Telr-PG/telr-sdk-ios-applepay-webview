
import Foundation
import UIKit


class applePayEncData1: Codable {
    
    
    var applepay_enc_keyhash: String
    

    private enum CodingKeys: String, CodingKey {
        
        case applepay_enc_keyhash
        
    }

    init(applepay_enc_keyhash: String) {
        
        self.applepay_enc_keyhash = applepay_enc_keyhash
        
    }

    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        applepay_enc_keyhash = try values.decode(String.self, forKey: .applepay_enc_keyhash)
        
    }
}
