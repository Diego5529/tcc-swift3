//
//  CompanyListViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 28/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit
import CoreData
import Former

class CompanyListViewController: FormViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var delegate: AppDelegate!
    var companies: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            let results = try CompanyDao.selectAllCompanies(db: delegate.db.fmDatabase)
            
            if results.count > 0 {
                print(results)
                
                for company in results {
                    if let key = (company as AnyObject).value(forKey: "title") {
                        let companyClass = CompanyBean().serializer(companyObject: company as AnyObject)
                        
                        companies .setValue(companyClass, forKey: key as! String)
                        print(key)
                    }
                }
            }
        }catch{
            
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
        let newCompanyRow = createMenu("New Company") { [weak self] in
            self?.navigationController?.pushViewController(CompanyFormViewController(), animated: true)
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
        let optionsSection = SectionFormer(rowFormer: newCompanyRow)
            .set(headerViewFormer: createHeader("Options"))
        
        let arrayCompaniesRow = NSMutableArray()
        
        for company in companies {
            let companyRow = createMenu(company.key as! String) { [weak self] in
                let companyVC = CompanyFormViewController()
                companyVC.companyClass = company.value as! CompanyBean
                
                self?.navigationController?.pushViewController(companyVC, animated: true)
            }
            
            arrayCompaniesRow.add(companyRow)
        }
        
        let companiesSection = SectionFormer(rowFormers: arrayCompaniesRow as! [RowFormer])
            .set(headerViewFormer: createHeader("My Companies"))
        
        former.append(sectionFormer: optionsSection, companiesSection)
    }
}
