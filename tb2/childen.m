//
//  childen.m
//  tb2
//
//  Created by dt on 2019/1/4.
//  Copyright © 2019年 dt. All rights reserved.
//

#import "childen.h"

@implementation childen
{
    NSString* outerVar;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        innerVar = @"innerVar";
        outerVar = @"outerVar";
    }
    return self;
}
-(void)sayHello:(NSString *)in	
{
    NSString* a = @"33";
    if([a isEqualToString:@"44"])
    {
        NSLog(@"33");
    }
    NSLog(@"innerVar say%@",innerVar);
    NSLog(@"outerVar%@",outerVar);
    NSLog(@"self.var%@",self.var);
}

@end
