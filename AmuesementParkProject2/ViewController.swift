//
//  ViewController.swift
//  AmuesementParkProject2
//
//  Created by Rohit Devnani on 7/8/17.
//  Copyright © 2017 Rohit Devnani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    enum ChoiceType {
        case child, adult, senior, season, vip
        case food, ride, maintenance
        case contractor
        case manager
        case vendor
    }
    
    var defaultPerson: [String: String] = [
        "SSN" : "777-77-7777",
        "PRJ" : "7777",
        "FNM" : "John",
        "LNM" : "Smith",
        "CMP" : "Acme",
        "STR" : "Some Street",
        "CTY" : "Some City",
        "STT" : "Some Place",
        "ZPC" : "77777"
    ]
    
    var defaultAge: [ChoiceType: String] = [
        ChoiceType.child : "01/01/2012",
        ChoiceType.senior : "01/01/1950",
        ChoiceType.vendor : "01/01/1990"
    ]
    
    
    
//MARK: Outlets
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var guestStack: UIStackView!
    @IBOutlet weak var employeeStack: UIStackView!
        var subStacks: [UIStackView] = []
    @IBOutlet weak var dateOfBirthText: UITextField!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
        var dateElements: [UIView] = []
    @IBOutlet weak var ssnText: UITextField!
    @IBOutlet weak var ssnLabel: UILabel!
        var ssnElements: [UIView] = []
    @IBOutlet weak var projectText: UITextField!
    @IBOutlet weak var projectLabel: UILabel!
        var projectElements: [UIView] = []
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
        var nameElements: [UIView] = []
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var companyLabel: UILabel!
        var companyElements: [UIView] = []
    @IBOutlet weak var streetAddresstext: UITextField!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodetext: UITextField!
    @IBOutlet weak var zipCodelabel: UILabel!
        var addressElements: [UIView] = []
    
    
    
    
//Helper
    var activeField: UITextField?
    var chosenType: ChoiceType?
    var person: Person?
    
    
    
//Initial Setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subStacks = [guestStack, employeeStack]
        dateElements = [dateOfBirthText, dateOfBirthLabel]
        ssnElements = [ssnText, ssnLabel]
        projectElements = [projectText, projectLabel]
        nameElements = [lastNameText, firstNameText, firstNameLabel, lastNameLabel]
        companyElements = [companyText, companyLabel]
        addressElements = [streetAddressLabel, streetAddresstext, cityLabel, cityText, stateLabel, stateText, zipCodelabel, zipCodetext]
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        hideSubStacks()
        disableAllForms()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
