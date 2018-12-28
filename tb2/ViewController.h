//
//  ViewController.h
//  tb2
//
//  Created by dt on 2018/12/28.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *label;

@property NSMutableArray* inData;
@end

