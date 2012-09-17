
//
//  NSString+Ext.h
//
//  Created by Duc Ngo on 7/16/12.
//  Copyright (c) 2012 Tech Propulsion Labs. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSString (Ext)

#pragma mark - Constructors methods
+ (NSString*) format:(NSString*)patterns values:(va_list)values;



#pragma mark - Utility methods

- (BOOL) contains:(NSString*)string;

- (BOOL) contains:(NSString*)string options:(NSStringCompareOptions)options;

- (NSArray*) split:(NSString*)string;

- (void) trim;

- (BOOL) startWith:(NSString*)string;

- (BOOL) endsWith:(NSString*)string;

- (BOOL) startWith:(NSString *)endsWith options:(NSStringCompareOptions)options;

- (BOOL) endsWith:(NSString *)endsWith options:(NSStringCompareOptions)options;

- (int) indexOf:(NSString*)string;

- (int) lastIndexOf:(NSString*)string;


#pragma mark - Check methods
- (BOOL) isValidEmail;
- (BOOL) isValidURL;
- (BOOL) isEmpty;

#pragma mark - Convertor methods
- (NSString*) toMD5;
- (int)  toInteger;

@end
