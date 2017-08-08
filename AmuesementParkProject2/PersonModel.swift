//
//  PersonModel.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 8/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.

import Foundation

typealias Percent = Int



// MARK: Information
struct Name {
    let firstName: String
    let secondName: String
    
    init(firstName: String, secondName: String) throws {
        if firstName.isEmpty {
            throw InputError.emptyInput(required: "First Name is empty")
        }
        if secondName.isEmpty  {
            throw InputError.emptyInput(required: "Second Name is empty")
        }
        self.firstName = firstName
        self.secondName = secondName
    }
}

struct Address {
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    
    init(streetAddress: String, city: String, state: String, zipCode: String) throws {
        if streetAddress.isEmpty {
            throw InputError.emptyInput(required: "Street Address is empty")
        }
        if city.isEmpty {
            throw InputError.emptyInput(required: "City is empty")
        }
        if state.isEmpty {
            throw InputError.emptyInput(required: "State  is empty")
        }
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

enum VendorCompany: String {
    case acme, orkin, fedex, nwelectrical
    
    static func enumFromString(string: String) throws -> VendorCompany {
        guard let company: VendorCompany = VendorCompany(rawValue: string.lowercased()) else {
            throw InputError.companyIsNotInTheList
        }
        return company
    }
}

enum ContractorProject: String {
    case P1001, P1002, P1003, P2001, P2002
    
    static func enumFromString(string: String) throws -> ContractorProject {
        guard let project: ContractorProject = ContractorProject(rawValue: string) else {
            throw InputError.projectIsNotInTheList
        }
        return project
    }
}

enum HourlyEmployeeType {
    case FoodServices, Maintenance, RideServices
}



// MARK: Errors Type
enum InputError: Error {
    case unspecifiedPersonType
    case requiredFieldIsNil
    case emptyInput(required: String)
    case invalidDateOfbirth(required: String)
    case tooOldForDiscount
    case tooYoungForDiscount
    case personIsNil
    case companyIsNotInTheList
    case projectIsNotInTheList
}



// MARK: Person Information Protocols
protocol Nameable {}
protocol Addressable {}
protocol BirthDateable {}
protocol VisitDateable {}



// MARK: Area Privileges Protocols
protocol AreaAccessible {}
protocol AmusementAreaAccessible: AreaAccessible {}
protocol KitchenAreaAccessible: AreaAccessible {}
protocol RideControlAreaAccessible: AreaAccessible {}
protocol MaintenanceAreaAccessible: AreaAccessible {}
protocol OfficeAreaAccessible: AreaAccessible {}
protocol AllAreasAccessible: AmusementAreaAccessible, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible, OfficeAreaAccessible {}



// MARK: Ride Acessible Protocols
protocol RideAccessible {}
protocol AllRidesAcesssible: RideAccessible {}
protocol SkipAllRidesQueueAcessible: RideAccessible {}



// MARK: Discount Accessible Protocols
protocol DiscountAccessible {}
protocol FoodDiscountAccessible: DiscountAccessible {}
protocol MerchandiseDiscountAccessible: DiscountAccessible {}



// MARK: People Protocols

protocol Person {
    var delegate: PersonDelegate? { get set }
}
protocol Entrant: Person, AmusementAreaAccessible, AllRidesAcesssible  {}
protocol Employee: Person, Nameable, Addressable  {}
protocol Vendor: Person, Nameable, Addressable, BirthDateable, VisitDateable  {}
protocol PersonDelegate: class {
    
    var person: Person? {get set}
    var name: Name? {get set}
    var address: Address? {get set}
    var dateOfBirth: Date? {get set}
    var company: VendorCompany? {get set}
    var project: ContractorProject? {get set}
    var description: String? {get set}
    var foodDiscount: Percent? {get set}
    var merchandiseDiscount: Percent? {get set}
    var dateOfVisit: Date? {get set}

//The entrant has just requested a Ride Access
    func hasJustSwipedForRide()
    func hasRecentlySwipedForRide() -> Bool
}



// MARK: People Types
//Guests
class ClassicGuest: Entrant {
    var delegate: PersonDelegate?
    
    init() {
        delegate = PersonDelegateTracker()
        delegate?.description = "Adult Guest Pass"
        delegate?.person = self
    }
}

class VIPGuest: Entrant, SkipAllRidesQueueAcessible, FoodDiscountAccessible, MerchandiseDiscountAccessible {
    var delegate: PersonDelegate?
    
    init() {
        delegate = PersonDelegateTracker()
        delegate?.description = "VIP Guest Pass"
        delegate?.foodDiscount = 10
        delegate?.merchandiseDiscount = 20
        delegate?.person = self
    }
}

class FreeChildGuest: Entrant, BirthDateable {
    var delegate: PersonDelegate?
    init (month: Int, day:  Int, year: Int) throws {
        guard let birthDay = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
            throw InputError.invalidDateOfbirth(required: "Date must be: MM/DD/YYY")
        }
        if Date.numYearsOld(birthDay) >= 5 {
            throw InputError.tooOldForDiscount
        }
        delegate = PersonDelegateTracker()
        delegate?.description = "Free Child Guest Pass"
        delegate?.dateOfBirth = birthDay
        delegate?.person = self
    }
}

class SeasonPassGuest: VIPGuest, Nameable, Addressable {
    
