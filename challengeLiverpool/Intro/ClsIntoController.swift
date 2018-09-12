//
//  ClsIntoController.swift
//  challengeLiverpool
//
//  Created by Rafael on 11/09/18.
//  Copyright © 2018 rramossa. All rights reserved.
//


import UIKit

class ClsIntoController: UIViewController {
    
    @IBOutlet weak var imagenGif: UIImageView!
    
    var loWidth:Double = Double(UIScreen.main.bounds.size.width)
    var loHeigth:Double = Double(UIScreen.main.bounds.size.height)
    var loFont:UIFont = UIFont(name: "HelveticaNeue-Medium", size: 19)!
    var poLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagenGif.loadGif(name: "spin")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            
            if ConnectionCheck.isConnectedToNetwork() {
                
                let loClsControllerLogin : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loClsController = loClsControllerLogin.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
                self.present(loClsController, animated: false, completion: nil)
                
            }else{
                let alert =  UIAlertController(title: "Error",
                                               message: "Sin conexion a internet",
                                               preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
