//
//  AlbumDetailViewController.swift
//  Top100
//
//  Created by Manpreet on 27/10/2020.
//

import UIKit
import Combine

class AlbumDetailViewController: UIViewController {
    
    var album: Album? = nil
    private var cancellable: AnyCancellable?
    fileprivate let activityView: UIActivityIndicatorView = .init(style: .large)
    
    private let imageVw: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let verticalStackVw: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemBlue
        button.setTitle(NSLocalizedString("Open in Apple Music", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(self.albumButtonPressed), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = album?.artistName
        self.view.backgroundColor = .white
        view.addSubview(imageVw)
        imageVw.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        addStackView()
        view.addSubview(albumButton)
        albumButton.addConstraint(NSLayoutConstraint.init(item: albumButton,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1,
                                                          constant: 50))
        cancellable = AlbumImage.loadImage(for: album!).sink { [unowned self] image in
            activityView.stopAnimating()
            imageVw.image = image
        }
        let horizontalVFL = ["H:|-[image]-|","H:|-[stack]-|","H:|-[button]-|"]
        for vfl in horizontalVFL {
            self.addConstraintsFromVFL(vfl, metrics: ["spacing":10])
        }
        let verticalVFL = ["V:|-[image]-50-[stack]-50-[button]"]
        for vfl in verticalVFL {
            self.addConstraintsFromVFL(vfl, metrics: ["spacing":10])
        }
        self.runSpinAnimationOn(view: self.imageVw, duration: 1, rotation: Double.pi / 2 / 60, repeatCount: MAXFLOAT)
    }
    
    
    private func addStackView() {
        guard let viewModel = album else {
            return
        }
        let albumLbl = makeLabel(descriptionText: NSLocalizedString("Title", comment: "album title"),
                                 valueText: viewModel.name ?? "")
        let artistLbl = makeLabel(descriptionText: NSLocalizedString("Artist", comment: "artist name"),
                                  valueText: viewModel.artistName ?? "")
        let genreDescription = NSLocalizedString("Genre(s)", comment: "genre")
        let genreLbl = makeLabel(descriptionText: genreDescription, valueText:  album?.genreStr ?? "")
        let releaseDateLbl = makeLabel(descriptionText: NSLocalizedString("Release Date", comment: "release date"),
                                       valueText: viewModel.releaseDate ?? "")
        let advisoryLbl = makeLabel(descriptionText: NSLocalizedString("Content Advisory",
                                                                       comment: "advisory rating"),
                                    valueText:viewModel.contentAdvisoryRating ?? "")
        let copyrightLbl = makeLabel(descriptionText: NSLocalizedString("Copyright",
                                                                        comment: "Copyright"),
                                     valueText: viewModel.copyright ?? "")
        verticalStackVw.addArrangedSubviews([albumLbl, artistLbl, genreLbl, releaseDateLbl, advisoryLbl, copyrightLbl])
        view.addSubview(verticalStackVw)
    }
    
    @objc private func albumButtonPressed() {
        
        guard let url = URL(string:album?.url ?? "") else { return }
        
        guard UIApplication.shared.canOpenURL(url) else {
            MAAlertview.showAlertWrapper(alertTitle: NSLocalizedString("Error", comment: "Error title"), alertMessage: NSLocalizedString("URLError", comment: "Error with url"))
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private func makeLabel(descriptionText: String, valueText: String) -> UILabel {
        let textToBold = "\(descriptionText):  "
        let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: textToBold, attributes: boldAttributes)
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        attributedString.append(NSMutableAttributedString(string: valueText, attributes: normalAttributes))
        let label = UILabel()
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    private func addConstraintsFromVFL(_ vfl:String, metrics:[String:Any]) {
        let viewMap = ["button": albumButton, "stack": verticalStackVw, "image": imageVw]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl,
                                                                metrics: metrics,
                                                                views: viewMap))
    }
    
    func runSpinAnimationOn(view: UIView, duration: Double, rotation: Double, repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2.0 * rotation * duration)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        view.layer.add(animation, forKey: "rotationAnimation")
        
    }
    
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
