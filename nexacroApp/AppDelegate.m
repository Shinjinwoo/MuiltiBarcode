//
//  AppDelegate.m
//  nexacroApp
//
//  Created by 김재환 on 2016. 11. 24..
//  Copyright © 2016년 com.tobesoft. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppViewController
@synthesize multiQRBarcodePlugin;

// 자동 회전 지원 여부 (YES/NO)
- (BOOL)shouldAutorotate
{
    return YES;
}

// 회전방향 지원 유무 리턴 (리턴값은 회전 방향의 비트값이 설정된 플러그)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end

@implementation AppDelegate

    
- (NexacroMainViewController*)initializeMainViewController
{
    NSString *bootstrapUrl = @"http://smart.tobesoft.co.kr/NexacroN/MultiQRBarcodePlugin/_ios_/start_ios.json";
    //NSString *bootstrapUrl = @"http://smart.tobesoft.co.kr/techService/NexacroN/04_SeoulCredit/_ios_/start_ios.json";

    [[NexacroResourceManager sharedResourceManager] setBootstrapURL:bootstrapUrl isDirect:YES];
    AppViewController* controller = [[AppViewController alloc] initWithFullScreen:NO];
    
    
    
    return controller;
}
    
@end
