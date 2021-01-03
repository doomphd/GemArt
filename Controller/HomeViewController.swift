//
//  HomeViewController.swift
//  GEM-ART
//
//  Created by Truman Tang on 12/4/20.
//  Copyright © 2020 Truman Tang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate   {

    
       @IBOutlet weak var searchBar: UISearchBar!
       @IBOutlet weak var collection: UICollectionView!
       var stickers = [Stickers]()
       var inSearchMode = false
       var filteredSticker = [Stickers]()



       
       
       override func viewDidLoad() {
           super.viewDidLoad()
           collection.delegate = self
           collection.dataSource = self
           searchBar.delegate = self
           searchBar.returnKeyType = UIReturnKeyType.done
           parseStickerCSV()
       }
           func parseStickerCSV(){
               let path = Bundle.main.path(forResource: "sticker", ofType: "csv")!
               do{
                   let csv = try CSV(contentsOfURL: path)
                   let rows = csv.rows
                   
                   for row in rows{
                       let ID = Int(row["Id"]!)!
                       let name = row["identifier"]!
                       let sticker = Stickers( name: name, Id: ID)
                       stickers.append(sticker)
                   }
                   
               }
               catch let err as NSError{
                   print(err.debugDescription)
               }
               
               
           }

           func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               
               if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as? StickerCell {
              
                   let stick: Stickers!
                   if inSearchMode {
                       stick = filteredSticker[indexPath.row]}
                   else {
                       stick = stickers[indexPath.row]
                   }
                   
                   cell.configureCell(stickers: stick)
                   return cell
               }
               else {
                   return UICollectionViewCell()
               }
           }
           func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
               let stick: Stickers!
               
               if inSearchMode {
                   stick = filteredSticker[indexPath.row]}
               else {
                   stick = stickers[indexPath.row]
               }
           
               performSegue(withIdentifier: "StickerDetailVC", sender: stick)
               
               
           }
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               if inSearchMode{
                   return filteredSticker.count
               }
               else{
               return stickers.count
               }
           }
           func numberOfSections(in collectionView: UICollectionView) -> Int {
               return 1
           }
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 105, height: 105)
           }
           func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
               view.endEditing(true)
           }
           func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
           {
                   if searchBar.text == nil || searchBar.text == ""
                   {
                       inSearchMode = false
                       view.endEditing(true)
                       collection.reloadData()
               }
               else
               {
                   inSearchMode = true
                   let lower = searchBar.text!.lowercased()
                   filteredSticker = stickers.filter({$0.name.lowercased().range(of: lower) != nil})

                   collection.reloadData()
               }
           }
           override func prepare(for segue: UIStoryboardSegue, sender: Any?)
           {
               if segue.identifier == "StickerDetailVC"
               {
                   if let detailsVC = segue.destination as? StickerDetailVC
                   {
                       if let stick = sender as? Stickers
                       {
                           detailsVC.stick = stick
                       }
                   }
               }
           }
         
       }


      
