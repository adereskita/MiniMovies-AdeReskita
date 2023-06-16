//
//  SelfSizedTableView.swift
//  MiniMovies
//
//  Created by Ade on 6/16/23.
//

import UIKit

public class SelfSizedTableView: UITableView {
    
    
    public override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    public override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    public override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
}
