//
//  ViewController.swift
//  CDwithAPI
//
//  Created by admin on 10/12/24.
//

import UIKit
import CoreData

class ViewController: UIViewController  {
   
    

    var jokearr:[JokeModel]=[]
    
    @IBOutlet weak var tablevc: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callJokeApi()
        
    }
    
    @IBAction func viewbtn(_ sender: Any) {
        performSegue(withIdentifier: "GoToNext", sender: self)
    }
    func addtocd(jokeobject:JokeModel){
        guard let delegte = UIApplication.shared.delegate as? AppDelegate
        else {return}
        
        let managedcontext = delegte.persistentContainer.viewContext
        
        guard let jokeEntity=NSEntityDescription.entity(forEntityName: "Jokes", in: managedcontext) else{
            return
        }
        
        let joke=NSManagedObject(entity: jokeEntity, insertInto: managedcontext)
        
        joke.setValue(jokeobject.id, forKey: "id")
        joke.setValue(jokeobject.type, forKey: "type")
        joke.setValue(jokeobject.setup, forKey: "setup")
        joke.setValue(jokeobject.punchline, forKey: "punchline")
        
        do {
            try managedcontext.save()
            debugPrint("Data saved")
        } catch let err as NSError {
            debugPrint("could not save to CoreData. Error: \(err)")
        }
        
        
        
    }

    func callJokeApi(){
        ApiManager().fetchJokes{ result in
            switch result {
                
            case.success(let data):
                self.jokearr.append(contentsOf: data)
                print(self.jokearr)
                self.tablevc.reloadData()
               
                
            case.failure(let failure):
                debugPrint("something went wrong in calling API")
              
            }
        }
    }

}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func setup(){
        tablevc.delegate=self
        tablevc.dataSource=self
        tablevc.register(UINib(nibName: "JokeCell", bundle: nil), forCellReuseIdentifier: "JokeCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokearr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        cell.idlbl.text=String(jokearr[indexPath.row].id)
        cell.typelbl.text = jokearr[indexPath.row].type
        cell.setuplbl.text = jokearr[indexPath.row].setup
        cell.punchlinelbl.text=jokearr[indexPath.row].punchline
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let joke = jokearr[indexPath.row]
        addtocd(jokeobject: JokeModel(id: joke.id, type: joke.type, setup: joke.setup, punchline: joke.punchline))
        
    }
}

