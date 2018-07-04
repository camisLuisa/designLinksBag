//
//  AppDelegate.swift
//  design links bag
//
//  Created by Camila Luísa Farias on 02/07/18.
//  Copyright © 2018 Camila Luísa Farias. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    @IBOutlet weak var designHandBook: NSMenuItem!
    @IBOutlet weak var guidelines: NSMenuItem!
    @IBOutlet weak var downloadMasterFile: NSMenuItem!
    @IBOutlet weak var clay: NSMenuItem!
    @IBOutlet weak var marketingGuidelines: NSMenuItem!
    @IBOutlet weak var resources: NSMenuItem!
    @IBOutlet weak var filesRepository: NSMenuItem!
    @IBOutlet weak var inVision: NSMenuItem!
    @IBOutlet weak var milanote: NSMenuItem!
    @IBOutlet weak var trello: NSMenuItem!
    @IBOutlet weak var jira: NSMenuItem!
    @IBOutlet weak var liferay: NSMenuItem!
    @IBOutlet weak var community: NSMenuItem!
    @IBOutlet weak var marketplace: NSMenuItem!
    @IBOutlet weak var developerNetwork: NSMenuItem!
    @IBOutlet weak var dxpCe: NSMenuItem!
    @IBOutlet weak var dxpEe: NSMenuItem!
    @IBOutlet weak var forms: NSMenuItem!
    @IBOutlet weak var analyticsCloud: NSMenuItem!
    @IBOutlet weak var commerce: NSMenuItem!
    @IBOutlet weak var loop: NSMenuItem!
    @IBOutlet weak var internalToolsLoop: NSMenuItem!
    @IBOutlet weak var clockin: NSMenuItem!
    @IBOutlet weak var teamSite: NSMenuItem!
    @IBOutlet weak var github: NSMenuItem!
    @IBOutlet weak var dribbble: NSMenuItem!
    @IBOutlet weak var twitter: NSMenuItem!
    @IBOutlet weak var instagramLatam: NSMenuItem!
    @IBOutlet weak var instagramGlobal: NSMenuItem!
    @IBOutlet weak var wedeploy: NSMenuItem!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
//            button.action = #selector(printQuote(_:))
        }
//
        constructMenu()
        
       // NSWorkspace.shared.open(<#T##url: URL##URL#>)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
    func constructMenu() {
//        let menu = NSMenu()
//        
//        menu.addItem(NSMenuItem(title: "Test", action: #selector(
//            goToUrl), keyEquivalent: "D"))
        
        designHandBook.action = #selector(goToUrl1)
        guidelines.action = #selector(goToUrl2)
        downloadMasterFile.action = #selector(goToUrl3)
        clay.action = #selector(goToUrl4)
        marketingGuidelines.action = #selector(goToUrl5)
        resources.action = #selector(goToUrl6)
        filesRepository.action = #selector(goToUrl7)
        inVision.action = #selector(goToUrl8)
        milanote.action = #selector(goToUrl9)
        trello.action = #selector(goToUrl10)
        jira.action = #selector(goToUrl11)
        liferay.action = #selector(goToUrl12)
        community.action = #selector(goToUrl13)
        marketplace.action = #selector(goToUrl14)
        developerNetwork.action = #selector(goToUrl15)
        wedeploy.action = #selector(goToUrl16)
        dxpCe.action = #selector(goToUrl17)
        dxpEe.action = #selector(goToUrl18)
        forms.action = #selector(goToUrl19)
        analyticsCloud.action = #selector(goToUrl20)
        commerce.action = #selector(goToUrl21)
        loop.action = #selector(goToUrl22)
        internalToolsLoop.action = #selector(goToUrl23)
        clockin.action = #selector(goToUrl24)
        teamSite.action = #selector(goToUrl25)
        github.action = #selector(goToUrl26)
        dribbble.action = #selector(goToUrl27)
        twitter.action = #selector(goToUrl28)
        instagramLatam.action = #selector(goToUrl29)
        instagramGlobal.action = #selector(goToUrl30)
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
//        menu.addItem(NSMenuItem.separator())
//
        
       // statusItem.menu = menu
    }
    
    @objc func goToUrl1(){
        let url = URL(string: "https://liferaydesign-handbook.wedeploy.io/docs/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl2(){
        let url = URL(string: "https://lexicondesign.io/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl3(){
        let url = URL(
            string: "https://drive.google.com/file/d/1yuTAx42ZKvqc89yrCd8B2IsuCgwBc0Ci/view")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl4(){
        let url = URL(string: "https://clayui.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl5(){
        let url = URL(string: "https://blueprints.liferay.design/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl6(){
        let url = URL(string: "https://blueprints.liferay.design/docs/resources/color/digital.html")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl7(){
        let url = URL(string: "https://drive.google.com/drive/u/0/folders/1C5RdXruoiprdqPor-xmOJmmjUVlHE_NF")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl8(){
        let url = URL(string: "https://liferay.invisionapp.com/d/main")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl9(){
        let url = URL(string: "https://app.milanote.com/1C9Ufk00gD8895")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl10(){
        let url = URL(string: "https://trello.com/b/GA1KCHke/product-design-board")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl11(){
        let url = URL(string: "https://issues.liferay.com/secure/Dashboard.jspa")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl12(){
        let url = URL(string: "https://www.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl13(){
        let url = URL(string: "https://community.liferay.com")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl14(){
        let url = URL(string: "https://web.liferay.com/marketplace")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl15(){
        let url = URL(string: "https://dev.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl16(){
        let url = URL(string: "https://wedeploy.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl17(){
        let url = URL(string: "http://192.168.109.41:8181/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl18(){
        let url = URL(string: "http://192.168.109.41:7100/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl19(){
        let url = URL(string: "https://forms.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl20(){
        let url = URL(string: "https://analytics-dev.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl21(){
        let url = URL(string: "https://www.google.com")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl22(){
        let url = URL(string: "https://loop-uat.liferay.com")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl23(){
        let url = URL(string: "https://web.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl24(){
        let url = URL(string: "http://clockin.liferay.com/#/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl25(){
        let url = URL(string: "https://design.liferay.com/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl26(){
        let url = URL(string: "https://github.com/liferay-design")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl27(){
        let url = URL(string: "https://dribbble.com/liferay")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl28(){
        let url = URL(string: "https://twitter.com/Liferay_UX")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl29(){
        let url = URL(string: "https://www.instagram.com/liferaydesignlatam/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func goToUrl30(){
        let url = URL(string: "https://www.instagram.com/liferay_ux/")!
        NSWorkspace.shared.open(url)
    }
    
    


}

