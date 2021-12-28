//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 12/3/21.
//

import UIKit
import CoreData

class ConsolesTableViewController: UITableViewController {
    
    // esse tipo de classe oferece mais recursos para monitorar os dados
    var fetchedResultController: NSFetchedResultsController<Console>!

    override func viewWillAppear(_ animated: Bool) {
        loadConsoles()
    }
    
    func loadConsoles() {
        ConsolesManager.shared.loadConsoles(with: context)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ConsolesManager.shared.consoles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONSOLE CELL", for: indexPath) as! ConsoleTableViewCell
        let console = ConsolesManager.shared.consoles[indexPath.row]
        cell.prepare(with: console)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            if ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if let vc = segue.destination as? AddConsoleViewController {
            if (segue.identifier == "EDIT CONSOLE") {
            let console = ConsolesManager.shared.consoles[tableView.indexPathForSelectedRow!.row]
            vc.console = console
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions / Acoes
    
    
} // fim da classe