    init (name: Name, address: Address) {
        super.init()
        delegate = PersonDelegateTracker()
        delegate?.description = "Season Guest Pass"
        delegate?.name = name
        delegate?.address = address
        delegate?.person = self
    }
}

class SeniorGuest: Entrant, SkipAllRidesQueueAcessible, Nameable, BirthDateable, FoodDiscountAccessible, MerchandiseDiscountAccessible {
    var delegate: PersonDelegate?
    
    init (name: Name, month: Int, day:  Int, year: Int) throws {
        guard let birthDay = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
            throw InputError.invalidDateOfbirth(required: "Date must be: MM/DD/YYY")
        }
        if Date.numYearsOld(birthDay) < 65 {
            throw InputError.tooYoungForDiscount
        }
        delegate = PersonDelegateTracker()
        delegate?.description = "Senior Guest Pass"
        delegate?.dateOfBirth = birthDay
        delegate?.name = name
        delegate?.foodDiscount = 10
        delegate?.merchandiseDiscount = 10
        delegate?.person = self
    }
}



//Employees
class EmployeeType: Employee {
    var delegate: PersonDelegate?
    
    
    required init(name: Name, address: Address) {
        delegate = PersonDelegateTracker()
        delegate?.name = name
        delegate?.address = address
        delegate?.person = self
    }
}



//Hourly Employees
class HourlyEmployeeFactory {
    static func createHourlyEmployee(withType type: HourlyEmployeeType, name: Name, address: Address) -> HourlyEmployee {
        switch type {
        case .FoodServices: return FoodServicesEmployee(name: name, address: address)
        case .RideServices: return RideServicesEmployee(name: name, address: address)
        case .Maintenance: return MaintenanceEmployee(name: name, address: address)
        }
    }
}

class HourlyEmployee: EmployeeType, Entrant, FoodDiscountAccessible, MerchandiseDiscountAccessible  {
}

class FoodServicesEmployee: HourlyEmployee, KitchenAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Food Services Employee Pass"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}

class RideServicesEmployee: HourlyEmployee, RideControlAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Ride Services Employee Pass"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}

class MaintenanceEmployee: HourlyEmployee, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Maintenance Services Employee Pass"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}


//Manager
class Manager: EmployeeType, Entrant, FoodDiscountAccessible, MerchandiseDiscountAccessible, AllAreasAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Manager Pass"
        delegate?.foodDiscount = 25
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}

class ManagerType: EmployeeType {
}

class ShiftMgr: ManagerType, FoodDiscountAccessible, MerchandiseDiscountAccessible   {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Shift Manager"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}

class GeneralMgr: ManagerType, FoodDiscountAccessible, MerchandiseDiscountAccessible   {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Shift Manager"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}

class SeniorMgr: ManagerType, FoodDiscountAccessible, MerchandiseDiscountAccessible   {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Shift Manager"
        delegate?.foodDiscount = 15
        delegate?.merchandiseDiscount = 25
        delegate?.person = self
    }
}



//Contractors Employee
class ContractEmployeeFactory {
    static func createContractEmployee(withType type: ContractorProject, name: Name, address: Address) -> ContractEmployee {
        switch type {
        case .P1001: return ContractEmployeeP1001(name: name, address: address)
        case .P1002: return ContractEmployeeP1002(name: name, address: address)
        case .P1003: return ContractEmployeeP1003(name: name, address: address)
        case .P2001: return ContractEmployeeP2001(name: name, address: address)
        case .P2002: return ContractEmployeeP2002(name: name, address: address)
        }
    }
}


class ContractEmployee: EmployeeType {
}

class ContractEmployeeP1001: ContractEmployee, AmusementAreaAccessible, RideControlAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Contractor P1001 Pass"
        delegate?.person = self
    }
}

class ContractEmployeeP1002: ContractEmployee, AmusementAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Contractor P1002 Pass"
        delegate?.person = self
    }
}

