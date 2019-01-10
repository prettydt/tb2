//
//  childen.h
//  tb2
//
//  Created by dt on 2019/1/4.
//  Copyright © 2019年 dt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "father.h"
@interface childen : father
{
    NSString* innerVar;
}
@property NSString* var;
-(void)sayHello:(NSString *)in;
@end
