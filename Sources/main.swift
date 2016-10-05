//
//  main.swift
//  CustomResizer
//
//  Created by Raul Martinez Padilla on 11/5/16.
//  Copyright © 2016 Deceroainfinito. All rights reserved.
//

import Foundation

func shell(args: String...) -> Int32 {
  let task = Process()
  task.launchPath = args[0]
  task.arguments = Array(args.dropFirst(1))
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

let fm         = FileManager.default

do {
  let desktopURL = fm.urls(for: .desktopDirectory, in: .userDomainMask).first!
  let contents  = try fm.contentsOfDirectory(at: desktopURL, includingPropertiesForKeys: nil, options: [])
  let pngsPaths = contents.filter { $0.pathExtension == "png" && !$0.lastPathComponent.contains("@") }.map { $0.path }

  pngsPaths.forEach({ pngPath in
    print(shell(args: "/usr/bin/sips", "--resampleHeight", "144", pngPath, "--out", "\(pngPath)@3x.png"))
    print(shell(args: "/usr/bin/sips", "--resampleHeight", "96", pngPath, "--out", "\(pngPath)@2x.png"))
    print(shell(args: "/usr/bin/sips", "--resampleHeight", "48", pngPath, "--out", "\(pngPath).png"))

    // shell("/usr/bin/sips", "--resampleHeightWidth", "180", "180", imageFullName, "--out", "\(absolutePathName)@3x.png")
    // shell("/usr/bin/sips", "--resampleHeightWidth", "120", "120", imageFullName, "--out", "\(absolutePathName)@2x.png")
  })

} catch let error {
  print(error)
}