class ContractEmployeeP1003: ContractEmployee, AllAreasAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Contractor P1003 Pass"
        delegate?.person = self
    }
}

class ContractEmployeeP2001: ContractEmployee, OfficeAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Contractor P2001 Pass"
        delegate?.person = self
    }
}

class ContractEmployeeP2002: ContractEmployee, KitchenAreaAccessible, MaintenanceAreaAccessible {
    required init(name: Name, address: Address) {
        super.init(name: name, address: address)
        delegate?.description = "Contractor P2002 Pass"
        delegate?.person = self
    }
}



//Vendors
class VendorTypeFactory {
    static func createVendorType(withType type: VendorCompany, name: Name, address: Address, month: Int, day:  Int, year: Int) throws -> VendorType{
        do {
            switch type {
            case .acme: return try Acme(name: name, address: address, month: month, day: day, year: year)
            case .fedex: return try Fedex(name: name, address: address, month: month, day: day, year: year)
            case .nwelectrical: return try NWElectrical(name: name, address: address, month: month, day: day, year: year)
            case .orkin: return try Orkin(name: name, address: address, month: month, day: day, year: year)
            }
        } catch {
            throw InputError.invalidDateOfbirth(required: "Date must be: MM/DD/YYY")
        }
    }
}

class VendorType: Vendor {
    var delegate: PersonDelegate?
    
    init (name: Name, address: Address, month: Int, day:  Int, year: Int) throws {
        guard let birthDay = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
            throw InputError.invalidDateOfbirth(required: "Date must be: MM/DD/YYY")
        }
        delegate = PersonDelegateTracker()
        delegate?.name = name
        delegate?.address = address
        delegate?.dateOfBirth = birthDay
    }
}

class Acme: VendorType, KitchenAreaAccessible {
    required override init (name: Name, address: Address, month: Int, day:  Int, year: Int) throws {
        try super.init (name: name, address: address, month: month, day:  day, year: year)
        delegate?.description = "Acme Vendor Pass"
        delegate?.person = self
    }
}

class Orkin: VendorType, AmusementAreaAccessible, RideControlAreaAccessible, KitchenAreaAccessible {
    required override init (name: Name, address: Address, month: Int, day:  Int, year: Int) throws {
        try super.init (name: name, address: address, month: month, day:  day, year: year)
        delegate?.description = "Orkin Vendor Pass"
        delegate?.person = self
    }
}

class Fedex: VendorType, MaintenanceAreaAccessible, OfficeAreaAccessible {
    required override init (name: Name, address: Address, month: Int, day:  Int, year: Int) throws {
        try super.init (name: name, address: address, month: month, day:  day, year: year)
        delegate?.description = "Fedex Vendor Pass"
        delegate?.person = self
    }
}

class NWElectrical: VendorType, AllAreasAccessible {
    required override init (name: Name, address: Address, month: Int, day:  Int, year: Int) throws {
        try super.init (name: name, address: address, month: month, day:  day, year: year)
        delegate?.description = "NWElecticals Vendor Pass"
        delegate?.person = self
    }
}



// MARK: Delegates
class PersonDelegateTracker: PersonDelegate {
    
    var dateOfVisit: Date?
    var merchandiseDiscount: Percent?
    var foodDiscount: Percent?
    var person: Person?
    var name: Name?
    var address: Address?
    var dateOfBirth: Date?
    var company: VendorCompany?
    var project: ContractorProject?
    var lastTimeSwipedForRide: Date?
    var description: String?
    var timeToWait: Double = 300.0
    
    
    func hasJustSwipedForRide() {
        lastTimeSwipedForRide = Date()
        print("creating new date access..")
    }
    
    func hasRecentlySwipedForRide() -> Bool {
        let newSwipe = Date()
        
        //check if there is a previous time, otherwise return true
        guard let lastTime: Date = lastTimeSwipedForRide else {
            print("This is you first Ride!")
            hasJustSwipedForRide()
            return false
        }
        //check if the interval since the last date is < timeToWait
        if newSwipe.timeIntervalSince(lastTime) < timeToWait {
            return true
        } else {
            hasJustSwipedForRide()
            return false
        }
    }
}



// MARK: Swift's class Implementations
extension Date {
    static func numYearsOld(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date as Date, to: Date() as Date).year!
    }
    /** Method to check if today is the someone's birthday */
    static func isBirthdayToday(_ eventDate: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let todayComponents = calendar.dateComponents([.month, .day], from: today as Date)
        let eventComponents = calendar.dateComponents([.month, .day], from: eventDate as Date)
        return todayComponents.month == eventComponents.month && todayComponents.day == eventComponents.day
    }
}
















