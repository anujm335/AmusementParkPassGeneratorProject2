//
//  BadgeController.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 8/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.


import UIKit

class BadgeController: UIViewController {

    var person: Person?
    var delegate: PersonDelegate?
    
    
// Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var ridesPrivilegeLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchandiseDiscountLabel: UILabel!
    @IBOutlet weak var testResultLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person: Person = person {
            delegate = (person.delegate)!
        }
        getInfo(delegate: delegate!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
// Actions
    @IBAction func areaAccessAction(_ sender: UIButton) {
        let person = (delegate?.person)!
        var result: String = "Areas Permitted: "
        testResultLabel.backgroundColor = UIColor.green
        
        if Reader.check(person, accessToPrivilege: .amusementArea) {
            result.append("Amusement, ")
            testResultLabel.backgroundColor = UIColor.green
        }
        if Reader.check(person, accessToPrivilege: .kitchenArea) {
            result.append("Kitchen, ")
        }
        if Reader.check(person, accessToPrivilege: .maintenanceArea) {
            result.append("Maintenance, ")
        }
        if Reader.check(person, accessToPrivilege: .rideControlArea) {
            result.append("RideControl, ")
        }
        if Reader.check(person, accessToPrivilege: .officeArea) {
            result.append("Office, ")
        }
        if result == "Areas Permitted: " {
            result = "Areas Access Denied "
            testResultLabel.backgroundColor = UIColor.red
        }
        testResultLabel.text = result
    }
    
    
    
    @IBAction func rideAccessAction(_ sender: UIButton) {
        if Reader.check((delegate?.person)!, accessToPrivilege: .allRides) {
            testResultLabel.text = "Access Granted"
            testResultLabel.backgroundColor = UIColor.green
            if Reader.check((delegate?.person)!, accessToPrivilege: .skipRidesQueue) {
                testResultLabel.text = "Access Granted\nCan Skip Queues"
            }
        } else {
            testResultLabel.text = "Access Denied"
            testResultLabel.backgroundColor = UIColor.red
        }
    }
    
    
    
    @IBAction func discountAccess(_ sender: AnyObject) {
        let foodDiscount = Reader.checkSwipeForFoodDiscount((delegate?.person)!)
        let merchandiseDiscount = Reader.checkSwipeForMerchandiseDiscount((delegate?.person)!)
        
        if merchandiseDiscount.0 && foodDiscount.0 {
            testResultLabel.text = "Food Discount: \(foodDiscount.1)%\nMerchandise Discount: \(merchandiseDiscount.1)%"
            testResultLabel.backgroundColor = UIColor.green} else if foodDiscount.0 {
            testResultLabel.text = "Food Discount: \(foodDiscount.1)%"
            testResultLabel.backgroundColor = UIColor.green
        } else if merchandiseDiscount.0 {
            testResultLabel.text = "Merchandise Discount: \(merchandiseDiscount.1)%"
            testResultLabel.backgroundColor = UIColor.green
        } else {
            testResultLabel.text = "Access Denied"
            testResultLabel.backgroundColor = UIColor.red
        }
    }
    
    
    
    @IBAction func newPassAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
// Functions
    func getInfo(delegate: PersonDelegate) {
        if let name: Name = delegate.name {
            nameLabel.text = "\(name.firstName) \(name.secondName)"
        } else {
            nameLabel.text = "John Smith"
        }
        
        if let description: String = delegate.description {
            passTypeLabel.text = "\(description)"
        } else {
            nameLabel.text = "Unknown"
        }
        
        if delegate.person is AllRidesAcesssible {
            ridesPrivilegeLabel.text = "\u{2022} Unlimited Rides"
        } else if delegate.person is SkipAllRidesQueueAcessible {
            ridesPrivilegeLabel.text = "\u{2022} Unlimited Rides, can skip Queues"
        } else {
            ridesPrivilegeLabel.text = "\u{2022} No Rides Access"
        }
        
        if let foodDiscount: Percent = delegate.foodDiscount {
            foodDiscountLabel.text = "\u{2022} \(foodDiscount) Food Discount"
        } else {
            foodDiscountLabel.text = "\u{2022} No Food Discount"
        }
        
        if let merchandiseDiscount: Percent = delegate.merchandiseDiscount {
            merchandiseDiscountLabel.text = "\u{2022} \(merchandiseDiscount) Merchandise Discount"
        } else {
            merchandiseDiscountLabel.text = "\u{2022} No Merchandise Discount"
        }
        
        if let name: Name = delegate.name {
            if name.firstName == "John" && name.secondName == "Smith" {
                avatarImg.image = #imageLiteral(resourceName: "FaceImageAsset")
            } else {
                avatarImg.image = #imageLiteral(resourceName: "FaceImageAsset")
            }
        }
    }
}







