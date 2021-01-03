//
//  ViewController.swift
//  GEM-ART
//
//  Created by Truman Tang on 9/13/20.
//  Copyright © 2020 Truman Tang. All rights reserved.
//
import SideMenu
import UIKit
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate,  MenuControllerDelegate {

    

    
    
   @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
  var stickers = [Stickers]()
var inSearchMode = false
  var filteredSticker = [Stickers]()
    private var sideMenu: SideMenuNavigationController?
    private let aboutUsController = AboutUsViewController()
    private let howToBuyController = HowToBuyViewController()
    private let contactUsController = ContactUsViewController()
  //  private let viewController = ViewController()


    
    	
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuC(with: ["Home",
        "How to Buy",
        "About Us",
        "Contact Us"])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
    collection.delegate = self
      collection.dataSource = self
    searchBar.delegate = self
     searchBar.returnKeyType = UIReturnKeyType.done
    parseStickerCSV()
    }
    private func addChildControllers() {
        addChild(aboutUsController)
        addChild(howToBuyController)
        addChild(contactUsController)
     //   addChild(viewController)
        
        view.addSubview(aboutUsController.view)
        view.addSubview(howToBuyController.view)
        view.addSubview(contactUsController.view)
      //  view.addSubview(viewController.view)
        
        aboutUsController.view.frame = view.bounds
        howToBuyController.view.frame = view.bounds
        contactUsController.view.frame = view.bounds
      //  viewController.view.frame = view.bounds
        
        aboutUsController.didMove(toParent: self)
        howToBuyController.didMove(toParent: self)
        contactUsController.didMove(toParent: self)
      //  viewController.didMove(toParent: self)

        
        aboutUsController.view.isHidden = true
        howToBuyController.view.isHidden = true
        contactUsController.view.isHidden = true
   //     viewController.view.isHidden = false


    }
    @IBAction func didTapMenuButton(){
        present(sideMenu!, animated: true)
    }
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            self?.title = named
            
            if named == "Home"{
      //          self?.viewController.view.isHidden = false
                self?.aboutUsController.view.isHidden = true
                self?.howToBuyController.view.isHidden = true
                self?.contactUsController.view.isHidden = true

            }
            else if named == "How to Buy"{
      //          self?.viewController.view.isHidden = true
                self?.aboutUsController.view.isHidden = true
                self?.howToBuyController.view.isHidden = false
                self?.contactUsController.view.isHidden = true
            }
            else if named == "About Us"{
        //        self?.viewController.view.isHidden = true
                self?.aboutUsController.view.isHidden = false
                self?.howToBuyController.view.isHidden = true
                self?.contactUsController.view.isHidden = true
            }
            else if named == "Contact Us"{
     //           self?.viewController.view.isHidden = true
                self?.aboutUsController.view.isHidden = true
                self?.howToBuyController.view.isHidden = true
                self?.contactUsController.view.isHidden = false
                
            }
        })
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


           

      
    


   
