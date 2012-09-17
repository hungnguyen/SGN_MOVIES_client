
//
//  NSString+Ext.m
//
//  Created by Duc Ngo on 7/16/12.
//  Copyright (c) 2012 Tech Propulsion Labs. All rights reserved.


#import "NSString+Ext.h"
#import <CommonCrypto/CommonDigest.h>

int const GGCharacterIsNotADigit = 10;

@implementation NSString (Ext)

#pragma mark - Convertor methods
// TODO: Add other methods, specifically SHA1

/*
 * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
 */

- (NSString*)toMD5 {
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
	return [hash lowercaseString];
}

- (int) toInteger{
    return [self intValue];
}


#pragma mark - Constructor method
+ (NSString *)format:(NSString *)patterns values:(va_list)values{
    return [NSString stringWithFormat:patterns,values];
}


#pragma mark - Utility methods
- (BOOL)contains:(NSString*)string {
	return [self contains:string options:NSCaseInsensitiveSearch];
}

- (BOOL)contains:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (NSArray *)split:(NSString *)string{
    return [string componentsSeparatedByString: string];
}

- (void) trim{
    [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)startWith:(NSString *)string options:(NSStringCompareOptions)options{
    if ([self length] < [string length]) return NO;
    NSString *beginning = [self substringToIndex:[string length]];
    return ([beginning compare:string options:options] == NSOrderedSame);
}

- (BOOL)endsWith:(NSString *)endsWith options:(NSStringCompareOptions)options {
    if ([self length] < [endsWith length]) return NO;
    NSString *lastString = [self substringFromIndex:[self length] - 1];
    return ([lastString compare:endsWith options:options] == NSOrderedSame);
}

- (BOOL)startWith:(NSString *)string{
    return [self startWith:string options:NSLiteralSearch];
}
- (BOOL)endsWith:(NSString *)string{
    return [self endsWith:string options:NSLiteralSearch];
}

- (int)indexOf:(NSString *)string{
    return [self rangeOfString:string].location;
}
- (int)lastIndexOf:(NSString *)string{
    return [self rangeOfString:string options:NSBackwardsSearch].location;
}

#pragma mark - Check method
- (BOOL) isValidURL{
    return [NSURL URLWithString:self] != NULL;
}

- (BOOL)isValidEmail{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *validator = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regex];
	return [validator evaluateWithObject: self];
}


- (BOOL) isEmpty{
    return self == NULL || [self length] == 0;
}
@end
