//
//  ClsHomeViewController.swift
//  challengeLiverpool
//
//  Created by Apsi on 11/09/18.
//  Copyright © 2018 rramossa. All rights reserved.
//

import UIKit
import MapKit

class ClsHomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var loWidth:Double = Double(UIScreen.main.bounds.size.width)
    var loHeigth:Double = Double(UIScreen.main.bounds.size.height)
    var loFont:UIFont = UIFont.systemFont(ofSize: 17)
    var loFont2:UIFont = UIFont(name: "HelveticaNeue-Medium", size: 19)!
    var loFont3:UIFont = UIFont(name: "HelveticaNeue-Bold", size: 19)!
    var poLabel: UILabel?
    var poSearch: UITextField?
    var poBtnNueva: UIButton?
    var poBtnOk: UIButton?
    let poTable = UITableView()
    var paLstProductos = [ClsProductoDTO]()
    var poProducto:ClsProductoDTO?
    var poBtnHistorial: UIButton?
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createElements()
        
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    func createElements(){
        
        
        //Text Latitud
        
        poSearch = UITextField(frame: CGRect(x: 10,
                                              y: 70,
                                              width: (loWidth)-20,
                                              height: 40))
        poSearch?.textAlignment = NSTextAlignment.center
        poSearch?.textColor = UIColor.black
        poSearch?.font = loFont
        poSearch?.backgroundColor = UIColor(red: 232/255, green: 225/255, blue: 225/255, alpha: 1)
        poSearch?.placeholder = "Buscar"
        poSearch?.borderStyle = UITextBorderStyle.roundedRect
        poSearch?.autocapitalizationType = UITextAutocapitalizationType.none
        poSearch?.tag = 1
        //poSearch?.keyboardType = UIKeyboardType.numbersAndPunctuation
        poSearch?.autocorrectionType = .no
        poSearch?.delegate = self
        poSearch?.tintColor = .black
        poSearch?.returnKeyType = .search
        self.view.addSubview(poSearch!)
        
        
        poTable.frame = CGRect(x: 0, y: 110, width: loWidth, height: (loHeigth - 110))
        //tableView.style = UITableViewStyle.
        poTable.register(ClsCellProductos.self, forCellReuseIdentifier: "Cell")
        poTable.allowsSelection = false
        poTable.delegate = self
        poTable.dataSource = self
        poTable.allowsSelection = true
        view.addSubview(poTable)
    }
    
    @IBAction func actionHistorial(_ sender: Any) {
        if !(self.view.viewWithTag(100) != nil) {
            
            
            let loHistorialView: UIView = UIView(frame: CGRect(x: 0,
                                                               y: (0.10 * loHeigth),
                                                               width: loWidth,
                                                               height: (0.90 * loHeigth)))
            loHistorialView.backgroundColor = .white
            //loCanjearView.alpha = 0.5
            loHistorialView.tag = 100
            loHistorialView.isUserInteractionEnabled = true
            self.view.addSubview(loHistorialView)
            
            //Question
            poLabel = UILabel(frame: CGRect(x: 0,
                                            y: 0,
                                            width: loWidth,
                                            height: (0.07 * loHeigth)))
            poLabel?.textAlignment = NSTextAlignment.center
            poLabel?.textColor = UIColor.black
            poLabel?.text = "Busquedas recientes"
            poLabel?.adjustsFontSizeToFitWidth = true
            poLabel?.font = loFont2
            loHistorialView.addSubview(poLabel!)
            
            
            
            if(UserDefaults.standard.object(forKey: "lstHistorial") == nil ){
                
                poLabel = UILabel(frame: CGRect(x: 0,
                                                y: 0,
                                                width: loWidth,
                                                height: (0.14 * loHeigth)))
                poLabel?.textAlignment = NSTextAlignment.center
                poLabel?.textColor = UIColor.black
                poLabel?.text = "No existen"
                poLabel?.adjustsFontSizeToFitWidth = true
                poLabel?.font = loFont
                loHistorialView.addSubview(poLabel!)
            }else{
                let lstHistorial = UserDefaults.standard.object(forKey: "lstHistorial") as! [String]
                
                var lsText:String = ""
                for  i in 0 ..< lstHistorial.count{
                    let lodetalle = lstHistorial[i] as! String
                    lsText = lsText + " - \(lodetalle) \n"
                }
                
                let poLabel = UITextView(frame: CGRect(x: 20.0,
                                                       y: 80,
                                                       width: loWidth,
                                                       height: (0.74 * loHeigth) - (0.15 * loHeigth)))
                poLabel.text = lsText
                poLabel.textAlignment = NSTextAlignment.justified
                poLabel.font = loFont2
                loHistorialView.addSubview(poLabel)
                
                
            }
            
            poBtnOk = UIButton(frame: CGRect(x: (0.1 * loWidth),
                                             y: (0.74 * loHeigth),
                                             width: (0.8 * loWidth),
                                             height: (0.06 * loHeigth)))
            poBtnOk?.setTitle("OK", for: .normal)
            poBtnOk?.titleLabel?.font = loFont3
            poBtnOk?.layer.borderWidth = CGFloat (0.6)
            poBtnOk?.layer.borderColor = UIColor.darkGray.cgColor
            poBtnOk?.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 152/255, alpha: 1)
            poBtnOk?.addTarget(self, action:#selector(self.actionRemove), for: .touchUpInside)
            poBtnOk?.layer.cornerRadius = 20.0
            poBtnOk?.layer.masksToBounds = true
            loHistorialView.addSubview(self.poBtnOk!)
        }
    }
    
    
    @objc func actionRemove(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return paLstProductos.count
    }
    
    func mod (left:CGFloat, right:CGFloat) -> CGFloat {
        return left.truncatingRemainder(dividingBy: right)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClsCellProductos
        let liId = (indexPath as NSIndexPath).row
        
        if (mod(left: CGFloat(liId),  right: 2.0)) != 0 {
            cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
        
        if paLstProductos.count > 0 {
            let loProducto:ClsProductoDTO = paLstProductos[liId]
            
            cell.lblTitulo.text = loProducto.psNombre
            cell.lblMarca.text = "MARCA: \(loProducto.psMarca)"
            cell.lblPrecio.text = "PRECIO: $\(loProducto.psPrecio.integerValue!)"
            
            cell.tag = (indexPath as NSIndexPath).row
            
            let url = URL(string:"\(loProducto.psImagen)")
            if UIApplication.shared.canOpenURL(url!){
                let loUrlRequest = URLRequest(url: url!)
                let configuration = URLSessionConfiguration.default
                let loSession = URLSession(configuration: configuration, delegate: self as! URLSessionDelegate, delegateQueue:OperationQueue.main)
                
                let loTask = loSession.dataTask(with: loUrlRequest, completionHandler:{
                    (data, response, error) in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        if data.count > 200 {
                            cell.imgNegocio.image = UIImage(data: data)!
                            
                        }
                    }
                })
                loTask.resume()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        poProducto = paLstProductos[indexPath.row]
        //getDetallePremio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
        if (poSearch?.text?.isEmpty)!{
            let alert =  UIAlertController(title: "Advertencia",
                                           message: "Es necesario un criterio de busqueda",
                                           preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            if ConnectionCheck.isConnectedToNetwork() {
                
                makeGetCall()
                
                
                let lsSearch = (poSearch?.text!.trimmingCharacters(in: .whitespaces))!
                
                
                if UserDefaults.standard.object(forKey: "lstHistorial") != nil{
                    
                    
                    var lstHistorial = UserDefaults.standard.object(forKey: "lstHistorial") as! [String]
                    
                    lstHistorial = lstHistorial.filter{$0 != lsSearch}
                    
                    lstHistorial.append(lsSearch)
                    UserDefaults.standard.set(lstHistorial, forKey: "lstHistorial")
                }else{
                    var lstHistorial = [String]()
                    lstHistorial.append(lsSearch)
                    UserDefaults.standard.set(lstHistorial, forKey: "lstHistorial")
                }
                
            }
        }
        
        
        textField.resignFirstResponder()
        return true
    }
        
        
        
        func makeGetCall() {
            self.paLstProductos.removeAll()
            self.poTable.reloadData()
            let lsSearch = (poSearch?.text!.trimmingCharacters(in: .whitespaces))!
           
            
            // Set up the URL request
            let lsUrl = "https://www.liverpool.com.mx/tienda/?s=\(lsSearch)&d3106047a194921c01969dfdec083925=json"
             let loEncoded = lsUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let todoEndpoint: String = loEncoded!
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            let urlRequest = URLRequest(url: url)
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            show()
            // make the request
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                // check for any errors
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                    return
                }
                // parse the result as JSON, since that's what the API provides
                do {
                    guard let loJsonAll = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    if(loJsonAll["contents"] != nil){
                        
                        let loContents = loJsonAll["contents"] as! NSArray
                        let loDictionary1 = loContents[0] as! NSDictionary
                        let loMainContent = loDictionary1["mainContent"] as! NSArray
                        
                        for  j in 0 ..< loMainContent.count{
                            let loDictionary2 = loMainContent[j] as! NSDictionary
                            if(loDictionary2["contents"] != nil){
                                let loContents2 = loDictionary2["contents"] as! NSArray
                                if loContents2.count > 0 {
                                    let loDictionary3 = loContents2[0] as! NSDictionary
                                    if(loDictionary3["records"] != nil){
                                        
                                        let loRecords = loDictionary3["records"] as! NSArray
                                        
                                        
                                        for  i in 0 ..< loRecords.count{
                                            
                                            let loDictionary4 = loRecords[i] as! NSDictionary
                                            if loDictionary4["attributes"]  != nil{
                                                let loAttributes = loDictionary4["attributes"] as! NSDictionary
                                                
                                                let loProducto = ClsProductoDTO()
                                                if(loAttributes["product.displayName"] != nil){
                                                    let loNameArray = loAttributes["product.displayName"]! as! NSArray
                                                    loProducto.psNombre = loNameArray[0] as! String
                                                }
                                                if loAttributes["product.brand"] != nil {
                                                    let loMarcaArray = loAttributes["product.brand"]! as! NSArray
                                                    loProducto.psMarca = loMarcaArray[0] as! String
                                                }
                                                if loAttributes["sku.thumbnailImage"] != nil{
                                                    let loImagenArray = loAttributes["sku.thumbnailImage"]! as! NSArray
                                                    loProducto.psImagen = loImagenArray[0] as! String
                                                }
                                                if loAttributes["sortPrice"] != nil {
                                                    let loPrecioArray = loAttributes["sortPrice"]! as! NSArray
                                                    loProducto.psPrecio = loPrecioArray[0] as! String
                                                }
                                                
                                                self.paLstProductos.append(loProducto)
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            self.activityIndicator.stopAnimating()
                                            self.container.removeFromSuperview()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                     if(self.paLstProductos.count == 0) {
                        let alert =  UIAlertController(title: "Mensaje",
                                                       message: "No se encontraron resultados",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: UIAlertActionStyle.default,
                                                      handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.container.removeFromSuperview()
                        
                        self.poTable.reloadData()
                        
                    }
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                    return
                }
            }
            task.resume()
        }
        
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show() {
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        
        ()
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        activityIndicator.startAnimating()
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    
    
}

extension String {
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
}

extension ClsHomeViewController:URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
}

