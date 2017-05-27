//
//  EventFormViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 24/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Former

class EventFormViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCompanyRows()
        
        addSaveButton()
    }
    
    func addSaveButton(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func insertNewObject(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
        }
        
        //Description
        let textFieldDescription = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Short Description"
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
        }
        
        //Long Description
        let textViewLongDescriptionRow = TextViewRowFormer<FormTextViewCell> {
            $0.titleLabel.text = "Long Description"
            }.configure {
                $0.placeholder = ""
            }.onTextChanged {
                print($0)
        }
        
        let newInviteRow = createMenu("New Invite") { [weak self] in
            self?.navigationController?.pushViewController(InviteFormViewController(), animated: true)
        }
        
        //City
        let selectorCityPickerRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any>() {
            $0.titleLabel.text = "City"
            }.configure {
                $0.pickerItems = [SelectorPickerItem(
                    title: "",
                    displayTitle: NSAttributedString(string: "Not Set"),
                    value: nil)]
                    + (1...20).map { SelectorPickerItem(title: "City \($0)") }
        }
        
        //Initial Date
        let initialDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Initial Date"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullDate)
        
        //End Date
        let endDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "End Date"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullDate)
        
        //Initial Hour
        let initialHourRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Initial Hour"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .time
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullTime)
        
        //End Hour
        let endHourRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "End Hour"
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .time
            }.configure {
                $0.displayEditingColor = .formerHighlightedSubColor()
            }.displayTextFromDate(String.fullTime)
        
        //Min User
        let stepperRowMinUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Min User"
            }.displayTextFromValue { "\(Int($0))" }
        
        //Max User
        let stepperRowMaxUser = StepperRowFormer<FormStepperCell>(){
            $0.titleLabel.text = "Max User"
            }.displayTextFromValue { "\(Int($0))" }.onValueChanged {
                print($0)
                if stepperRowMinUser.value >= $0 {
                    stepperRowMinUser.value = $0
                    stepperRowMinUser.update()
                }
        }
        
        //Min User Value Changed
        stepperRowMinUser.onValueChanged {
            print($0)
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
        }
        
        // Create SectionFormers
        let section0 = SectionFormer(rowFormer: textFieldTitleEvent, textFieldDescription, textViewLongDescriptionRow)
            .set(headerViewFormer: createHeader("Event"))
        
        let section1 = SectionFormer(rowFormer: initialDateRow, endDateRow, initialHourRow, endHourRow)
            .set(headerViewFormer: createHeader("Date"))
        
        let section15 = SectionFormer(rowFormer: newInviteRow)
            .set(headerViewFormer: createHeader("Invites"))
        
        let section2 = SectionFormer(rowFormer: selectorCityPickerRow)
            .set(headerViewFormer: createHeader("Address"))
        
        let section3 = SectionFormer(rowFormer: archiveEventCheckRow)
            .set(headerViewFormer: createHeader("Others"))
        
        former.append(sectionFormer: section0, section1, section15, section2, section3
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
}
