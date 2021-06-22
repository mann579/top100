//
//  AlbumTableViewCell.swift
//  Top100
//
//  Created by Manpreet on 28/10/2020.
//

import UIKit
import Foundation
import Combine

class AlbumTableViewCell: UITableViewCell {
    
    private var cancellable: AnyCancellable?
    fileprivate let activityView: UIActivityIndicatorView = .init(style: .large)
    var tableViewHeight: CGFloat = 66.0
    private let imageVw: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let nameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        backgroundColor = UIColor.systemBackground
        activityView.color = UIColor.init(white: 1, alpha: 1)
        contentView.addSubview(imageVw)
        imageVw.addSubview(activityView)
        activityView.hidesWhenStopped = true
        self.imageVw.translatesAutoresizingMaskIntoConstraints = false
        self.imageVw.clipsToBounds = true
        self.imageVw.layer.cornerRadius = 10
        imageVw.addConstraint(NSLayoutConstraint.init(item: imageVw,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 50))
        imageVw.addConstraint(NSLayoutConstraint.init(item: imageVw,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 50))
        activityView.center = CGPoint(x: imageVw.center.x + 25,
                                      y: imageVw.center.y + 25)
        contentView.addSubview(titleLbl)
        self.titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLbl)
        self.nameLbl.translatesAutoresizingMaskIntoConstraints = false
        let horizontalVFL = ["H:|-[image]-[title]-|","H:|-[image]-[name]-|"]
        for vfl in horizontalVFL {
            self.addConstraintsFromVFL(vfl, metrics: ["spacing":10])
        }
        let verticalVFL = ["V:|-[image]-|","V:|-[title]-[name]-|"]
        for vfl in verticalVFL {
            self.addConstraintsFromVFL(vfl, metrics: ["spacing":10])
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraintsFromVFL(_ vfl:String, metrics:[String:Any]) {
        let viewMap = ["title": titleLbl, "name": nameLbl, "image": imageVw]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl,
                                                                       metrics: metrics,
                                                                       views: viewMap))
    }
    
}
