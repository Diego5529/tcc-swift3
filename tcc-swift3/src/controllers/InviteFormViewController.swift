//
//  InviteFormViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 27/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit
import Former
import CoreData

class InviteFormViewController : FormViewController {
    
    var delegate: AppDelegate!
    var companyEvent: CompanyBean!
    var eventClass: EventBean!
    var invitationClass: InvitationBean!
    var userClass: UserBean!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        if  eventClass != nil {
            if invitationClass == nil {
                invitationClass = InvitationBean.init()
                invitationClass.event_id = eventClass.event_id
                invitationClass.host_user_id = (delegate.genericUser?.user_id)!
            }
            
            configureInviteRows()
            
            addSaveButton()
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addSaveButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func insertNewObject(_ sender: Any) {
        if self.invitationClass?.created_at == nil {
            invitationClass?.created_at = NSDate.init()
        }
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //
            DispatchQueue.main.async(execute: {() -> Void in
                //
            })
        })
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //
            var idMaxUser = 0
            
            let userBean = UserDao.getUserByEmail(db: self.delegate.db.fmDatabase, email: self.invitationClass.email)
            
            if (userBean.id == 0) {
                let sync = Sync.init()
                sync.getUserEmailOrID(user: userBean, email: self.invitationClass.email, id: self.invitationClass.id)
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                //
                if userBean.id > 0 {
                    self.invitationClass.guest_user_id = userBean.id
                }else{
                    idMaxUser = Int(UserDao.getUserMaxId(db: self.delegate.db.fmDatabase))
                    
                    //userObj.setValue(self.invitationClass.email, forKey: "email")
                    //userObj.setValue(idMaxUser, forKey: "user_id")
                    self.invitationClass.guest_user_id = Int16(idMaxUser)
                }
                
                let message = self.invitationClass?.validateCreateInvitation()
                
                if (message?.isEmpty)! {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    
                    self.invitationClass.event_id = self.eventClass.event_id
                    self.invitationClass.host_user_id = (self.delegate.genericUser?.id)!
                    self.invitationClass.updated_at = NSDate.init()

                    do {
                        if(InvitationDao.insertOrReplaceInvitation(db: self.delegate.db.fmDatabase, invitation: self.invitationClass)){
                            print("Invitation Saved!")
                        }
                    }catch{
                    
                    }
                }else{
                    self.showMessage(message: message!, title: "Error", cancel: "")
                }
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureInviteRows (){
        // Create RowFormers
        // InviteRows
        
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
        
        //User
        let textFieldUserEvent = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "User"
            $0.textField.keyboardType = .emailAddress
            }.configure {
                $0.placeholder = "Email"
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.invitationClass?.email = $0.lowercased()
            }.onUpdate{
                $0.text = self.invitationClass.email.lowercased()
        }
        
        //Invitation Type
        let types = InvitationTypeDao.selectAllInvitationTypes(db: delegate.db.fmDatabase)
        let dictionaryTypes: NSMutableDictionary = [:]
        
        for type in types {
            if let key = (type as AnyObject).value(forKey: "id") {
                let typeClass = type as! InvitationTypeBean
                
                dictionaryTypes.setValue(typeClass, forKey: String(format: "%@", key as! CVarArg))
            }
        }
        
        let selectorInvitationTypePickerRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any>() {
//            $0.backgroundColor = UIColor.red
            $0.titleLabel.text = "Invitation Type"
//            $0.titleLabel.textColor = UIColor.blue
            }.configure {
                $0.pickerItems = [SelectorPickerItem(
                    title: "",
                    displayTitle: NSAttributedString(string: "Not Set"),
                    value: self.eventClass.city_id as Any )]
                    + dictionaryTypes.allValues.map { SelectorPickerItem(title: ($0 as! InvitationTypeBean).title as String, value: ($0 as! InvitationTypeBean).id as Int16) }
                $0.selectedRow = dictionaryTypes.allKeys.index(after: Int(self.invitationClass.invitation_type_id)) - 1
            }.onValueChanged {
                if ($0.value != nil){
                    self.invitationClass.invitation_type_id = $0.value as! Int16
                }
        }
        
        // Create SectionFormers
        let section0 = SectionFormer(rowFormer: textFieldUserEvent, selectorInvitationTypePickerRow)
            .set(headerViewFormer: createHeader("Invite"))
        
        former.append(sectionFormer: section0
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
