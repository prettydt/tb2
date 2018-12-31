//
//  ViewController.m
//  tb2
//
//  Created by dt on 2018/12/28.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (IBAction)searchAction:(id)sender {
    NSLog(@"%@",self.searchField.stringValue);
//    self.inData = [self searchTest:self.searchField.stringValue InArray:self.inData];
  //  [self.tableView reloadData];
}
- (NSMutableArray *)searchTest:(NSString *)searchText InArray:(NSArray *)array {
    
    NSMutableArray *tmpArray = [NSMutableArray array];
            NSLog(@"array==%@",[array[0] objectForKey:@"symbol"]);
    for (int i=0; i<array.count; i++) {
        
   //     NSString *larg1 = [searchText uppercaseString];
    //    NSString *larg2 = [array[i][1] uppercaseString];
        if ([[array[i] objectForKey:@"symbol"] containsString:searchText])
        {
            [tmpArray addObject: array[i]];
        }
    }
    
    return tmpArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://hq.sinajs.cn/list=sh600125"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    NSLog(@"retStr%@",retStr);
    NSArray  *array = [retStr componentsSeparatedByString:@","];//分隔符逗号
        NSLog(@"retStr%@",array[2]);
    NSArray *testArr = [array sortedArrayUsingSelector:@selector(compare:)];
            NSLog(@"testArr%@",testArr);
//
//    NSString *urlString = @"https://hq.sinajs.cn/list=sh600125";
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //block 参数的解释
//        //response 响应头的信息
//        //data 我们所需要的真是的数据
//        //connectionError 链接服务器的错误信息
//        NSLog(@"请求到数据了");
//        NSLog(@"response%@",response);
//        NSLog(@"data%@",data);
//    }];
    
    self.inData = [[NSMutableArray alloc]init];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"0930" forKey:@"time"];
    [dic setObject:@"603999"forKey:@"symbol"];
    [dic setObject:@"读者传媒"forKey:@"name"];
    [dic setObject:@"5.04"forKey:@"sale"];
    [dic setObject:@"5.04"forKey:@"buy"];
    [dic setObject:@"12700"forKey:@"dealCount"];
    [self.inData addObject:dic];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [dic2 setObject:@"0931" forKey:@"time"];
    [dic2 setObject:@"603123"forKey:@"symbol"];
    [dic2 setObject:@"读者传媒"forKey:@"name"];
    [dic2 setObject:@"5.02"forKey:@"sale"];
    [dic2 setObject:@"5.03"forKey:@"buy"];
    [dic2 setObject:@"268300"forKey:@"dealCount"];
    [self.inData addObject:dic2];
    NSLog(@"%@",self.inData);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    
    //table view 排序
//    NSSortDescriptor *time = [NSSortDescriptor sortDescriptorWithKey:self.inData ascending:<#(BOOL)#>]
//    [self.tableView setSortDescriptors:[NSArray arrayWithObjects:
//
//                                      [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES selector:@selector(compare:)],
//
//                                      [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES selector:@selector(compare:)],
//
//                                      nil]];
//

}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.inData.count;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    
    NSDictionary *dict = [self.inData objectAtIndex:row];
    NSString *value = [dict objectForKey:identifier];
    
    
    if (value) {
        NSTableCellView *column = [tableView makeViewWithIdentifier:identifier owner:self];
        column.textField.stringValue = value;
        NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:identifier ascending:YES selector:@selector(compare:)];
        
        [tableColumn setSortDescriptorPrototype:lastNameSortDescriptor];
        return column;
    }
    return nil;
    
}
- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors

{
    
    [self.inData sortUsingDescriptors: [tableView sortDescriptors]];
    
    [tableView reloadData];
    
}


-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
//    NSTableView *tableView = notification.object;
//
//    NSLog(@"---selection row %ld", tableView.selectedRow);
//
//    NSLog(@"---selection row %@", self.inData [tableView.selectedRow][@"time"]);
//    self.label.stringValue =self.inData [tableView.selectedRow][@"time"];
//    
}

-(BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    NSLog(@"change");
    return YES;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
