//
//  AmuesementPark.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 7/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.
//

import Foundation
import AudioToolbox

// MARK: Card Generator
class Generator {
    
    enum EntrantKind {
        case classic
        case vip
        case freeChild(Int, Int, Int)
        case foodServices(Name, Address)
        case maintenance(Name, Address)
        case rideServices(Name, Address)
        case manager(Name, Address)
    }
    
    // MARK: Generating Card
    static func generateBadge(entrantKind kind: EntrantKind) -> Entrant {
        
        do {
            let entrant: Entrant
            switch kind {
            case .classic : return ClassicGuest()
            case .vip: return VIPGuest()
            case .freeChild(let month, let day, let year): entrant =  try FreeChildGuest(month: month, day: day, year: year)
            case .foodServices(let name, let address): entrant = FoodServicesEmployee(name: name, address: address)
            case .maintenance(let name, let address): entrant = MaintenanceEmployee(name: name, address: address)
            case .rideServices(let name, let address): entrant = ServicesEmployee(name: name, address: address)
            case .manager(let name, let address): entrant = Manager(name: name, address: address)
            }
            return entrant
        } catch InputError.invalidDateOfbirth {
            //in the future will be handled with an alert
            fatalError("\(InputError.invalidDateOfbirth)")
        } catch let error {
            fatalError("\(error)")
        }
    }
}


// MARK: Card Reader
class Reader {
    enum Privilege {
        
        case amusementArea, kitchenArea, rideControlArea, maintenanceArea, officeArea
        case allRides, skipRidesQueue
        case foodDiscount, merchandiseDiscount
    }
    
    
    
    // MARK: Accress to AmusementPark
    enum Access {
        case granted
        case denied
        //Sound
        var filename: String {
            switch ( self ) {
            case .granted: return "AccessGranted"
            case .denied: return "AccessDenied"
            }
        }
        
        var fileUrl: URL {
            let path = Bundle.main.path(forResource: self.filename, ofType: "wav")!
            return  URL(fileURLWithPath: path) as URL
        }
    }
    
    static var sound: SystemSoundID = 0
    
    static func check(_ entrant: Entrant, accessToPrivilege access: Privilege) -> Bool {
        
        // Entrants B'day Check.
        if let birthdayEntrant = entrant as? Dateable {
            if Date.isBirthdayToday(birthdayEntrant.dateOfbirth) {
                print("Happy Birthday!")
            }
        }
        var accessGranted: Bool = false
        
        switch access {
        // Areas Access
        case .amusementArea: accessGranted = entrant is AmusementAreaAccessible
        case .kitchenArea: accessGranted = entrant is KitchenAreaAccessible
        case .rideControlArea: accessGranted = entrant is RideControlAreaAccessible
        case .maintenanceArea: accessGranted = entrant is MaintenanceAreaAccessible
        case .officeArea: accessGranted = entrant is OfficeAreaAccessible
            
        // Ride Access
        case .allRides: accessGranted = entrant is AllRidesAcesssible
        case .skipRidesQueue: accessGranted = entrant is SkipAllRidesQueueAcessible
            
        // Discount Access
        case .foodDiscount: accessGranted = entrant is FoodDiscountAccessible
        case .merchandiseDiscount: accessGranted = entrant is MerchandiseDiscountAccessible
        }
        
        // Printing + Sound
        if accessGranted {
            print("Access to \(access) is granted")
            playSound(Access.granted.fileUrl)
        } else {
            print("Access to \(access) is denied")
            playSound(Access.denied.fileUrl)
        }
        return accessGranted
    }
    
    
    // MARK: Swipe for Ride
    static func checkSwipeForRide(_ entrant: Entrant) -> Bool {
        guard Reader.check(entrant, accessToPrivilege: .allRides) else {
            return false
        }
        if entrant.delegate.hasRecentlySwipedForRide() == true {
            print("Wait atleast 5 minutes between 2 rides")
            return false
        } else {
            print("Enjoy")
            return true
        }
    }
    
    // MARK: Swipe for Food
    static func checkSwipeForFoodDiscount(_ entrant: Entrant) -> (Bool, Int) {
        guard Reader.check(entrant, accessToPrivilege: .foodDiscount) else {
            return (false, 0)
        }
        let entrantFoodDiscount = entrant as! FoodDiscountAccessible
        return (true, entrantFoodDiscount.foodDiscount)
    }
    
    // MARK: Swipe for Merchandise
    static func checkSwipeForMerchandiseDiscount(_ entrant: Entrant) -> (Bool, Int) {
        guard Reader.check(entrant, accessToPrivilege: .merchandiseDiscount) else {
            return (false, 0)
        }
        let entrantMerchandiseDiscount = entrant as! MerchandiseDiscountAccessible
        return (true, entrantMerchandiseDiscount.merchandiseDiscount)
    }
    
    // Sound Support
    static func playSound(_ url: URL) {
        AudioServicesCreateSystemSoundID(url as CFURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
}

