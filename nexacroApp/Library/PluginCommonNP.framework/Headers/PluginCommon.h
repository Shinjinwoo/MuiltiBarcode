//
//  PluginCommon.h
//  AIAONE
//
//  Created by TOBESOFT on 2016. 3. 31..
//
//

#import <UIKit/UIKit.h>

#import "nexacro/DeviceAPI.h"
//#import "nexacro17/DeviceAPI.h"

#import "NSDicEx.h"

#define CODE_SUCCES       0
#define CODE_ERROR        -1
#define CODE_PERMISSION_ERROR   -9


@interface PluginCommon : DeviceAPI
{
    NSInteger nID;
    NSInteger reason;
    NSString *mSerivceId;
}

@property (nonatomic) NSInteger nID;
@property (nonatomic) NSInteger reason;
@property (nonatomic, retain) NSString * mSerivceId;

//-(void)dealloc;
//-(void)openURL:(NSString*)lid withDict:(NSMutableDictionary*)options;
-(void)printArgs:(NSString*)fname arg:(NSDictionary*)arg;
- (NSString *)alias2path:(NSString*)setPath;


- (NSString*)getSuccessReturnString:(NSInteger)reason;
- (NSString*)getSuccessReturnString:(NSInteger)reason retVal:(NSString*) arg;
- (NSString*)getErrorReturnString:(NSInteger)errcode reasonCode:(NSInteger)rcode errMsg:(NSString*)msg;
- (void)writeEvent:(NSString*)eventName result:(NSString*)selectResult;

-(void) send:(int) cd  withMsg:(NSString*) m;

@end
