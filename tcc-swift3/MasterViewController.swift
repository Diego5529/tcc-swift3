//
//  MasterViewController.swift
//  Split2
//
//  Created by Diego Oliveira on 19/03/17.
//  Copyright © 2017 Diego Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Former

class MasterViewController: FormViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var delegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        configure()
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
        let myCompaniesRow = createMenu("My Companies") { [weak self] in
            self?.navigationController?.pushViewController(CompanyFormViewController(), animated: true)
        }
        
        let newCompanyRow = createMenu("New Company") { [weak self] in
            self?.navigationController?.pushViewController(CompanyFormViewController(), animated: true)
        }
        
        //Events
        let myEventsRow = createMenu("My Events") { [weak self] in
            self?.navigationController?.pushViewController(CompanyFormViewController(), animated: true)
        }
        
        let newEventRow = createMenu("New Event") { [weak self] in
            self?.navigationController?.pushViewController(EventFormViewController(), animated: true)
        }
        
        //Profile
        let editProfileRow = createMenu("Profile") { [weak self] in
            self?.navigationController?.pushViewController(DetailViewController(), animated: true)
        }
        
        let logOutRow = createMenu("Log Out") { [weak self] in
            self?.delegate.connection?.viewController = self
            self?.delegate.connection?.logoutUser()
        }
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 40
            }
        }
        
        let createFooter: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelFooterView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 100
            }
        }
        
        // Create SectionFormers
        let companiesSection = SectionFormer(rowFormer: newCompanyRow)
            .set(headerViewFormer: createHeader("Companies"))
        
        companiesSection.add(rowFormers: [myCompaniesRow])
        
        let eventsSection = SectionFormer(rowFormer: newEventRow)
            .set(headerViewFormer: createHeader("Events"))
        
        let profileSection = SectionFormer(rowFormer: editProfileRow, logOutRow)
            .set(headerViewFormer: createHeader("Profile"))
            .set(footerViewFormer: createFooter("IFSP"))
        
        former.append(sectionFormer: companiesSection, eventsSection, profileSection)
    }
}
