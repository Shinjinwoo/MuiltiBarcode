//
//  MultiBarcodePlugin.m
//  nexacroApp
//
//  Created by 신진우 on 2023/02/16.
//  Copyright © 2023 com.tobesoft. All rights reserved.
//

#import "MultiQRBarcodePlugin.h"
#import "AppDelegate.h"
//#import "CameraViewController2.h"
#import "MultiQRBarcodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define SVCID    @"svcid"
#define REASON   @"reason"
#define RETVAL   @"returnvalue"
#define ONCALLBACK @"_oncallback"

#define CALL_RECV   @"_onreceive"
#define CALL_BACK   @"_oncallback"


const int NexacroFormatALL = 0;
const int MLKBarcodeFormatAll = 0xFFFF;



@implementation MultiQRBarcodePlugin {
    AppViewController *rootViewController;
    NexacroAppDelegate *appDelegate;
    MultiQRBarcodeViewController *multiQRBarcodeVC;
}

- (DeviceAPI*) initWithWebView:(WKWebView*)theWebView {
    NSLog(@"[%@] %@", @"MultiQRBarcodePlugin", @"init");
    
    appDelegate = ((NexacroAppDelegate *)[[UIApplication sharedApplication] delegate]);
    rootViewController = (AppViewController*)appDelegate.mainViewController;

    rootViewController.multiQRBarcodePlugin = self;
    
    //test

    self = (MultiQRBarcodePlugin*)
    [super initWithWebView:theWebView];
    
    
    NSLog(@"yellowColor : %@",[self uiColorToARGB:[UIColor yellowColor]]);
    NSLog(@"grayColor   : %@",[self uiColorToARGB:[UIColor grayColor]]);
    NSLog(@"blackColor  : %@",[self uiColorToARGB:[UIColor blackColor]]);
    
    return self;
}


-(void)callMethod:(NSString*)lid withDict:(NSMutableDictionary*)options {
    [self printArgs:[NSString stringWithUTF8String:__func__] arg:options];
    
    
    self.nID = [lid integerValue];
    
    NSDictionary *dic = [options dicValueForKey:@"param"];
    
    self.mSerivceId = [options strValueForKey:@"serviceid"];
    @try
    {
        if([mSerivceId isEqualToString:@"scan"])
        {
            [self grantCameraPermissionWithDic:dic];
        }
    }
    @catch (NSException *exception) {
        [self send:CODE_ERROR  withMsg:exception.description];
    }
}

-(void) sendEx:(int)reason1 eventID: (NSString*)eventID serviceID:(NSString*) svcId andMsg:(NSString*)retval {
    @try
    {
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        [mdic setObject:[NSNumber numberWithInt:reason1] forKey:REASON];
        
        if(retval == nil) {
            retval = @"";
        }
        
        [mdic setObject:retval forKey:RETVAL];
        [mdic setObject:svcId  forKey:SVCID];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self writeEvent:eventID  result:jsonStr];
    }
    @catch(NSException *e) {
        //e.printStackTrace();
    }
    @finally {
        self.mSerivceId = nil;
    }
}


