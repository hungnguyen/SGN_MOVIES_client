//
//  SGNSNManagedObjectCategory.m
//  testnsdate
//
//  Created by TPL2806 on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGNManagedObject.h"

@implementation NSManagedObject (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if (value == nil) {
            continue;
        } 
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
//        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
//            value = [value stringValue];
//        } 
//        else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
//            value = [NSNumber numberWithInteger:[value integerValue]];
//        } 
//        else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
//            value = [NSNumber numberWithDouble:[value doubleValue]];
//        } 
//        else 
        if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
            int startPos = [value rangeOfString:@"("].location+1;
            int endPos = [value rangeOfString:@")"].location;
            NSRange range = NSMakeRange(startPos,endPos-startPos);
            unsigned long long milliseconds = [[value substringWithRange:range] longLongValue];
            NSTimeInterval interval = milliseconds/1000;
            value = [NSDate dateWithTimeIntervalSince1970:interval];
        }
        if(value == [NSNull null])
            [self setValue:@"" forKey:attribute];
        else
            [self setValue:value forKey:attribute];
    }
}

@end
