//
//  DetailVC.swift
//  CDwithAPI
//
//  Created by admin on 10/12/24.
//

import UIKit
import CoreData

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tablevc1: UITableView!
    
    var saveJokes:[JokeModel]=[]
    
    var selectedjoke:JokeModel!
    
    override func viewWillAppear(_ animated: Bool) {
        readcd()
        tablevc1.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate"{
            if let update = segue.destination as? UpdateVC{
                update.getjoke=selectedjoke
            }
        }
    }
    
    func setup(){
        tablevc1.delegate=self
        tablevc1.dataSource=self
        tablevc1.register(UINib(nibName: "JokeCell", bundle: nil), forCellReuseIdentifier: "JokeCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        cell.idlbl.text=String(saveJokes[indexPath.row].id)
        cell.typelbl.text = saveJokes[indexPath.row].type
        cell.setuplbl.text = saveJokes[indexPath.row].setup
        cell.punchlinelbl.text=saveJokes[indexPath.row].punchline
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete=UIContextualAction(style: .destructive, title: "delete"){action,source,completion in
            self.saveJokes.remove(at: indexPath.row)
            
            let jokeToDelete = self.saveJokes[indexPath.row]
            self.deletecd(Jokes: jokeToDelete)
         
            
            self.tablevc1.reloadData()
        }
        let configure=UISwipeActionsConfiguration(actions: [delete])
        configure.performsFirstActionWithFullSwipe=false
        return configure
        
        
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "update"){(action,view,completionHandler)in
            self.selectedjoke = self.saveJokes[indexPath.row]
            self.performSegue(withIdentifier: "GoToUpdate", sender: self)
            
            completionHandler(true)
        }
        update.backgroundColor = .systemBlue

       let updateAction=UISwipeActionsConfiguration(actions: [update])
        return updateAction
    }
    
    
    
    
    
    
    
    
    
    func readcd(){
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else
        {return }
        
        let managecontext=delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jokes")
        
        do{
            let res = try managecontext.fetch(fetchRequest)
            debugPrint("fetch from CD sucessfully")
            saveJokes=[]

            
            for data in res as! [NSManagedObject]{
                
                let jid=data.value(forKey: "id") as! Int32
                let jtype=data.value(forKey: "type") as! String
                let jsetup=data.value(forKey: "setup") as! String
                let jpunchline=data.value(forKey: "punchline") as! String
                saveJokes.append(JokeModel(id: Int(jid), type: jtype, setup: jsetup, punchline: jpunchline))
            }
            
        }
        catch let err as NSError {
            debugPrint("could not save to CoreData. Error: \(err)")
        }
        
    }
    
    func deletecd(Jokes:JokeModel){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managecontext=delegate.persistentContainer.viewContext
        let fetchrequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Jokes")
        
        fetchrequest.predicate=NSPredicate(format: "id = %d", Jokes.id)
        
        
        do {
            let fetchres=try managecontext.fetch(fetchrequest)
            let objToDelete=fetchres[0] as! NSManagedObject
            managecontext.delete(objToDelete)
            
            try managecontext.save()
            print("user deleted successfully")
            
        } catch let err as NSError {
            print("Somthing went wrong while deleting \(err)")
        }
        
    }
}
    
    
    
    
   