// Top Stack Button Actions
    @IBAction func guestButtonAction(_ sender: UIButton) {
        hideSubStacks()
        showGuestStack()
        chosenType = nil
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func employeeButtonAction(_ sender: UIButton) {
        hideSubStacks()
        showEmployeeStack()
        chosenType = nil
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func managerButtonAction(_ sender: UIButton) {
        hideSubStacks()
        chosenType = ChoiceType.manager
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func contractorButtonAction(_ sender: UIButton) {
        hideSubStacks()
        chosenType = ChoiceType.contractor
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func vendorButtonAction(_ sender: UIButton) {
        hideSubStacks()
        chosenType = ChoiceType.vendor
        activateForms(chosenType: chosenType)
    }
    
    
    
//Sub Stack Button Actions
    @IBAction func childButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.child
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func adultButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.adult
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func seniorButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.senior
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func vipButtonAction(_ sender: UIButton) {
        disableAllForms()
        chosenType = ChoiceType.vip
    }
    
    @IBAction func seasonButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.season
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func foodServicesButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.food
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func rideServicesButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.ride
        activateForms(chosenType: chosenType)
    }
    
    @IBAction func maintenanceButtonAction(_ sender: UIButton) {
        chosenType = ChoiceType.maintenance
        activateForms(chosenType: chosenType)
    }
    
    
    
// Bottom Buttons Actions
    @IBAction func generateButtonAction(_ sender: UIButton) {
        do {
            guard let choice: ChoiceType = chosenType else {
                throw InputError.unspecifiedPersonType
            }
            generatePass(choseType: choice)
        } catch InputError.unspecifiedPersonType {
            
            let alert = UIAlertController(title: "Selection Type Missing", message: "You need to specify a person type to generate a badge", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } catch let error {
            fatalError("\(error)")
        }
    }
    
    @IBAction func populateButtonAction(_ sender: UIButton) {
        populateData()
    }
    

    
//Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generateBadge" {
            do {
                guard let personNotNil: Person = person else {
                    throw InputError.personIsNil
                }
                let badgeController = segue.destination as! BadgeController
                badgeController.person = personNotNil
                
            } catch InputError.personIsNil {
                
                let alertController = UIAlertController(title: "Person not created", message: "Person information is missing", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
                
            } catch let error {
                fatalError("\(error)")
            }
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            if activeField == zipCodetext || activeField == cityText || activeField == streetAddresstext || activeField == stateText {
                
                UIView.animate(withDuration: 0.8) {
                    self.mainViewBottomConstraint.constant = keyboardFrame.size.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8) {
            self.mainViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func activateForms(chosenType: ChoiceType?) {
        disableAllForms()
        if let type: ChoiceType = chosenType {
            switch type {
            case .child: activateSectionForm(formSection: dateElements)
            case .senior: activateSectionForm(formSection: dateElements); activateSectionForm(formSection: nameElements)
            case .season: activateSectionForm(formSection: nameElements); activateSectionForm(formSection: addressElements)
            case .food, .ride, .maintenance: activateSectionForm(formSection: nameElements); activateSectionForm(formSection: addressElements)
            case .manager: activateSectionForm(formSection: nameElements); activateSectionForm(formSection: addressElements)
            case .contractor: activateSectionForm(formSection: projectElements); activateSectionForm(formSection: nameElements); activateSectionForm(formSection: addressElements)
            case .vendor: activateSectionForm(formSection: nameElements); activateSectionForm(formSection: addressElements); activateSectionForm(formSection: dateElements)
            activateSectionForm(formSection: companyElements)
            default: break
            }
        }
    }
    
    func disableAllForms() {
        disableSectionForm(formSection: dateElements)
        disableSectionForm(formSection: ssnElements)
        disableSectionForm(formSection: projectElements)
        disableSectionForm(formSection: nameElements)
        disableSectionForm(formSection: companyElements)
        disableSectionForm(formSection: addressElements)
    }
    
    func populateData() {
        generateSectionForm(formSection: dateElements)
        generateSectionForm(formSection: ssnElements)
        generateSectionForm(formSection: projectElements)
        generateSectionForm(formSection: nameElements)
        generateSectionForm(formSection: companyElements)
        generateSectionForm(formSection: addressElements)
    }
    
    
    func generatePass(choseType: ChoiceType) {
        do {
            switch choseType {
            case .child:
                let dateArray = try getDate(dateField: dateOfBirthText)
                person = try Generator.generateBadge(personKind: .freeChild(Int(dateArray[0]), Int(dateArray[1]), Int(dateArray[2])))
                
            case .senior:
                let dateArray = try getDate(dateField: dateOfBirthText)
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                person = try Generator.generateBadge(personKind: .senior(name, Int(dateArray[0]), Int(dateArray[1]), Int(dateArray[2])))
                
            case .adult:
                person = try Generator.generateBadge(personKind: .classic)
                
            case .vip:
                person = try Generator.generateBadge(personKind: .vip)
                
            case .season:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                person = try Generator.generateBadge(personKind: .seasonPass(name, address))
                
            case .food:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                person = try Generator.generateBadge(personKind: .hourlyEmployee(name, address, .FoodServices))
                
            case .ride:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                person = try Generator.generateBadge(personKind: .hourlyEmployee(name, address, .RideServices))
                
            case .maintenance:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                person = try Generator.generateBadge(personKind: .hourlyEmployee(name, address, .Maintenance))
                
            case .manager:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                person = try Generator.generateBadge(personKind: .manager(name, address))
                
            case .contractor:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                let project: ContractorProject = try ContractorProject.enumFromString(string: "P\(getText(textField: projectText))")
                person = try Generator.generateBadge(personKind: .contractor(name, address, project))
                
            case .vendor:
                let name: Name = try Name(firstName: getText(textField: firstNameText), secondName: getText(textField: lastNameText))
                let address: Address = try Address(streetAddress: getText(textField: streetAddresstext), city: getText(textField: cityText), state: getText(textField: stateText), zipCode: getText(textField: zipCodetext))
                let dateArray = try getDate(dateField: dateOfBirthText)
                let company: VendorCompany = try VendorCompany.enumFromString(string: getText(textField: companyText))
                person = try Generator.generateBadge(personKind: .vendor(name, address, Int(dateArray[0]), Int(dateArray[1]), Int(dateArray[2]), company))
            }
            
        } catch InputError.emptyInput(let message) {
            
            let alert = UIAlertController(title: "Empty Input", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.invalidDateOfbirth(let message) {
            
            let alert = UIAlertController(title: "Invalid Date", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.requiredFieldIsNil {
            
            let alert = UIAlertController(title: "Null Input", message: "Any required field is null", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.tooOldForDiscount {
            
            let alert = UIAlertController(title: "Too Old", message: "The person is too old for this offer", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.tooYoungForDiscount {
            
            let alert = UIAlertController(title: "Too Young", message: "The person is too young for this offer", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.companyIsNotInTheList {
            
            let alert = UIAlertController(title: "Compnay Invalid", message: "The company is not in the list", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch InputError.projectIsNotInTheList {
            
            let alert = UIAlertController(title: "Project Invalid", message: "The project is not in the list", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch let error {
            fatalError("\(error)")
        }
    }
    
    
    
    
// Functions (Stack hide and show)
    func hideSubStacks() {
        subStacks = subStacks.map({
            (stack: UIStackView) -> UIStackView in
            stack.isHidden = true
            return stack
        })
    }
    
    func showEmployeeStack() {
        employeeStack.isHidden = false
    }
    
    func showGuestStack() {
        guestStack.isHidden = false
    }
    
    func disableSectionForm(formSection section: [UIView]) {
        section.forEach {
            switch $0 {
            case let label as UILabel: label.isEnabled = false
            case let textField as UITextField:
                textField.isEnabled = false
                textField.textColor = UIColor.lightGray
                resetForm(form: textField)
            default: break
            }
        }
    }
    
    func activateSectionForm(formSection section: [UIView]) {
        section.forEach {
            switch $0 {
            case let label as UILabel: label.isEnabled = true
            case let textField as UITextField:
                textField.isEnabled = true
                textField.textColor = UIColor.darkGray
                resetForm(form: textField)
            default: break
            }
        }
    }
    
    func generateSectionForm(formSection section: [UIView]) {
        section.forEach {
            switch $0 {
            case let textField as UITextField:
                if textField.isEnabled {
                    generateForm(form: textField)
                }
            default: break
            }
        }
    }
    
    
    func generateForm(form: UITextField) {
        switch form {
        case ssnText: ssnText.text = defaultPerson["SSN"]
        case projectText: projectText.text = defaultPerson["PRJ"]
        case firstNameText: firstNameText.text = defaultPerson["FNM"]
        case lastNameText: lastNameText.text = defaultPerson["LNM"]
        case companyText: companyText.text = defaultPerson["CMP"]
        case streetAddresstext: streetAddresstext.text = defaultPerson["STR"]
        case cityText: cityText.text = defaultPerson["CTY"]
        case stateText: stateText.text = defaultPerson["STT"]
        case zipCodetext: zipCodetext.text = defaultPerson["ZPC"]
        case dateOfBirthText: dateOfBirthText.text = defaultAge[chosenType!]
        default: break
        }
    }
    
    func resetForm(form: UITextField) {
        switch form {
        case dateOfBirthText: dateOfBirthText.text = "MM / DD / YYYY"
        case ssnText: ssnText.text = "000-000-000"
        case projectText: projectText.text = "00000"
        default: form.text = ""
        }
    }
    
    
    func getDate(dateField: UITextField) throws -> [String] {
        guard let date: String = dateField.text else {
            throw InputError.requiredFieldIsNil
        }
        return date.characters.split(separator: "/").map(String.init)
    }
    
    
    func getText(textField: UITextField) -> String {
        guard let str: String = textField.text else {
        fatalError()
        }
        return str
    }
}








































