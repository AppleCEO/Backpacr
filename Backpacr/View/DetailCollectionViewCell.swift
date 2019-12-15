//
//  DetailCollectionViewCell.swift
//  Backpacr
//
//  Created by joon-ho kil on 2019/12/14.
//  Copyright © 2019 joon-ho kil. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func putInfo(_ imageURL: String) {
        if let image = loadImage(from: imageURL) {
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

