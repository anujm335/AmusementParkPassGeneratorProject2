//
//  AmuesementPark.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 7/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit


//Badge Generator
class Generator {
    enum PersonKind {
        case classic
        case vip
        case freeChild(Int?, Int?, Int?)
        case senior(Name, Int?, Int?, Int?)
        case seasonPass(Name, Address)
        case hourlyEmployee(Name, Address, HourlyEmployeeType)
        case manager(Name, Address)
        case contractor(Name, Address, ContractorProject)
        case vendor(Name, Address, Int?, Int?, Int?, VendorCompany)
    }
    
    
    
// Generate Badge
    static func generateBadge(personKind kind: PersonKind) throws -> Person {
        let person: Person
        switch kind {
        case .classic : return ClassicGuest() 
        case .vip: return VIPGuest()
            
        case .freeChild(let month, let day, let year): guard let m: Int = month, let d: Int = day, let y: Int = year else {
            throw InputError.requiredFieldIsNil
            }
            person = try FreeChildGuest(month: m, day: d, year: y)
            
        case .senior(let name, let month, let day, let year): guard let m: Int = month, let d: Int = day, let y: Int = year else {
            throw InputError.requiredFieldIsNil
            }
            person = try SeniorGuest(name: name, month: m, day: d, year: y)
        case .seasonPass(let name, let address): person = SeasonPassGuest(name: name, address: address)
        case .hourlyEmployee(let name, let address, let type): person = HourlyEmployeeFactory.createHourlyEmployee(withType: type, name: name, address: address)
        case .manager(let name, let address): person = Manager(name: name, address: address)
        case .contractor(let Name, let address, let type): person = ContractEmployeeFactory.createContractEmployee(withType: type, name: Name, address: address)
        case .vendor(let name, let address, let month, let day, let year, let type): guard let m: Int = month, let d: Int = day, let y: Int = year else {
            throw InputError.requiredFieldIsNil
            }
            person = try VendorTypeFactory.createVendorType(withType: type, name: name, address: address, month: m, day: d, year: y)
        }
        return person
    }
}



// Reader
class Reader {
    enum Privilege {
        case amusementArea, kitchenArea, rideControlArea, maintenanceArea, officeArea
        case allRides, skipRidesQueue
        case foodDiscount, merchandiseDiscount
    }
    
// Access
    
    enum Access {
        case granted
        case denied
        // Sound Alerts
        var filename: String {
            switch ( self ) {
            case .granted: return "AccessGranted"
            case .denied: return "AccessDenied"
            }
        }
        
        //The url of the file to play
        var fileUrl: URL {
            let path = Bundle.main.path(forResource: self.filename, ofType: "wav")!
            return  URL(fileURLWithPath: path) as URL
        }
    }
    
    static var sound: SystemSoundID = 0
    static func check(_ person: Person, accessToPrivilege access: Privilege) -> Bool {
        
        // Check BDay
        if let bDay = person.delegate?.dateOfBirth {
            if Date.isBirthdayToday(bDay) {
                print("Happy Birthday!")
            }
        }
        
        var accessGranted: Bool = false
        switch access {
        // Area Access
        case .amusementArea: accessGranted = person is AmusementAreaAccessible
        case .kitchenArea: accessGranted = person is KitchenAreaAccessible
        case .rideControlArea: accessGranted = person is RideControlAreaAccessible
        case .maintenanceArea: accessGranted = person is MaintenanceAreaAccessible
        case .officeArea: accessGranted = person is OfficeAreaAccessible
            
        // Ride Access
        case .allRides: accessGranted = person is AllRidesAcesssible
        case .skipRidesQueue: accessGranted = person is SkipAllRidesQueueAcessible
            
        // Discount Access
        case .foodDiscount: accessGranted = person is FoodDiscountAccessible
        case .merchandiseDiscount: accessGranted = person is MerchandiseDiscountAccessible
        }
        if accessGranted {
            print("Access to \(access) is granted")
            playSound(Access.granted.fileUrl)
        } else {
            print("Access to \(access) is denied")
            playSound(Access.denied.fileUrl)
        }
        return accessGranted
    }
    
    
    
// Swipe for Ride
    static func checkSwipeForRide(_ entrant: Entrant) -> Bool {
        guard Reader.check(entrant, accessToPrivilege: .allRides) else {
            return false
        }
        if entrant.delegate?.hasRecentlySwipedForRide() == true {
            print("Wait at least 5 minutes between 2 rides")
            return false
        } else {
            print("Go on! have fun!")
            return true
        }
    }
    
    
// Swipe for Discount
    static func checkSwipeForFoodDiscount(_ person: Person) -> (Bool, Int) {
        if Reader.check(person, accessToPrivilege: .foodDiscount) {
            guard let delegate: PersonDelegate = person.delegate, let discount: Percent = delegate.foodDiscount else {
                return (false, 0)
            }
            return (true, discount)
        }
        return (false, 0)
    }
    
    
// Swipe for Merchandise Discount
    static func checkSwipeForMerchandiseDiscount(_ person: Person) -> (Bool, Int) {
        if Reader.check(person, accessToPrivilege: .merchandiseDiscount) {
            guard let delegate: PersonDelegate = person.delegate, let discount: Percent = delegate.merchandiseDiscount else {
                return (false, 0)
            }
            return (true, discount)
        }
        return (false, 0)
    }
    
// Sound Support
    static func playSound(_ url: URL) {
        AudioServicesCreateSystemSoundID(url as CFURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
}
























