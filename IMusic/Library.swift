//
//  Library.swift
//  IMusic
//
//  Created by Никита Егоров on 07.11.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                VStack {
                    GeometryReader { geometry in
                        HStack(spacing: 20) {
                            Button(action: {
                                print("123")
                                self.track = self.tracks[0]
                                self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                            }, label: {
                                Image(systemName: "play.fill")
                                    .frame(width: (geometry.size.width / 2) - 10, height: 50)
                                    .accentColor(Color.init(#colorLiteral(red: 1, green: 0.41908848, blue: 0.6198067967, alpha: 1)))
                                    .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).cornerRadius(10)
                                
                            })
                            
                            Button(action: {
                                print("456")
                                self.tracks = UserDefaults.standard.savedTracks()
                            }, label: {
                                Image(systemName: "arrow.2.circlepath")
                                    .frame(width: (geometry.size.width / 2) - 10, height: 50)
                                    .accentColor(Color.init(#colorLiteral(red: 1, green: 0.41908848, blue: 0.6198067967, alpha: 1)))
                                    .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).cornerRadius(10)
                            })
                            
                        }
                    }.padding().frame(height: 50)
                    
                    Divider().padding(.leading).padding(.trailing)
                    
                    List {
                        ForEach(tracks) { track in
                            LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ _ in
                                print("Pressed!")
                                self.track = track
                                self.showAlert = true
                            }).simultaneously(with: TapGesture().onEnded({ _ in
                                
                                let keyWindow = UIApplication.shared.connectedScenes.filter ({
                                    $0.activationState == .foregroundActive
                                }).map {($0 as? UIWindowScene)}.compactMap({
                                    $0
                                }).first?.windows.filter({
                                    $0.isKeyWindow
                                }).first
                                
                                let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                tabBarVC?.trackDetailView.delegate = self
                                
                                self.track = track
                                self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                            })))
                        }.onDelete(perform: delete)
                    }
                }.actionSheet(isPresented: $showAlert, content: {
                    ActionSheet(title: Text("Are you sure you want to delete this track?"), buttons: [.destructive(Text("Delete"), action: {
                        print("Deleting:\(self.track.trackName)")
                        self.delete(track: self.track)
                    }), .cancel()])
                })
                
                
                .navigationTitle("Library")
            } else {
                // Fallback on earlier versions
            }
        }
    }
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
}

struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            Image("Image").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
        
    }
    
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
extension Library: TrackMovingDelegate {
    func moveBackForPrevious() -> SearchViewModel.Cell? {
        print("111")
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack =  tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForPrevious() -> SearchViewModel.Cell? {
        print("222")
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack =  tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}
