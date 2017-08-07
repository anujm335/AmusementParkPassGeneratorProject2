//
//  ViewController.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 7/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Entities
        let nameDefault: Name
        let addressDefault: Address
        let dayDefault: Int = 13
        let monthDefault: Int = 7
        let yearDefault: Int = 2017
        
        
        do {
            nameDefault = try Name(firstName: "Name", lastName: "LastName")
            addressDefault = try Address(streetAddress: "Street no. and name", city: "City", state: "State", socialSecurityNumber: "SSN000", zipCode: 1989)
        } catch let error {
            fatalError("\(error)")
        }
        
        let classic = generateBadge(entrantKind: .classic)
        let VIP = generateBadge(entrantKind: .vip)
        let child = generateBadge(entrantKind: .freeChild(monthDefault, dayDefault, yearDefault))
        let manager = generateBadge(entrantKind: .manager(nameDefault, addressDefault))
        
        
        // MARK: Testing
        print("")
        
        print("Classic Guest")
        print("Food Discount: \(swipeForFoodDiscount(classic).0) Percentage: \(swipeForFoodDiscount(classic).1) ")
        
        print("")
        
        print("VIP guest")
        print("Percentge: \(swipeForMerchandiseDiscount(VIP).1)")
        
        print("")
        
        print("Free Child Guest")
        let _ = scan(child, checkPrivilege: .skipRidesQueue)
        
        print("")
        
        print("Manager")
        let _ = scan(manager, checkPrivilege: .officeArea)
        
        print("")
        
        let _ = swipeForRide(classic)
        
        print("")
        
        let _ = swipeForRide(classic)
        
        print("")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateBadge(entrantKind kind: Generator.EntrantKind) -> Entrant {
        return Generator.generateBadge(entrantKind: kind)
    }
    
    // MARK: checkings
    
    // Privilage check
    func scan(_ entrant: Entrant, checkPrivilege accessTo: Reader.Privilege) -> Bool {
        return Reader.check(entrant, accessToPrivilege: accessTo)
    }
    
    // Swipe for Ride check
    func swipeForRide(_ entrant: Entrant) -> Bool {
        return Reader.checkSwipeForRide(entrant)
    }
    
    // Food discount Check
    func swipeForFoodDiscount(_ entrant: Entrant) -> (Bool, Int) {
        return Reader.checkSwipeForFoodDiscount(entrant)
    }
    
    // Merchandise discount check
    func swipeForMerchandiseDiscount(_ entrant: Entrant) -> (Bool, Int) {
        return Reader.checkSwipeForMerchandiseDiscount(entrant)
    }
}








































