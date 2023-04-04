//
//  NSDicEx.h
//  NX14
//
//  Created by mario on 2015. 5. 21..
//  Copyright (c) 2015년 tobesoft. All rights reserved.
//


#ifndef NSDicEx_h
#define NSDicEx_h

//!! category func
@interface NSDictionary(util_)
- (NSInteger) intValueForKey:(NSString*)arg;
- (BOOL) boolValueForKey:(NSString*)arg;
- (NSString*) strValueForKey:(NSString*)arg;
- (NSArray*) arryValueForKey:(NSString*)arg;
- (NSMutableDictionary*) dicValueForKey:(NSString*)arg;
@end

@implementation NSDictionary (util_)

- (NSInteger) intValueForKey:(NSString *)arg
{
    return [[self objectForKey:arg] integerValue];
}
- (BOOL) boolValueForKey:(NSString*)arg
{
    return [[self objectForKey:arg] boolValue];
}
- (NSString*) strValueForKey:(NSString*)arg
{
    return (NSString*)[self objectForKey:arg];
}
- (NSArray*) arryValueForKey:(NSString*)arg
{
    return (NSArray*)[self objectForKey:arg];
    
}
- (NSMutableDictionary*) dicValueForKey:(NSString*)arg
{
    return (NSMutableDictionary*)[self objectForKey:arg];
    
}
@end


#endif
