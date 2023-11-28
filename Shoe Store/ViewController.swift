//
//  ViewController.swift
//  Shoe Store
//
//  Created by Pranav Wadhwa on 12/28/18.
//  Copyright © 2018 Pranav Wadhwa. All rights reserved.
//

import UIKit
import PassKit
import TelrSDK


var checkoutLabel: String = "test 123"
var payableAmount: Int = 1
var currency: String = "SAR"
var countryCode: String = "SA"


//****  USE YOUR STOE ID & AUTH KEY  *******//
var storeId: String = "<<Store_ID>>"//"YourStoreID"
var authKey: String = "<<Auth_Key>>"//"YourStoreAuthKey"

var returnAuth: String = "http://www.google.com"
var returnDec: String = "http://www.google.com"
var returnCan: String = "http://www.google.com"
var billFname: String = "moon"
var billSname: String = "moon"
var billAddr1: String = "Dubai AE"
var billCity: String = "DUBAI"
var billRegion: String = "DUBAI"
var billCountry: String = "AE"
var billZip: String = "16028"
var billEmail: String = "<<Email_ID>>"
var delivrAddr1: String = "daira dubai"
var delivrAddr2: String = "daira dubai"
var delivrAddr3: String = "daira dubai"
var delivrCity: String = "DUBAI"
var delivrRegion: String = "DUBAI"
var delivrCountry: String = "AE"
var apiTest: String = "0"

var custName = "Babu"
var custSurN = "Pakla"
var custPhone = "987654234"
var trxDesc = "Payment for Service"
var storeCartID = "SID123"
//var paymentRequest = PaymentRequest.self
var split_id = "105"



class ViewController: UIViewController {
    
    // Data Setup
    
    struct Shoe {
        var name: String
        var price: Double
    }
    
    
    
    
    
    
    let requestPP = PKPaymentRequest()
    
    // Storyboard outlets
    
