import AppKit
import Cocoa
import FlutterMacOS

class PopoverContainerViewController: NSViewController {
    let flutterViewController: FlutterViewController

    init(flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 360, height: 250))
        addChild(flutterViewController)
        flutterViewController.view.frame = self.view.bounds
        flutterViewController.view.autoresizingMask = [.width, .height]
        flutterViewController.view.wantsLayer = true
        flutterViewController.view.layer?.backgroundColor = NSColor.clear.cgColor
        flutterViewController.view.layer?.isOpaque = false
        flutterViewController.view.window?.isOpaque = false
        flutterViewController.view.window?.backgroundColor = NSColor.clear
        self.view.addSubview(flutterViewController.view)
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        self.view.layer?.isOpaque = false

    }
}


class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: 18.0)
        
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "menu_icon") //change this to your desired image
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            // The popover's window isn't created until after `show` — adjust window properties after showing
            if let popWindow = popover.contentViewController?.view.window {
                popWindow.isOpaque = false
                popWindow.backgroundColor = NSColor.clear
                popWindow.hasShadow = false
                // ensure content view's layer is transparent
                popWindow.contentView?.wantsLayer = true
                popWindow.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
            }
            popover.contentViewController?.view.window?.makeKey()
            
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }
}
