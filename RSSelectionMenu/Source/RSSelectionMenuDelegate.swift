//
//  RSSelectionMenuDelegate.swift
//
//  Copyright (c) 2017 Rushi Sangani
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

open class RSSelectionMenuDelegate: NSObject {

    // MARK: - Properties
    
    /// tableview cell selection delegate
    var selectionDelegate: UITableViewCellSelection? = nil
    
    /// selected objects
    fileprivate var selectedObjects: DataSource = []
    
    // MARK: - Initialize
    convenience init(selectedItems: DataSource) {
        self.init()
        selectedObjects = selectedItems
    }
}

// MARK:- Private
extension RSSelectionMenuDelegate {
    
    /// action handler for single selection tableview
    fileprivate func handleActionForSingleSelection(object: AnyObject, tableView: RSSelectionTableView) {
        
        // remove all
        selectedObjects.removeAll()
        
        // add to selected list
        selectedObjects.append(object)
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, true, selectedObjects)
        }
    }
    
    /// action handler for multiple selection tableview
    fileprivate func handleActionForMultiSelection(object: AnyObject, tableView: RSSelectionTableView) {
        
        // is selected
        var isSelected = false
        
        // remove if already selected
        if let selectedIndex = RSSelectionMenu.isSelected(object: object, from: selectedObjects) {
            selectedObjects.remove(at: selectedIndex)
        }
        else {
            selectedObjects.append(object)
            isSelected = true
        }
        
        // reload tableview
        tableView.reloadData()
        
        // selection callback
        if let delegate = selectionDelegate {
            delegate(object, isSelected, selectedObjects)
        }
    }
    
}

// MARK:- Public
extension RSSelectionMenuDelegate {
    
    /// check for selection status
    public func showSelected(object: AnyObject) -> Bool {
        return RSSelectionMenu.containsObject(object, inDataSource: selectedObjects)
    }
}

// MARK:- UITableViewDelegate
extension RSSelectionMenuDelegate: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let selectionTableView = tableView as! RSSelectionTableView
        
        // selected object
        let dataObject = selectionTableView.objectAt(indexPath: indexPath)
        
        // single selection
        if selectionTableView.selectionType == .single {
            handleActionForSingleSelection(object: dataObject, tableView: selectionTableView)
        }
        else {
            // multiple selection
            handleActionForMultiSelection(object: dataObject, tableView: selectionTableView)
        }
        
        // dismiss if required
        selectionTableView.dismissControllerIfRequired()
    }
}