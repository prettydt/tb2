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
    self.inData = [self searchTest:self.searchField.stringValue InArray:self.inData];
    [self.tableView reloadData];
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
- (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}


-(void)testInclude:(NSString*) testString{
    NSInteger alength = [testString length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [testString characterAtIndex:i];
        NSString *temp = [testString substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){ NSLog(@"字符串中含有中文");
            
        }else if((commitChar>64)&&(commitChar<91)){
            NSLog(@"字符串中含有大写英文字母"); }
        else if((commitChar>96)&&(commitChar<123)){
            NSLog(@"字符串中含有小写英文字母"); }
        else if((commitChar>47)&&(commitChar<58)){
            NSLog(@"字符串中含有数字"); }else{
            NSLog(@"字符串中含有非法字符");
            }
    }
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"transformer==:%@",[self transformToPinyin:@"银行"]);
    NSString * test = @"123";
    NSLog(@"test.intValue%ld",test.integerValue);
    self.searchString = self.searchField.stringValue;
        self.buttonInvalid = false;
    self.sliderValue = 0;
    self.timer =     [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *_Nonnull timer) {
                  NSLog(@"timer");
        self.sliderValue++;
                  }];
    
 
     //   [self.timer fire];

    [self.timer invalidate];
    //sqlite
    //1.创建database路径
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"test1.db"];
    NSLog(@"!!!dbPath = %@",dbPath);
    //2.创建对应路径下数据库
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists t_student ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'phone' TEXT NOT NULL,'score' INTEGER NOT NULL)";
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"create table success");
        
    }

    BOOL result1 = [db executeUpdate:@"insert into 't_student'(ID,name,phone,score) values(?,?,?,?)" withArgumentsInArray:@[@114,@"x3",@"13",@53]];
    if (result1) {
        NSLog(@"insert into 't_studet' success");

    } else {
        NSLog(@"insert into 't_studet' error");
    }

    [db close];
    
    [db open];
    FMResultSet *resultSet = [db executeQuery:@"select * from 't_student' where ID = ? and name =?" withArgumentsInArray:@[@113,@"x4"]];
    //4
    //    FMResultSet *result = [db executeQuery:@"select * from 't_sutdent' where ID = ?" withParameterDictionary:@{@"ID":@114}];
    NSMutableArray *arr = [NSMutableArray array];
    while ([resultSet next]) {
        //        PersonVO *person = [PersonVO new];
        //        person.ID = [result intForColumn:@"ID"];
        //        person.name = [result stringForColumn:@"name"];
        //        person.phone = [result stringForColumn:@"phone"];
        //        person.score = [result intForColumn:@"score"];
        //        [arr addObject:person];
        NSLog(@"从数据库查询到的人员 %@",[resultSet stringForColumn:@"name"]);
        //   [self showAlertWithTitle:@"query  success" message:nil person:person];
        
    }
    //
//    NSString *path = @"identifier.db";
//        NSLog(@"!!!dbPath = %@",path);
//    FMDatabase *db = [FMDatabase databaseWithPath:path];
//    if (![db open]) {
//        // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
//        db = nil;
//        return;
//    } else
//    {
//        NSLog(@"db open succ");
//    }
//    NSInteger identifier = 42;
//    NSString *name = @"Liam O'Flaherty (\"the famous Irish author\")";
//    NSDate *date = [NSDate date];
//    NSString *comment = nil;
//
//    BOOL success = [db executeUpdate:@"INSERT INTO  db.authors (identifier, name, date, comment) VALUES (?, ?, ?, ?)", @(identifier), name, date, comment ?: [NSNull null]];
//
//    if (!success) {
//        NSLog(@"error = %@", [db lastErrorMessage]);
//    } else
//    {
//        NSLog(@"success");
//    }
//
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
    [dic setObject:@"中国银行"forKey:@"name"];
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
- (IBAction)stop:(id)sender {
    [self.timer invalidate];
    self.start.enabled = true;
    
}
- (IBAction)start:(id)sender {
    self.timer =     [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *_Nonnull timer) {
        NSLog(@"timer");
        self.sliderValue++;
    }];
    [self.timer fire];
    self.start.enabled = false;
  //  self.buttonInvalid = true;
}
- (IBAction)insertData:(id)sender {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"test1.db"];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:dbPath];
    [db open];
    if (![db isOpen]) {
        return;
    }
    BOOL result = [db executeUpdate:@"create table if not exists text1 (name text,age,integer,ID integer)"];
    if (result) {
        NSLog(@"create table success");
    }
    //1.开启事务
    [db beginTransaction];
    NSDate *begin = [NSDate date];
    BOOL rollBack = NO;
    @try {
        //2.在事务中执行任务
        for (int i = 0; i< 500; i++) {
            NSString *name = [NSString stringWithFormat:@"text_%d",i];
            NSInteger age = i;
            NSInteger ID = i *1000;
            
            BOOL result = [db executeUpdate:@"insert into text1(name,age,ID) values(:name,:age,:ID)" withParameterDictionary:@{@"name":name,@"age":[NSNumber numberWithInteger:age],@"ID":@(ID)}];
            if (result) {
                NSLog(@"在事务中insert success");
            }
        }
    }
    @catch(NSException *exception) {
        //3.在事务中执行任务失败，退回开启事务之前的状态
        rollBack = YES;
        [db rollback];
    }
    @finally {
        //4. 在事务中执行任务成功之后
        rollBack = NO;
        [db commit];
    }
    NSDate *end = [NSDate date];
    NSTimeInterval time = [end timeIntervalSinceDate:begin];
    NSLog(@"在事务中执行插入任务 所需要的时间 = %f",time);
}



@end
