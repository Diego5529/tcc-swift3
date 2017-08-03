//
//  EventFormViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 24/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Former
import CoreData

class EventFormViewController : FormViewController {
    
    var delegate: AppDelegate!
    var companyEvent: CompanyBean!
    var eventClass: EventBean!
    var invitations: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        if  eventClass == nil {
            eventClass = EventBean.init()
            eventClass.company_id = companyEvent.company_id
        }
        
        configureCompanyRows()
        
        addSaveButton()
    }
    
    func addSaveButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func insertNewObject(_ sender: Any) {
        
        if self.eventClass?.created_at == nil {
            eventClass?.created_at = NSDate.init()
        }
        
        let message = eventClass?.validateCreateEvent(title: eventClass.title!, shortDescription: eventClass.short_description!, longDescription: eventClass.long_description!, minUsers: (eventClass?.min_users)!, maxUsers: (eventClass?.max_users)!, createdAt: eventClass!.created_at)
        
        if (message?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            self.eventClass.event_id = EventDao.getEventMaxId(db: delegate.db.fmDatabase)
            
            /*let eventObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Event", into: self.context)
            
            eventObj.setValue(self.eventClass.event_id, forKey: "event_id")
            eventObj.setValue(eventClass.title, forKey: "title")
            eventObj.setValue(eventClass.short_description, forKey: "short_description")
            eventObj.setValue(eventClass.long_description, forKey: "long_description")
            eventObj.setValue(eventClass.min_users, forKey: "min_users")
            eventObj.setValue(eventClass.max_users, forKey: "max_users")
            eventObj.setValue(eventClass.created_at, forKey: "created_at")
            eventObj.setValue(eventClass.initial_date, forKey: "initial_date")
            eventObj.setValue(eventClass.end_date, forKey: "end_date")
            eventObj.setValue(eventClass.initial_hour, forKey: "initial_hour")
            eventObj.setValue(eventClass.end_hour, forKey: "end_hour")
            eventObj.setValue(eventClass.city_id, forKey: "city_id")
            eventObj.setValue(eventClass.company_id, forKey: "company_id")
            eventObj.setValue(eventClass.archive, forKey: "archive")
            eventObj.setValue(eventClass.status, forKey: "status")
            */
            
            do {
                try EventDao.insertEvent(db: delegate.db.fmDatabase, event: self.eventClass)
                
                print("save success!")
                
                self.former.reload()
            }catch{
                print("Salvou")
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
        
        let inputAccessoryView = FormerInputAccessoryView(former: former)
        
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
        let textFieldTitleEvent = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Title"
            $0.textField.keyboardType = .alphabet
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.eventClass?.title = $0
            }.onUpdate{
                $0.text = self.eventClass.title
        }
        
        //Description
        let textFieldDescription = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Short Description"
            $0.textField.keyboardType = .alphabet
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.eventClass?.short_description = $0
            }.onUpdate {
                $0.text = self.eventClass.short_description
        }
        
        //Long Description
        let textViewLongDescriptionRow = TextViewRowFormer<FormTextViewCell> {
            $0.titleLabel.text = "Long Description"
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.eventClass?.long_description = $0
            }.onUpdate {
                $0.text = self.eventClass.long_description
        }
        
        // Create SectionFormers
        let arrayInvitesRow = NSMutableArray()
        
        if self.eventClass.event_id > 0 {
            //Invitations
            let myInvitationsRow = createMenu("My Invitations") { [weak self] in
                let inviteFormVC = InvitationListViewController()
                inviteFormVC.companyEvent = self?.companyEvent
                inviteFormVC.eventClass = self?.eventClass
                
                self?.navigationController?.pushViewController(inviteFormVC, animated: true)
            }
            
            arrayInvitesRow.add(myInvitationsRow)
            
            //
            let newInviteRow = createMenu("New Invite") { [weak self] in
                let inviteFormVC = InviteFormViewController()
                inviteFormVC.eventClass = self?.eventClass
                
                self?.navigationController?.pushViewController(inviteFormVC, animated: true)
            }
            
            arrayInvitesRow.add(newInviteRow)
        }
        
        let invitationsSection = SectionFormer(rowFormers: arrayInvitesRow as! [RowFormer])
            .set(headerViewFormer: createHeader("Invitations"))
        
        //City
        let selectorCityPickerRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any>() {
            $0.titleLabel.text = "City"
            }.configure {
                $0.pickerItems = [SelectorPickerItem(
                    title: "",
                    displayTitle: NSAttributedString(string: "Not Set"),
                    value: nil)]
                    + (1...20).map { SelectorPickerItem(title: "City \($0)") }
            }.onValueChanged {
                print($0)
//                print($0.displayTitle!,$0.value!  , $0.title)
        }
        
        //Initial Date
        let initialDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Initial Date"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullDate).onDateChanged {
                print($0)
                self.eventClass.initial_date = $0 as NSDate
            }.onUpdate {
                $0.date = self.eventClass.initial_date as Date
        }
    
        //End Date
        let endDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "End Date"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullDate).onDateChanged {
                print($0)
                self.eventClass.end_date = $0 as NSDate
            }.onUpdate {
                $0.date = self.eventClass.end_date as Date
        }
        
        //Initial Hour
        let initialHourRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Initial Hour"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .time
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullTime).onDateChanged {
                print($0)
                self.eventClass.initial_hour = $0 as NSDate
            }.onUpdate {
                $0.date = self.eventClass.initial_hour as Date
        }
        
        //End Hour
        let endHourRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "End Hour"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .time
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullTime).onDateChanged {
                print($0)
                self.eventClass.end_hour = $0 as NSDate
            }.onUpdate {
                $0.date = self.eventClass.end_hour as Date
        }
        
        //Min User
        let stepperRowMinUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Min User"
            }.displayTextFromValue { "\(Int($0))" }.onValueChanged {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print($0)
            }.onUpdate{
                $0.value = Double(self.eventClass.min_users)
        }
        
        //Max User
        let stepperRowMaxUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Max User"
            $0.stepper.value = Double(self.eventClass.max_users)
            }.displayTextFromValue { "\(Int($0))" }.onValueChanged {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                print($0)
                self.eventClass?.max_users = Int16($0)
                
                if stepperRowMinUser.value >= $0 {
                    stepperRowMinUser.value = $0
                    stepperRowMinUser.update()
                }
            }.onUpdate{
                $0.value = Double(self.eventClass.max_users)
        }
        
        //Min User Value Changed
        stepperRowMinUser.onValueChanged {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            print($0)
            
            self.eventClass?.min_users = Int16($0)
            
            stepperRowMaxUser.value = $0
            stepperRowMaxUser.update()
        }
        
        //Archive
        let archiveEventCheckRow = CheckRowFormer<FormCheckCell>() {
            $0.titleLabel.text = "Archive Event"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 16)
            }.configure {
                $0.checked = false
            }.onCheckChanged{
                self.eventClass.archive = $0
            }.onUpdate {
                $0.checked = self.eventClass.archive
        }
        
        // Create SectionFormers
        let section0 = SectionFormer(rowFormer: textFieldTitleEvent, textFieldDescription, textViewLongDescriptionRow)
            .set(headerViewFormer: createHeader("Event"))
        
        let section1 = SectionFormer(rowFormer: initialDateRow, endDateRow, initialHourRow, endHourRow)
            .set(headerViewFormer: createHeader("Date"))
        
        let section2 = SectionFormer(rowFormer: selectorCityPickerRow)
            .set(headerViewFormer: createHeader("Address"))
        
        let section3 = SectionFormer(rowFormer: archiveEventCheckRow)
            .set(headerViewFormer: createHeader("Others"))
        
        former.append(sectionFormer: section0, section1, invitationsSection, section2, section3
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
