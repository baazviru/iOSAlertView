//
//  ViewController.swift
//  iOSAlertView
//
//  Created by mac on 20/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapView))
        gesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(gesture)
        
    }
    
    @IBAction func showAlert(_ sender:UIButton){
        
       let msg  = "Message discription , like loreum upsum is a dummy content Message discription , like loreum upsum is a dummy content."
      //  iOSAlertController().Alert(title: "Message", message: msg, animationType: .zoomIn, statusType: .success)
       
      
       iOSAlertView().showAlert(title: "Title", message: msg, animationType: .zoomIn, status: false)
        
    }
    
    
    @objc func didTapView(_ sender:UITapGestureRecognizer){
        likeView(sender)
    }
}

extension UIViewController{
    
    func likeView(_ sender:UITapGestureRecognizer){
        
        if sender.location(in: self.view).x < 40.0 {
            return
        }
        
        let img = UIImageView()
        img.image = UIImage(named: "h2")
        let location = sender.location(in: self.view)
        img.frame.origin = location
        img.frame.origin.x = location.x - 40
        img.frame.origin.y = location.y - 40
        img.frame.size = CGSize(width: 80.0, height: 80.0)
        
        img.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.addSubview(img)
            img.transform = .identity
        }, completion: {(n)in
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            UIView.animate(withDuration: 0.5, animations: {
                img.frame.origin.y = img.frame.origin.y - 100
                img.frame.origin.x = img.frame.origin.x - 35
                img.frame.size = CGSize(width: 150.0, height: 150.0)
                img.alpha = 0.0
            }) { (isTru) in
                img.removeFromSuperview()
            }
        }
    }
    
}
