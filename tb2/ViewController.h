//
//  ViewController.h
//  tb2
//
//  Created by dt on 2018/12/28.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FMDB.h"
@interface ViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSButton *start;
@property (weak) IBOutlet NSSearchField *searchField;
@property NSString* searchString;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *label;
@property float  sliderValue;
@property NSTimer *timer;
@property NSMutableArray* inData;
@property BOOL buttonInvalid;
@end