#pragma mark - 스캔시작
-(void) startScan : (NSDictionary*) dic {
    
    multiQRBarcodeVC = [[MultiQRBarcodeViewController alloc]init];
    
    /*
    BOOL useTextLabel    = [[dic valueForKey:@"useTextLabel"]   isEqualToString:@"true"];
    BOOL useAutoCapture  = [[dic valueForKey:@"useAutoCapture"] isEqualToString:@"true"];
    BOOL useSound        = [[dic valueForKey:@"useSound"] isEqualToString:@"true"];
    CGFloat zoomFactor   = [[dic valueForKey:@"zoomFactor"] floatValue];
    CGFloat limitTime    = [[dic valueForKey:@"limitTime"]  floatValue];
    long limitCount      = [[dic valueForKey:@"limitCount"] longLongValue];
    NSArray *setBarcodeFormat = [dic valueForKey:@"setScanFormat"];
    */
    
    BOOL useFrontCamera  = [self getConvertedBoolComparedToAndroid:[dic valueForKey:@"switchToFrontCamera"]];
    BOOL useTextLabel    = [dic boolValueForKey:@"useTextLabel"];
    BOOL useAutoCapture  = [dic boolValueForKey:@"useAutoCapture"];
    BOOL useSound        = [dic boolValueForKey:@"useSound"];
    
    CGFloat zoomFactor   = [[dic valueForKey:@"zoomFactor"] floatValue];
    CGFloat limitTime    = [[dic valueForKey:@"limitTime"]  floatValue];
    long limitCount      = [[dic valueForKey:@"limitCount"] longLongValue];
    
    NSArray *setBarcodeFormat = [dic arryValueForKey:@"setScanFormat"];
    
    #pragma mark  n줄이상 바코드 기능 Set [ 테스트 코드 ]
    //추후 2줄 바코드 이상의 경우를 위해 옵션을 넣어놓지만 하드코딩으로 막아 놓기
    long selectingCount  = [[dic valueForKey:@"setSelectingCount"]longLongValue];
    if (selectingCount == 0)
        [multiQRBarcodeVC setSelectingCount:2];
    
    #pragma mark  진동 기능 Set [ 테스트 코드 ]
    bool useVibration    = [dic boolValueForKey:@"useVibration"];
    useVibration = NO;
    if ( useVibration == YES )
        [multiQRBarcodeVC setIsUseVibration:YES];
    else if ( useVibration == NO )
        [multiQRBarcodeVC setIsUseVibration:NO];
    else
        [multiQRBarcodeVC setIsUseVibration:NO];
    
    #pragma mark  핀치줌 기능 Set [ 테스트 코드 ]
    bool usePinchZoom    = [dic boolValueForKey:@"usePinchZoom"];
    usePinchZoom = YES;
    if ( usePinchZoom == YES )
        [multiQRBarcodeVC setIsUsePinchZoom:YES];
    else if ( usePinchZoom == NO )
        [multiQRBarcodeVC setIsUsePinchZoom:NO];
    else
        [multiQRBarcodeVC setIsUsePinchZoom:NO];
    
    #pragma mark 전후면 카메라 사용여부 Set
    if ( useFrontCamera == YES )
        //multiQRBarcodeVC.isUseFrontCamera = YES;
        [multiQRBarcodeVC setIsUseFrontCamera:YES];
    
    else if ( useFrontCamera == NO )
        //multiQRBarcodeVC.isUseFrontCamera = NO;
        [multiQRBarcodeVC setIsUseFrontCamera : NO];
    else
        //multiQRBarcodeVC.isUseFrontCamera = NO;
        [multiQRBarcodeVC setIsUseFrontCamera : NO];
    
    
    #pragma mark 텍스트 라벨  사용여부 Set
    if (useTextLabel == YES )
        //multiQRBarcodeVC.isUseTextLabel = YES;
        [multiQRBarcodeVC setIsUseTextLabel: YES];
    else if (useTextLabel == NO )
        //multiQRBarcodeVC.isUseTextLabel = NO;
        [multiQRBarcodeVC setIsUseTextLabel: NO];
    else
        //multiQRBarcodeVC.isUseTextLabel = NO;
        [multiQRBarcodeVC setIsUseTextLabel: NO];
    
    #pragma mark 사운드 사용여부 Set
    if ( useSound == YES )
        //multiQRBarcodeVC.isUseSoundEffect = YES;
        [multiQRBarcodeVC setIsUseSoundEffect : YES];
    else if ( useSound == NO )
        //multiQRBarcodeVC.isUseSoundEffect = NO;
        [multiQRBarcodeVC setIsUseSoundEffect : NO];
    else
        //multiQRBarcodeVC.isUseSoundEffect = YES;
        [multiQRBarcodeVC setIsUseSoundEffect : YES];
    
    
    #pragma mark 캡쳐시 사용할 포맷 Set
    if (setBarcodeFormat != nil)
        //multiQRBarcodeVC.setBarcodeFormat = [self getSacnFormat:setBarcodeFormat];
        [multiQRBarcodeVC setBarcodeFormat : [self getSacnFormat:setBarcodeFormat]];
    
    else
        [self send:CODE_ERROR withMsg:@"Barcode Format is Null"];
    
    
    #pragma mark 오토캡쳐 사용여부 Set
    if ( useAutoCapture == YES )
        //multiQRBarcodeVC.isUseAutoCapture = YES;
        [multiQRBarcodeVC setIsUseAutoCapture:YES];
    else if ( useAutoCapture == NO )
        //multiQRBarcodeVC.isUseAutoCapture = NO;
        [multiQRBarcodeVC setIsUseAutoCapture:NO];
    else
        //multiQRBarcodeVC.isUseAutoCapture = NO;
        [multiQRBarcodeVC setIsUseAutoCapture:NO];
    
    #pragma mark 리미트 시간 Set
    if ( limitTime == 0 ) { // NSDic에서 값을 추출하지 못했을 경우 Default 값
        if ( useAutoCapture == YES ) {
            [self send:CODE_ERROR withMsg:@"LimitTime is Null"];
            return;
        } else {
            NSLog(@"%f",limitTime);
        }
    } else if ( limitTime <= 1 && useAutoCapture == YES ) {
        [self send:CODE_ERROR withMsg:@"LimitTime more than 1"];
        return;
    } else {
        multiQRBarcodeVC.limitTime = limitTime;
    }
    
    #pragma mark  리미트 카운트 Set
    if ( limitCount == 0 ) { // NSDic에서 값을 추출하지 못했을 경우 Default 값
        if ( limitCount == 0 && useAutoCapture == YES ) {
            [self send:CODE_ERROR withMsg:@"LimitCount is Null"];
            return;
        } else if ( limitCount < 1 && useAutoCapture == YES ) {
            [self send:CODE_ERROR withMsg:@"LimitCount more than 1"];
            return;
        } else {
            NSLog(@"%lu",limitCount);
        }
    } else {
        multiQRBarcodeVC.limitCount = limitCount;
    }
    
    #pragma mark  카메라 배율 Set
    if ( zoomFactor <= 1 )
        multiQRBarcodeVC.zoomFactor = 1.0;
    else
        multiQRBarcodeVC.zoomFactor = zoomFactor;
    
    #pragma mark  기타 내부설정 Set
    //====================================== 기타 내부설정 Set =====================================================
    //test가나다라마바사
    //CGFloat alpha = [[dic valueForKey:@"setFocusedAreaOpacity"]floatValue];
    //NSString *hexColor = [dic valueForKey:@"setFocusedAreaColor"];
    //UIColor *color = [self hexcodeToUiColor:hexColor alpha:alpha];
    UIColor *color = [UIColor clearColor];
    
    //TODO UIColor 핵사코드로 받아서 교체하기... 학습차원에서라도 해보기
    multiQRBarcodeVC.boxColor = color;
    
    
    [multiQRBarcodeVC setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [rootViewController presentViewController:multiQRBarcodeVC animated:YES completion:nil];
    
}

#pragma mark - 스캔할 포맷 비트연산
-(NSInteger) getSacnFormat : (NSArray*)setBarcodeFormat {
    NSInteger result = [setBarcodeFormat[0] integerValue];
    for ( int i = 0; i < setBarcodeFormat.count; i ++) {
        if ( [setBarcodeFormat[i] integerValue] == NexacroFormatALL ) {
            result |= MLKBarcodeFormatAll;
        }
        result |= [setBarcodeFormat[i] integerValue];
    }
    return result;
}

#pragma mark - 카메라 권한 요청 및 스캔 시작
-(void) grantCameraPermissionWithDic : (NSDictionary*) dic {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startScan:dic];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self CameraPermissionUIAlertView];
            });
        }
    }];
}

