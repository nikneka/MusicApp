//
//  TrackCell.swift
//  IMusic
//
//  Created by Никита Егоров on 27.10.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    
    //only for xib file
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }
        
//        print(self.cell?.trackName)
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func addTrackAction(_ sender: Any) {
        print("444")
        let defaults = UserDefaults.standard
//        defaults.set(25, forKey: "Age")
//        defaults.set("hello", forKey: "String")
        guard let cell = cell else { return }
        addTrackOutlet.isHidden = true
    
        var listOfTracks = defaults.savedTracks()
        
        listOfTracks.append(cell)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            print("Успешно")
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    @IBAction func showTrackAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data {
            if let decodedTrack = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] {
                decodedTrack.map { (track) in
                    print(track.trackName)
                }
            }
        }
    }
}
