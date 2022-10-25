//
//  RedditTableViewCell.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import UIKit

class RedditTableViewCell: UITableViewCell {

    // MARK: UI
    let thumbnailImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: ConstantValues.sizes.fontSize.rawValue)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Model
    var redditElement:ChildrenData? {
        didSet {
            guard let item = redditElement else {
                return
            }
            titleLabel.text = item.title
            thumbnailImageView.fetchImage(from: item.thumbnail, placeholder: UIImage(named: URLStrings.imageAssets.placeholder.rawValue))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(thumbnailImageView)
        containerView.addSubview(titleLabel)
        self.contentView.addSubview(containerView)
        // Constraints Thumbnail image
        thumbnailImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:ConstantValues.margins.leadingTrailing.rawValue).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant:ConstantValues.sizes.thumbnailHeight.rawValue).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant:ConstantValues.sizes.thumbnailHeight.rawValue).isActive = true
        // Constraints Container view
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.thumbnailImageView.trailingAnchor, constant:ConstantValues.margins.leadingTrailing.rawValue).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-ConstantValues.margins.leadingTrailing.rawValue).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:ConstantValues.sizes.thumbnailHeight.rawValue).isActive = true
        // Constraints Reddit Title Label
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
