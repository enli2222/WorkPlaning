//
//  TF.m
//  TF
//
//  Created by Y3Compiler on 15/10/19.
//  Copyright © 2015年 Y3 Compiler. All rights reserved.
//

#import "TF.h"
#include <objc/runtime.h>

//@interface TFTEST : NSObject
//@property(nonatomic,assign) NSInteger max;
//@property(nonatomic,copy) NSString *name;
//@end
//
//@implementation TFTEST
//@synthesize max;
//@synthesize name;
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.max = 100;
//        self.name = @"dddd";
//    }
//    return self;
//}
//
////-(NSString *)description{
////    return [NSString stringWithFormat:@"%ld %@",(long)self.max,self.name];
////}
//@end


@implementation TF

+(void)getAllProperties:(id)tmpObject
{
    u_int count,i;
    objc_property_t *propertys = class_copyPropertyList([tmpObject class], &count);
    for (i=0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [tmpObject valueForKey:propertyName];
        NSLog(@"%@:%@",propertyName,propertyValue);
    }
    
}

+(NSString *)printApp{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *proxys = [workspace performSelector:@selector(allApplications)];
    NSMutableString  *result = [[NSMutableString alloc] init];
    for (id proxy in proxys) {
        NSString *tmp = [NSString stringWithFormat:@"APP:%@ \r\nBundle:%@\r\n",[proxy performSelector:@selector(localizedName)],[proxy performSelector:@selector(applicationIdentifier)]];
        [result appendString:tmp];
//        NSString *idf=[proxy performSelector:@selector(applicationIdentifier)];
//        if ([idf isEqualToString:@"wind.enli.test"]) {
//            NSLog(@"APP:%@ %@",[proxy performSelector:@selector(localizedName)],[proxy performSelector:@selector(applicationIdentifier)]);
//            [TF getAllProperties:proxy];
//        }
    }
    return [NSString stringWithFormat:result];
}




@end