#pragma mark - 카메라 권한 거부 처리
-(void) CameraPermissionUIAlertView {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"카메라 권한"
                                 message:@"바코드 스캐닝을 위해 설정에서 \n카메라 권한을 허용해주세요."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    UIAlertAction* sysConfigButton = [UIAlertAction
                               actionWithTitle:@"설정"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self systemConfigView];
                               }];
    
    [alert addAction: okButton];
    [alert addAction: sysConfigButton];
    
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)systemConfigView {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:^(BOOL bSuccess) {
        if (!bSuccess ) {
            NSLog(@"openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] Failed");
            [self sendEx:CODE_ERROR
                 eventID:CALL_BACK
               serviceID:SVCID
                  andMsg:@"openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] Failed"];
        }
    }];
}

#pragma mark - 안드로이드와 전,후면 카메라 사용 옵션의 공통화를 위해 bool값 반대로 변환
-(bool)getConvertedBoolComparedToAndroid :(NSString*)param {
    if ( [param isEqualToString:@"1"] )
        return NO;
    else if ( param == nil )
        return NO;
    else
        return YES;
}

#pragma mark - UIColor를 ARGB로
-(NSString*) uiColorToARGB : (UIColor*) color {
    
    // UIColor에서 CGColor를 추출
    CGColorRef cgColor = [color CGColor];

    // CGColor에서 컬러 컴포넌트를 추출
    const CGFloat *components = CGColorGetComponents(cgColor);
    
    // components에서 ARGB 값을 추출하고 0-255 범위로 변환
    NSUInteger alpha    = (NSUInteger)(components[3] * 255.0); // 알파 값
    NSUInteger red      = (NSUInteger)(components[0] * 255.0); // 빨강 값
    NSUInteger green    = (NSUInteger)(components[1] * 255.0); // 녹색 값
    NSUInteger blue     = (NSUInteger)(components[2] * 255.0); // 파랑 값

    // ARGB 값을 출력
    //NSLog(@"ARGB: (%lu, %lu, %lu, %lu)", alpha, red,green, blue);
    
    return [[NSString alloc]initWithFormat:@"ARGB: ( Alpha:%lu, Red:%lu, Green:%lu, Blue:%lu)", alpha, red, green, blue];
}


#pragma mark - HexCode를 UIColor로
-(UIColor*) hexcodeToUiColor : (NSString*) hexColorCode
                       alpha : (CGFloat)   alphanum {
    
    //NSString *hexColorCode = @"#FF0000";

    // Remove the "#" symbol
    NSString *cleanHexColorCode = [hexColorCode stringByReplacingOccurrencesOfString:@"#" withString:@""];

    // Convert the hex color code to a hexadecimal number
    unsigned int hexColorValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanHexColorCode];
    [scanner scanHexInt:&hexColorValue];

    // Extract the red, green, and blue values from the hexadecimal number
    CGFloat red   = ((hexColorValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((hexColorValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue  = (hexColorValue & 0x0000FF) / 255.0;

    // Create the UIColor object using the extracted RGB values
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alphanum];
    
    return color;
}



@end
