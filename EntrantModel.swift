//
//  EntrantModel.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 7/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.
//

import Foundation

//
// MARK: Implementation = Check for B'day.
extension Date {
    static func numYearsOld(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date as Date, to: Date() as Date).year!
    }
    static func isBirthdayToday(_ eventDate: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let todayComponents = calendar.dateComponents([.month, .day], from: today as Date)
        let eventComponents = calendar.dateComponents([.month, .day], from: eventDate as Date)
        
        return todayComponents.month == eventComponents.month && todayComponents.day == eventComponents.day
    }
}

// Typealias for Percent
typealias Percent = Int


// MARK: Information Section = First and Last name
struct Name {
    let firstName: String
    let lastName: String
    
    init(firstName: String, lastName: String) throws {
        if firstName.isEmpty {
            throw InputError.emptyInput(required: "First Name is required")
        }
        if lastName.isEmpty  {
            throw InputError.emptyInput(required: "Last Name is required")
        }
        
        self.firstName = firstName
        self.lastName = lastName
    }
}


// MARK: Information Section = Address details including Social security number.
struct Address {
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: Int
    let socialSecurityNumber: String
    
    
    init(streetAddress: String, city: String, state: String, socialSecurityNumber: String, zipCode: Int) throws {
        if streetAddress.isEmpty {
            throw InputError.emptyInput(required: "Street Address is required")
        }
        
        if city.isEmpty {
            throw InputError.emptyInput(required: "City is required")
        }
        
        if state.isEmpty {
            throw InputError.emptyInput(required: "State  is required")
        }
        if socialSecurityNumber.isEmpty {
            throw InputError.emptyInput(required: "Social Security Number is Required")
        }
        
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.socialSecurityNumber = socialSecurityNumber
        
    }
}


// MARK: Error

enum InputError: Error {
    case emptyInput(required: String)
    case invalidDateOfbirth
    case tooOldForDiscount
}


// MARK: Entrant Information

protocol Nameable {
    var name: Name { get }
}

protocol Addressable {
    var address: Address { get }
}

protocol Dateable {
    var dateOfbirth: Date { get }
}



// MARK: Area Privileges

protocol AreaAccessible {}

protocol AmusementAreaAccessible: AreaAccessible {}
protocol KitchenAreaAccessible: AreaAccessible {}
protocol RideControlAreaAccessible: AreaAccessible {}
protocol MaintenanceAreaAccessible: AreaAccessible {}
protocol OfficeAreaAccessible: AreaAccessible {}



// MARK: Ride Access

protocol RideAccessible {}

protocol AllRidesAcesssible: RideAccessible {}
protocol SkipAllRidesQueueAcessible: RideAccessible {}


// MARK: Discount Access

protocol DiscountAccessible {}

protocol FoodDiscountAccessible: DiscountAccessible {
    var foodDiscount: Percent { get }
}

protocol MerchandiseDiscountAccessible: DiscountAccessible {
    var merchandiseDiscount: Percent { get }
}


// MARK: Entrants

protocol Entrant: AmusementAreaAccessible {
    var delegate: EntrantDelegate { get set }
}

protocol Guest: Entrant, AllRidesAcesssible {}
protocol HourlyEmployee: Entrant, Nameable, Addressable {}
protocol ContractEmployee: HourlyEmployee, FoodDiscountAccessible, MerchandiseDiscountAccessible, AllRidesAcesssible {}
protocol EntrantDelegate {
    func hasJustSwipedForRide()
    func hasRecentlySwipedForRide() -> Bool // If swiped too early -> True
}


// MARK: Entrant Types
class EntrantType: Entrant {
    var delegate: EntrantDelegate = EntrantDelegateType()
}


// MARK: Guest Types
class GuestType: EntrantType, Guest {}

// Classic Guest
class ClassicGuest: GuestType {}

// Vip Guest
class VIPGuest: GuestType, SkipAllRidesQueueAcessible, FoodDiscountAccessible, MerchandiseDiscountAccessible {
    let foodDiscount: Percent = 10
    let merchandiseDiscount: Percent = 20
}

// Free Child Guest and Error
class FreeChildGuest: GuestType, Dateable {
    var dateOfbirth: Date
    init (month: Int, day:  Int, year: Int) throws {
        guard let birthDay = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
            throw InputError.invalidDateOfbirth
        }
        
        if Date.numYearsOld(birthDay) >= 5 {
            throw InputError.tooOldForDiscount
        }
        dateOfbirth = birthDay
    }
}


// MARK: Employee Types
// Hourly Employee
class HourlyEmployeeType: EntrantType, HourlyEmployee {
    let name: Name
    let address: Address
    var foodDiscount: Percent = 15
    var merchandiseDiscount: Percent = 25
    
    init(name: Name, address: Address) {
        self.name = name
        self.address = address
    }
}

// hourly Contractor Employee
class ContractEmployeeType: HourlyEmployeeType, ContractEmployee {
    override init(name: Name, address: Address) {
        super.init(name: name, address: address)
        self.foodDiscount = 25
    }
}

class FoodServicesEmployee: HourlyEmployeeType, KitchenAreaAccessible {}
class ServicesEmployee: HourlyEmployeeType, RideControlAreaAccessible {}
class MaintenanceEmployee: HourlyEmployeeType, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible {}
class Manager: ContractEmployeeType, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible, OfficeAreaAccessible {}



// MARK: Delegates
class EntrantDelegateType: EntrantDelegate {
    var lastTimeSwipedForRide: Date?
    let timeToWait: Double = 300.0
    
    func hasJustSwipedForRide() {
        lastTimeSwipedForRide = Date()
        print("creating new date access..")
    }
    
    func hasRecentlySwipedForRide() -> Bool {
        let newSwipe = Date()
        
        guard let lastTime: Date = lastTimeSwipedForRide else {
            print("This is your first Ride!")
            hasJustSwipedForRide()
            return false
        }
        if newSwipe.timeIntervalSince(lastTime) < timeToWait {
            return true
        } else {
            hasJustSwipedForRide()
            return false
        }
    }
}

