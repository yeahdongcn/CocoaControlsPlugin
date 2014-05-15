CocoaControls.app and Xcode plugin
===================
[![Total views](https://sourcegraph.com/api/repos/github.com/yeahdongcn/RSImageOptimPlugin/counters/views.png)](https://sourcegraph.com/github.com/yeahdongcn/RSImageOptimPlugin)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/yeahdongcn/RSImageOptimPlugin/counters/views-24h.png)](https://sourcegraph.com/github.com/yeahdongcn/RSImageOptimPlugin)

OS X native application with Xcode plugin for browsing, searching, integrating, cloning controls in [Cocoa Controls](http://cocoacontrols.com/). 

#### Plugin screenshot
![screenshot](https://raw.githubusercontent.com/yeahdongcn/CocoaControlsPlugin/master/plugin_screenshot.png)

#### App screenshot
![screenshot](https://raw.githubusercontent.com/yeahdongcn/CocoaControlsPlugin/master/app_screenshot.png)


##TODO
* ~~Refresh and load more controls~~
* ~~Integrate Pods~~
* ~~Add refresh button and load more button at the bottom (for those people not using `Magic Mouse` or `Magic Trackpad`)~~

##Requirements

Xcode 5.0+ on OS X 10.9+.

##Installation

#### Build from Source

* Install pods.
* Build the Xcode project. The plug-in will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. 
* Relaunch Xcode.

To uninstall, just remove the plugin from `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` and restart Xcode.

## How does it work?

All the commands are laid at the bottom of the menu `View`.

* Use the menu `Cocoa Controls` to open `CocoaControls.app` immediately.
* `Click` on the `left image view` to open the image in a new window.
* `Click` on the `pod button` to integrate pod.
* `Click` on the `computer button` to clone the source.
* `Double click` on the `cell view` to open the control in browser.

##Thanks

Thanks [cocoapods-xcode-plugin](https://github.com/kattrali/cocoapods-xcode-plugin) from [Delisa Mason](https://github.com/kattrali) for the source to create/edit podfile.

##Credits

Star icons are taken from [Font Awesome](http://fontawesome.io/) and converted to png using [font-awesome-to-png](https://github.com/odyniec/font-awesome-to-png).

Filter icon is taken from [Anton Volodin](https://dribbble.com/cuzmich) [Icon](https://dribbble.com/shots/444019-Icons?list=users&offset=0).

CocoaPods logo is taken from [CocoaPods](http://cocoapods.org/).

Desktop icon is taken from [Github](https://github.com).

Mouse scroller helper icons are taken from [Budi Tanrim](https://dribbble.com/buditanrim)'s [budicon tester](https://dribbble.com/shots/1182482-budicon-tester?list=users&offset=21).

All data is taken from [Cocoa Controls](http://cocoacontrols.com/).

##License

    The MIT License (MIT)

    Copyright (c) 2012-2014 P.D.Q.

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

