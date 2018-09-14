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
        
        
        //boton registrar ---------------------------------
        poBtnHistorial = UIButton(frame: CGRect(x: (loWidth/2),
                                            y: 120,
                                            width: ((loWidth/2)-20),
                                            height: 40))
        poBtnHistorial?.setTitle("Busquedas recientes", for: .normal)
        poBtnHistorial?.titleLabel?.font = loFont
        poBtnHistorial?.layer.borderWidth = CGFloat (0.6)
        poBtnHistorial?.layer.borderColor = UIColor.darkGray.cgColor
        poBtnHistorial?.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 152/255, alpha: 1)
        poBtnHistorial?.addTarget(self, action:#selector(self.actionNueva(_:)), for: .touchUpInside)
        poBtnHistorial?.layer.cornerRadius = 20.0
        poBtnHistorial?.layer.masksToBounds = true
        self.view.addSubview(poBtnHistorial!)
        
        
        
        
        
        poTable.frame = CGRect(x: 0, y: (0.22 * loHeigth), width: loWidth, height: (loHeigth-(0.2 * loHeigth)))
        //tableView.style = UITableViewStyle.
        poTable.register(ClsCellProductos.self, forCellReuseIdentifier: "Cell")
        poTable.allowsSelection = false
        poTable.delegate = self
        poTable.dataSource = self
        poTable.allowsSelection = true
        view.addSubview(poTable)
    }
    
    
    @IBAction func actionNueva(_ sender: UIButton) {
        
        let loHistorialView: UIView = UIView(frame: CGRect(x: 0,
                                                         y: (0.10 * loHeigth),
                                                         width: loWidth,
                                                         height: (0.80 * loHeigth)))
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
        //poLabel?.backgroundColor = UIColor(red: 244/255, green: 0/255, blue: 0/255, alpha: 1)
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
            for  i in 0 ..< lstHistorial.count{
                let lodetalle = lstHistorial[i] as! String
                
                poLabel = UILabel(frame: CGRect(x: 20,
                                                y: 80,
                                                width: loWidth,
                                                height: (0.4 * loHeigth) * Double(i)/6))
                poLabel?.textAlignment = NSTextAlignment.left
                poLabel?.textColor = UIColor.black
                poLabel?.text = "- \(lodetalle)"
                poLabel?.adjustsFontSizeToFitWidth = true
                poLabel?.font = loFont
                loHistorialView.addSubview(poLabel!)
            }
            
        }
        
        
        //boton registrar ---------------------------------
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
            
            let lsSearch = (poSearch?.text!.trimmingCharacters(in: .whitespaces))!
            // Set up the URL request
            let lsUrl = "https://www.liverpool.com.mx/tienda/?s=\(lsSearch)&d3106047a194921c01969dfdec083925=json"
            let todoEndpoint: String = lsUrl
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            let urlRequest = URLRequest(url: url)
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // make the request
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                // check for any errors
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                // parse the result as JSON, since that's what the API provides
                do {
                    guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    
                    
                    let loContents = todo["contents"] as! NSArray
                    let loDictionary1 = loContents[0] as! NSDictionary
                    let loMainContent = loDictionary1["mainContent"] as! NSArray
                    let loDictionary2 = loMainContent[1] as! NSDictionary
                    let loContents2 = loDictionary2["contents"] as! NSArray
                    
                    if loContents2.count > 0 {
                        let loDictionary3 = loContents2[0] as! NSDictionary
                        let loRecords = loDictionary3["records"] as! NSArray
                        
                        
                        for  i in 0 ..< loRecords.count{
                            
                            let loDictionary4 = loRecords[i] as! NSDictionary
                            let loAttributes = loDictionary4["attributes"] as! NSDictionary
                            let loNameArray = loAttributes["product.displayName"]! as! NSArray
                            let loMarcaArray = loAttributes["product.brand"]! as! NSArray
                            let loImagenArray = loAttributes["sku.thumbnailImage"]! as! NSArray
                            let loPrecioArray = loAttributes["sortPrice"]! as! NSArray
                            
                            let loProducto = ClsProductoDTO()
                            loProducto.psNombre = loNameArray[0] as! String
                            loProducto.psMarca = loMarcaArray[0] as! String
                            loProducto.psImagen = loImagenArray[0] as! String
                            loProducto.psPrecio = loPrecioArray[0] as! String
                            
                            
                            self.paLstProductos.append(loProducto)
                        }
                        
                    } else {
                        let alert =  UIAlertController(title: "Mensaje",
                                                       message: "No se encontraron resultados",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: UIAlertActionStyle.default,
                                                      handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    
                    self.poTable.reloadData()
                    
                    
                    
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
            task.resume()
        }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

