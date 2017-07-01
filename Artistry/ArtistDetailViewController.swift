import UIKit

class ArtistDetailViewController: UIViewController {
  
  var selectedArtist: Artist!
  
  let moreInfoText = "Select For More Info >"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedArtist.name
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    NotificationCenter.default.addObserver(
    forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
      self?.tableView.reloadData()
    }
  }
  
}

extension ArtistDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedArtist.works.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkTableViewCell
    
    let work = selectedArtist.works[indexPath.row]
    
    cell.workTitleLabel.text = work.title
    cell.workImageView.image = work.image
    
    cell.workTitleLabel.backgroundColor = UIColor(white: 204/255, alpha: 1)
    cell.workTitleLabel.textAlignment = .center
    cell.moreInfoTextView.textColor = UIColor(white: 114/255, alpha: 1)
    cell.selectionStyle = .none
    
    cell.moreInfoTextView.text = work.isExpanded ? work.info : moreInfoText
    cell.moreInfoTextView.textAlignment = work.isExpanded ? .left : .center
    
    // Adding Dynamic Type
    cell.workTitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    cell.moreInfoTextView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    
    return cell
  }
}

extension ArtistDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // ask the tableview for a reference to the cell of the selected index path then get the work object
    guard let cell = tableView.cellForRow(at: indexPath) as? WorkTableViewCell else { return }
    
    var work = selectedArtist.works[indexPath.row]
    
    // change the state of the work object then put it back to the array
    work.isExpanded = !work.isExpanded
    selectedArtist.works[indexPath.row] = work
    
    // alter the text view of the cell, depending on if the work is expanded or not.
    cell.moreInfoTextView.text = work.isExpanded ? work.info : moreInfoText
    cell.moreInfoTextView.textAlignment = work.isExpanded ? .left : .center
    
    // the tableview needs to refresh the cell height now. Force the tableview to refresh the height
    tableView.beginUpdates()
    tableView.endUpdates()
    
    // tell the tableview to scroll the selected row to the top of the tableview
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
}

