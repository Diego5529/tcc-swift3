//
//  InvitationViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 04/06/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit
import CoreData
import Former

class InvitationListViewController: FormViewController, NSFetchedResultsControllerDelegate {
    
    var delegate: AppDelegate!
    var companyEvent: CompanyBean!
    var eventClass: EventBean!
    var invitationClass: InvitationBean!
    var userClass: UserBean!
    var invitations: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            let results = InvitationDao.selectAllInvitations(db: delegate.db.fmDatabase)
            
            if results.count > 0 {
                print(results)
                
                for invitation in results {
                    if let key = (invitation as AnyObject).value(forKey: "email") {
                        let invitationClass = invitation as! InvitationBean
                        
                        invitations .setValue(invitationClass, forKey: key as! String)
                        print(key)
                    }
                }
            }
        }catch{
            print("failed: \(error.localizedDescription)")
        }
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        former.deselect(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configure() {
        
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
        
        //Companies
        let newInviteRow = createMenu("New Invitation") { [weak self] in
            let inviteFormVC = InviteFormViewController()
            inviteFormVC.companyEvent = self?.companyEvent
            inviteFormVC.eventClass = self?.eventClass
            
            self?.navigationController?.pushViewController(inviteFormVC, animated: true)
        }
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 40
            }
        }
        
        // Create SectionFormers
        let optionsSection = SectionFormer(rowFormer: newInviteRow)
            .set(headerViewFormer: createHeader("Options"))
        
        let arrayInvitesRow = NSMutableArray()
        
        for invitation in invitations {
            let invitationRow = createMenu(invitation.key as! String) { [weak self] in
                let invitationVC = InviteFormViewController()
                invitationVC.invitationClass = invitation.value as! InvitationBean
                invitationVC.eventClass = self?.eventClass
                
                self?.navigationController?.pushViewController(invitationVC, animated: true)
            }
            
            arrayInvitesRow.add(invitationRow)
        }
        
        let invitationsSection = SectionFormer(rowFormers: arrayInvitesRow as! [RowFormer])
            .set(headerViewFormer: createHeader("Invitations"))
        
        former.append(sectionFormer: optionsSection, invitationsSection)
    }
}
