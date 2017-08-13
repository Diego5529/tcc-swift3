//
//  CompanyFormViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 22/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit
import Former
import CoreData
import ReachabilitySwift
import Crashlytics

class CompanyFormViewController : FormViewController {
    
    var delegate: AppDelegate!
    var companyClass: CompanyBean!
    var events: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            let results = EventDao.selectAllEvents(db: delegate.db.fmDatabase)
            
            if results.count > 0 {
                print(results)
                
                for event in results {
                    if let key = (event as AnyObject).value(forKey: "title") {
                        let eventClass = event as! EventBean
                        
                        events .setValue(eventClass, forKey: key as! String)
                        print(key)
                    }
                }
            }
        }catch{
            
        }
        
        if  companyClass == nil {
            companyClass = CompanyBean.init()
        }
        
        configureCompanyRows()

        addSaveButton()
        
        if companyClass.company_id > 0 {
            Sync().viewController = self
            Sync().sendCompany(company: companyClass, method: companyClass.id > 0 ? "update" : "create")
        }
    }
    
    func addSaveButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func insertNewObject(_ sender: Any) {
        
        if self.companyClass?.created_at == nil {
            companyClass?.created_at = NSDate.init()
        }
        
        let message = companyClass?.validateCreateCompany(title: companyClass.title!, shortDescription: companyClass.short_description!, longDescription: companyClass.long_description!, minUsers: (companyClass?.min_users)!, maxUsers: (companyClass?.max_users)!, createdAt: companyClass!.created_at)
        
        if (message?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            if !(self.companyClass.company_id > 0) {
                self.companyClass.company_id = CompanyDao.getCompanyMaxId(db: delegate.db.fmDatabase)
            }
            
            if (CompanyDao.insertOrReplaceCompany(db: delegate.db.fmDatabase, company: self.companyClass)){

                let uct = UserCompanyTypeBean.init()
                uct.user_company_type_id = UserCompanyTypeDao.getUserCompanyTypeMaxId(db: delegate.db.fmDatabase)
                uct.user_id = 1
                uct.company_id = companyClass.id
                uct.user_type_id = 1
                uct.admin = true
                uct.active = true
                uct.created_at = NSDate.init()
                
                do {
                    if(UserCompanyTypeDao.insertOrReplaceUser(db: delegate.db.fmDatabase, userCompanyType: uct)){
                        print("save success!")
                    
                        self.former.reload()
                    }
                }catch{
                    print("Salvou")
                }
            }
        }else{
            showMessage(message: message!, title: "Error", cancel: "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCompanyRows (){
        // Create RowFormers
        // CompanyRows
        
        // Create RowFormers
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected { _ in
                    onSelected?()
            }
        }
        
        let inputAccessoryView = FormerInputAccessoryView(former: former)
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 44
            }
        }
        
        //Create Rows
        
        //Title
        let textFieldTitleCompany = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Title"
            $0.textField.keyboardType = .alphabet
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            }.configure {
                $0.placeholder = "Ex: IFSP Ltda."
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.companyClass?.title = $0
            }.onUpdate{
                $0.text = self.companyClass.title
        }
        
        //Description
        let textFieldDescription = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Description"
            $0.textField.keyboardType = .alphabet
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.companyClass?.short_description = $0
            }.onUpdate{
                $0.text = self.companyClass.short_description
        }
        
        //Long Description
        let textFieldLongDescription = TextViewRowFormer<FormTextViewCell> {
            $0.titleLabel.text = "Long Description"
            $0.textView.keyboardType = .alphabet
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.companyClass?.long_description = $0
            }.onUpdate{
                $0.text = self.companyClass.long_description
        }
        
        //Min User
        let stepperRowMinUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Min User"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            }.displayTextFromValue { "\(Int($0))" }.onValueChanged {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print($0)
            }.onUpdate{
                $0.value = Double(self.companyClass.min_users)
        }
        
        //Max User
        let stepperRowMaxUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Max User"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.stepper.value = Double(self.companyClass.max_users)
            }.displayTextFromValue { "\(Int($0))" }.onValueChanged {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                print($0)
                 self.companyClass?.max_users = Int16($0)
                
                if stepperRowMinUser.value >= $0 {
                    stepperRowMinUser.value = $0
                    stepperRowMinUser.update()
                }
            }.onUpdate{
                $0.value = Double(self.companyClass.max_users)
        }
        
        //Min User Value Changed
        stepperRowMinUser.onValueChanged {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            print($0)
            
            self.companyClass?.min_users = Int16($0)
            
            stepperRowMaxUser.value = $0
            stepperRowMaxUser.update()
        }
        
        // Create SectionFormers
        let arrayEventsRow = NSMutableArray()
        
        if self.companyClass.company_id > 0 {
            //Events
            let newEventRow = createMenu("New Event") { [weak self] in
                let eventVC = EventFormViewController()
                eventVC.companyEvent = self?.companyClass
                
                self?.navigationController?.pushViewController(eventVC, animated: true)
            }
            
            arrayEventsRow.add(newEventRow)
        }
        
        for event in events {
            let eventRow = createMenu(event.key as! String) { [weak self] in
                let eventVC = EventFormViewController()
                eventVC.eventClass = event.value as! EventBean
                
                self?.navigationController?.pushViewController(eventVC, animated: true)
            }
            
            arrayEventsRow.add(eventRow)
        }
        
        let eventsSection = SectionFormer(rowFormers: arrayEventsRow as! [RowFormer])
            .set(headerViewFormer: createHeader("Events"))
        
        // Create SectionFormers
        let section0 = SectionFormer(rowFormer: textFieldTitleCompany, textFieldDescription, textFieldLongDescription, stepperRowMinUser, stepperRowMaxUser)
            .set(headerViewFormer: createHeader("Company"))
        
        former.append(sectionFormer: section0, eventsSection
            ).onCellSelected { _ in
                inputAccessoryView.update()
        }
    }
    
    private enum InsertPosition: Int {
        case Below, Above
    }
    
    private var insertRowAnimation = UITableViewRowAnimation.left
    private var insertSectionAnimation = UITableViewRowAnimation.fade
    private var insertRowPosition: InsertPosition = .Below
    private var insertSectionPosition: InsertPosition = .Below
    
    private lazy var subRowFormers: [RowFormer] = {
        return (1...2).map { index -> RowFormer in
            return CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check\(index)"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.tintColor = .formerSubColor()
            }
        }
    }()
    
    private lazy var subSectionFormer: SectionFormer = {
        return SectionFormer(rowFormers: [
            CheckRowFormer<FormCheckCell>() {
                $0.titleLabel.text = "Check3"
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                $0.tintColor = .formerSubColor()
            }
            ])
    }()
    
    private func insertRows(sectionTop: RowFormer, sectionBottom: RowFormer) -> (Bool) -> Void {
        return { [weak self] insert in
            guard let `self` = self else { return }
            if insert {
                if self.insertRowPosition == .Below {
                    self.former.insertUpdate(rowFormers: self.subRowFormers, below: sectionBottom, rowAnimation: self.insertRowAnimation)
                } else if self.insertRowPosition == .Above {
                    self.former.insertUpdate(rowFormers: self.subRowFormers, above: sectionTop, rowAnimation: self.insertRowAnimation)
                }
            } else {
                self.former.removeUpdate(rowFormers: self.subRowFormers, rowAnimation: self.insertRowAnimation)
            }
        }
    }
    
    private func insertSection(relate: SectionFormer) -> (Bool) -> Void {
        return { [weak self] insert in
            guard let `self` = self else { return }
            if insert {
                if self.insertSectionPosition == .Below {
                    self.former.insertUpdate(sectionFormers: [self.subSectionFormer], below: relate, rowAnimation: self.insertSectionAnimation)
                } else if self.insertSectionPosition == .Above {
                    self.former.insertUpdate(sectionFormers: [self.subSectionFormer], above: relate, rowAnimation: self.insertSectionAnimation)
                }
            } else {
                self.former.removeUpdate(sectionFormers: [self.subSectionFormer], rowAnimation: self.insertSectionAnimation)
            }
        }
    }
    
    private func sheetSelectorRowSelected(options: [String]) -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                options.forEach { title in
                    sheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak rowFormer] _ in
                        rowFormer?.subText = title
                        rowFormer?.update()
                    })
                    )
                }
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
                self?.former.deselect(animated: true)
            }
        }
    }
    
    //AlertView
    func showMessage(message: String, title: String, cancel: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if cancel.characters.count > 0 {
            let DestructiveAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.destructive) {
                (result : UIAlertAction) -> Void in
                print("Destructive")
            }
            
            alertController.addAction(DestructiveAction)
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        OperationQueue.main.addOperation {
            self.present(alertController, animated: false, completion: nil)
        }
    }
}
