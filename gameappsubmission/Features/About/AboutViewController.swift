//
//  AboutViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 06/06/24.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var creditLabel: UILabel!

    let creditRedirectUrl = "https://www.flaticon.com/free-icons/back-arrow"

    override func viewDidLoad() {
        super.viewDidLoad()
        let creditText = """
    <a href=\(creditRedirectUrl)
    title="back arrow icons">Back arrow icons created by Ilham Fitrotul Hayat - Flaticon</a>
    """
        creditLabel.attributedText = creditText.htmlToAttributedString
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.redirectToCreditUrl))
        creditLabel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @objc
    func redirectToCreditUrl() {
            let link = URL(string: creditRedirectUrl)
            guard let link = link else {return}
            UIApplication.shared.open(link)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
