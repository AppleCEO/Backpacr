//
//  CollectionViewCell.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/11.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        sellerLabel.text = nil
    }
    
    func putInfo(_ storeItem: Body) {
        self.titleLabel.text = storeItem.title
        self.sellerLabel.text = storeItem.seller
        
        if let image = loadImage(from: storeItem.thumbnail520) {
            self.imageView.image = image
        }
    }
    
    private func loadImage(from imageUrl: String) -> UIImage? {
        guard let url = URL(string: imageUrl) else {
            return UIImage(named: "baseline_sentiment_dissatisfied_black_48pt")
        }
        guard let data = try? Data(contentsOf: url) else {
            return UIImage(named: "baseline_sentiment_dissatisfied_black_48pt")
        }
        
        let image = UIImage(data: data)
        
        return image
    }
}