    @IBOutlet weak var shoePickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var indicator:ProgressIndicator?
    
    
    
    
    @IBAction func buyShoeTapped(_ sender: UIButton) {
        
        // Open Apple Pay purchase
        
        let selectedIndex = shoePickerView.selectedRow(inComponent: 0)
            //let shoe = shoeData[selectedIndex]
            let paymentItem = PKPaymentSummaryItem.init(label: "Purchase Goods", amount: NSDecimalNumber(value: payableAmount))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
        } else {
            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
        
        // #Mark -- Change Merchat ID
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
        
            requestPP.currencyCode = currency // 1
            requestPP.countryCode = countryCode // 2
            requestPP.merchantIdentifier = "merchant.com.telr.applepay" // 3 -- Change ID
            
            requestPP.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            requestPP.supportedNetworks = paymentNetworks // 5
            requestPP.paymentSummaryItems = [paymentItem] // 6
            requestPP.requiredBillingContactFields = [PKContactField.emailAddress];
            
        }
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: requestPP) else {
            displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
            return
        }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoePickerView.delegate = self
        shoePickerView.dataSource = self
        
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loa")
        self.view.addSubview(indicator!)
        
        let button = PKPaymentButton.init(paymentButtonType: .buy, paymentButtonStyle: .black)
        button.addTarget(self, action: #selector(buyShoeTapped), for: .touchUpInside)

                button.center = view.center
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
                view.addSubview(button)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator?.removeFromSuperview()
    }
    
    
    @IBAction func TelrHostedPage(_ sender: Any) {
        //displayDefaultAlert(title: "Tler Hosted", message: "Testing")
        
        let customBackButton = UIButton(type: .custom)
        customBackButton.setTitle("Back", for: .normal)
        customBackButton.setTitleColor(.black, for: .normal)

        //Mark:-Use this to push the telr payment page.
       var paymentRequest = preparePaymentRequest()
        let telrController = TelrController()
        telrController.delegate = self
        telrController.customBackButton = customBackButton
        telrController.paymentRequest = paymentRequest
        self.navigationController?.pushViewController(telrController, animated: true)
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func doSendPaymentData(transactionIdentifier: String, applepay_enc_version: String, applepay_enc_data: String, applepay_enc_paysig: String, applepay_enc_pubkey: String, applepay_enc_keyhash: String, applepay_tran_id: String, applepay_card_desc: String, applepay_card_scheme: String, applepay_card_type: String, applepay_tran_id2: String){
        
        let getApiUrl = "https://secure.telr.com/gateway/remote.json";
        
        let json = ["ivp_method": "applepay", "ivp_store": storeId, "ivp_authkey": authKey, "ivp_amount": payableAmount, "ivp_currency": currency, "ivp_test": apiTest, "ivp_desc": checkoutLabel, "return_auth": returnAuth, "return_decl": returnDec, "return_can": returnCan, "bill_fname": billFname, "bill_sname": billSname, "bill_addr1": billAddr1, "bill_city": billCity, "bill_region": billRegion, "bill_country": billCountry, "bill_zip": billZip, "bill_email": billEmail, "ivp_lang": "en", "ivp_cart": checkoutLabel, "ivp_trantype": "Sale", "ivp_tranclass": "ecom", "delv_addr1": delivrAddr1, "delv_addr2": delivrAddr2, "delv_addr3": delivrAddr3, "delv_city": delivrCity, "delv_region": delivrRegion, "delv_country": delivrCountry, "applepay_enc_version": applepay_enc_version, "applepay_enc_paydata": applepay_enc_data, "applepay_enc_paysig": applepay_enc_paysig, "applepay_enc_pubkey": applepay_enc_pubkey, "applepay_enc_keyhash": applepay_enc_keyhash, "applepay_tran_id": applepay_tran_id, "applepay_card_desc": applepay_card_desc, "applepay_card_scheme": applepay_card_scheme, "applepay_card_type": applepay_card_type, "applepay_tran_id2": applepay_tran_id2, "integ_id": "86876"]  as [String : Any];
        
        
        var payData = [applePayEncData]()
        
        payData.append(.init(applepay_enc_pubkey: applepay_enc_pubkey))

        //let jd = try! JSONEncoder().encode(applepay_enc_pubkey)
        //let js = String(data: jd, encoding: .utf8)

        print("emphermelkey    " + applepay_enc_pubkey)
        
        var payData1 = [applePayEncData1]()
        
        payData1.append(.init(applepay_enc_keyhash: applepay_enc_keyhash))
        
        
//        let jd1 = try! JSONEncoder().encode(applepay_enc_keyhash)
//        let js1 = String(data: jd1, encoding: .utf8)
//        
//        
//        var payData2 = [applePayEncData2]()
//        
//        payData2.append(.init(applepay_enc_data: applepay_enc_data))
//        
//        
//        let jd2 = try! JSONEncoder().encode(applepay_enc_data)
//        let js2 = String(data: jd2, encoding: .utf8)
//        
//        var payData3 = [applePayEncData3]()
//        
//        payData3.append(.init(applepay_enc_paysig: applepay_enc_paysig))
//        
//        
//        let jd3 = try! JSONEncoder().encode(applepay_enc_paysig)
//        let js3 = String(data: jd3, encoding: .utf8)
//        
        
        
        
        
        
        let messageDictionary : [String: Any] = [ "customer": [ "name": ["forenames" : custName, "surname": custSurN],  "email": billEmail, "address": ["line1": billAddr1, "country": countryCode, "city": billCity], "phone": custPhone],  "store": storeId, "authkey": authKey, "split_id": split_id, "tran": ["id": storeCartID, "class": "ecom", "type": "sale", "description": trxDesc, "amount": payableAmount, "test": apiTest, "currency": currency, "method": "applepay"], "applepay": ["token": ["paymentData": ["header": ["transactionId": applepay_tran_id, "ephemeralPublicKey": applepay_enc_pubkey, "publicKeyHash": applepay_enc_keyhash], "data": applepay_enc_data, "signature": applepay_enc_paysig, "version": applepay_enc_version], "transactionIdentifier": applepay_tran_id2, "paymentMethod": ["network": applepay_card_scheme, "type": applepay_card_type, "displayName": applepay_card_desc]]]]
        
        
        do {
            
            var queryCharSet = NSCharacterSet.urlQueryAllowed
            queryCharSet.remove(charactersIn: "+&")
            
            //let escapedAddress = messageDictionary.addingPercentEncoding(withAllowedCharacters: queryCharSet)!
            
            let jsonData = try JSONSerialization.data(withJSONObject: messageDictionary, options: .prettyPrinted)
            // create post request
            let url = URL(string: getApiUrl)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            /*request.httpBody = messageDictionary.map { key, value in
               let keyString = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
               let valueString = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
               return keyString + "=" + valueString
            }.joined(separator: "&").data(using: .utf8)*/
            
            //let postData = jsonData.data(using: String.Encoding.ascii, allowLossyConversion: true)!
            
            request.httpBody = jsonData
            
            let postLength = String(format: "%d", jsonData.count)
            
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            //request.httpBody = json.data(using: .utf8)
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request as URLRequest) {data,response,error in
                let httpResponse = response as? HTTPURLResponse
                
                if (error != nil) {
                    print("Result error ->\(String(describing: error))")
                    
                } else {
                    print(httpResponse as Any)
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        
                        print("Result -> \(String(describing: result))");
                        print("try prrint -> \(String(describing: result?["transaction"]))");
                        
                        self.displayDefaultAlert(title: "Apple pay", message:"\(String(describing: result?["transaction"]))")
                        //print(result?["d"]?[0]?["CompanyDimension"]);

                    } catch {
                        
                        print("Error -> \(error)");
                        let alert = UIAlertController(title: "Alert", message: "Error ...", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        //self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
                DispatchQueue.main.async {
                    //Update your UI here
                        let alert = UIAlertController(title: "Alert", message: "Error in api...", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                }
            }
            dataTask.resume()
            //return task
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    // MARK: - Pickerview update
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return shoeData.count
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return shoeData[row].name
        
        return "sdf"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let priceString = String(format: "%.02f", shoeData[row].price)
        //priceLabel.text = "Price = $\(priceString)"
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
       

        let data = payment.token.paymentData
        
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        
        //print(json)
        
        let signature = json?["signature"] as! String
        let dta = json?["data"] as! String

        let version = json?["version"] as! String

                //print("\(version)")
        
        var publicKeyHash: String = "";
        var transactionId: String = "";
        var wrappedKey: String = "";

        if let value = json as? [String:AnyObject]{
            if let dict = value["header"] as? NSDictionary{
                publicKeyHash = dict.value(forKey: "publicKeyHash") as! String
                transactionId = dict.value(forKey: "transactionId") as! String
            wrappedKey = dict.value(forKey: "ephemeralPublicKey") as! String
                print(publicKeyHash)
            }
        }
        
        //print(payment.token.paymentMethod.type)
        //print(payment.token.paymentMethod.network?.rawValue)
        
        //print("keyhash value is $publicKeyHash")
        
        doSendPaymentData(transactionIdentifier: payment.token.transactionIdentifier, applepay_enc_version: version, applepay_enc_data: dta, applepay_enc_paysig: signature,  applepay_enc_pubkey: wrappedKey, applepay_enc_keyhash: publicKeyHash, applepay_tran_id: transactionId,  applepay_card_desc: payment.token.paymentMethod.displayName!, applepay_card_scheme: "credit", applepay_card_type: payment.token.paymentMethod.network!.rawValue, applepay_tran_id2: payment.token.transactionIdentifier);
        
        //displayDefaultAlert(title: "Apple Pay", message: "The Apple Pay transaction was initiated. Transaction identifier is " + payment.token.transactionIdentifier)
    }
}

extension String {
    var encoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

extension ViewController:TelrControllerDelegate{
    
    
    //Mark:- This method will be called when user clicks on back button
    func didPaymentCancel() {
        print("didPaymentCancel")
        
    }
    
    //Mark:- This method will be called when the payment is completed successfully
    func didPaymentSuccess(response: TelrResponseModel) {
        
        print("didPaymentSuccess")
           
        print("month \(String(describing: response.month))")
           
        print("year \(String(describing: response.year))")
              
        print("Trace \(String(describing: response.trace))")
        
        print("Status \(String(describing: response.status))")
        
        print("Avs \(String(describing: response.avs))")
        
        print("Code \(String(describing: response.code))")
        
        print("Ca_valid \(String(describing: response.ca_valid))")
        
        print("Card Code \(String(describing: response.cardCode))")
        
        print("Card Last4 \(String(describing: response.cardLast4))")
        
        print("CVV \(String(describing: response.cvv))")
        
        print("TransRef \(String(describing: response.transRef))")
        
        //To save the card for future transactions, you will be required to store tranRef.
        //When the customer will be attempting transaction using the previously used card tranRef will be used
        
        //self.displaySavedCard()
      
      
    }
    
    //Mark:- This method will be called when user clicks on cancel button and the
    //payment gets failed
    func didPaymentFail(messge: String) {
        print("didPaymentFail  \(messge)")
        
    }
}

extension ViewController{
    
    private func preparePaymentRequest() -> PaymentRequest{
        
        
        let paymentReq = PaymentRequest()
        
        paymentReq.key = authKey
        
        paymentReq.store = storeId
        
        paymentReq.appId = "123456789"
        
        paymentReq.appName = "TelrSDK"
        
        paymentReq.appUser = "123456"
        
        paymentReq.appVersion = "0.0.1"
        
        paymentReq.transTest = "1"//0
        
        paymentReq.transType = "paypage"
        
        paymentReq.transClass = "ecom"
        
        paymentReq.transCartid = String(arc4random())
        
        paymentReq.transDesc = "Test API"
        
        paymentReq.transCurrency = "AED"
        
        paymentReq.transAmount = "1"
        
        paymentReq.billingEmail = "jb@gmail.com"
        
        paymentReq.billingPhone = "8888888888"
        
        paymentReq.billingFName = "FirstN"
        
        paymentReq.billingLName = "LastN"
        
        paymentReq.billingTitle = "Mr"
        
        paymentReq.city = "Dubai"
        
        paymentReq.country = "AE"
        
        paymentReq.region = "Dubai"
        
        paymentReq.address = "line 1"
        
        paymentReq.zip = "414202"
        
        paymentReq.language = "en"
        paymentReq.split_id = "105"
        
        return paymentReq
        
    }
}
