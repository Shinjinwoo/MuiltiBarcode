//
//  CameraViewController2.h
//  nexacroApp
//
//  Created by 신진우 on 2023/02/16.
//  Copyright © 2023 com.tobesoft. All rights reserved.
//
//

#import "MultiQRBarcodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreVideo/CoreVideo.h>
#import "UIUtilities.h"
#import "AppDelegate.h"
#import "MultiQRBarcodePlugin.h"

#define SERVICE_ID   @"scan"

@import MLImage;
@import MLKit;

NS_ASSUME_NONNULL_BEGIN

static NSString *const videoDataOutputQueueLabel = @"com.google.mlkit.visiondetector.VideoDataOutputQueue";
static NSString *const sessionQueueLabel = @"com.google.mlkit.visiondetector.SessionQueue";


@interface MultiQRBarcodeViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>


@property(nonatomic, nonnull) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic) AVCaptureSession *captureSession;
@property(nonatomic) dispatch_queue_t sessionQueue;
@property(nonatomic) UIView *annotationOverlayView;
@property(nonatomic) UIImageView *previewOverlayView;
@property(weak, nonatomic) IBOutlet UIView *cameraView;
@property(nonatomic) CMSampleBufferRef lastFrame;

@property(nonatomic, strong) AVAudioPlayer* avAudioPlayer;

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property(nonatomic) NSMutableArray *array;
@property(nonatomic) NSMutableDictionary *barcodeFormatTable;
@property(nonatomic) NSMutableDictionary *sendToPluginDic;
@property(nonatomic) NSMutableArray *returnArray;
@property(nonatomic) NSMutableDictionary *barcodeInfoDic;
@property(nonatomic) BOOL timerStatus;
@property(nonatomic) BOOL alredySend;
@property(nonatomic) NexacroAppDelegate *nexacroAppDelegate;
@property(nonatomic) MultiQRBarcodePlugin *multiQRBarcodePlugin;
@property(nonatomic) AVCaptureDevice *device;

@end

@implementation MultiQRBarcodeViewController

@synthesize isUseFrontCamera;
@synthesize isUseTextLabel;
@synthesize isUseTimer;
@synthesize isUseSoundEffect;
@synthesize isUseAutoCapture;
@synthesize isUseVibration;
@synthesize selectingCount;
@synthesize barcodeFormat;
@synthesize limitTime;
@synthesize limitCount;
@synthesize zoomFactor;
@synthesize boxColor;
@synthesize isUsePinchZoom;
@synthesize isUnlimitedTime;

#pragma mark - UIInterfaceOrientationMask Portrait 고정
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _alredySend = NO;
    
    if (self.boxColor == nil )
        self.boxColor = UIColor.yellowColor;
    
    _nexacroAppDelegate = ((NexacroAppDelegate *)[[UIApplication sharedApplication] delegate]);
    AppViewController *rootVC =  (AppViewController*)_nexacroAppDelegate.mainViewController;
    _multiQRBarcodePlugin = rootVC.multiQRBarcodePlugin;
    
    [_cameraBtn setImage:[self setCaptureButtonImage] forState:UIControlStateNormal];
    
//    self.view.layer.shouldRasterize = YES;
//    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
//    _cameraView.layer.shouldRasterize = YES;
//    _cameraView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.view.backgroundColor = [UIColor blackColor];
    _cameraView.backgroundColor = [UIColor whiteColor];
    
    _array = [[NSMutableArray alloc]init];
    _barcodeFormatTable = [[NSMutableDictionary alloc]init];
    _barcodeInfoDic = [[NSMutableDictionary alloc]init];
    
    _captureSession = [[AVCaptureSession alloc] init];
    // 캡처세션 초기화
    _sessionQueue = dispatch_queue_create(sessionQueueLabel.UTF8String, nil);
    
    _previewOverlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    //_previewOverlayView.contentMode = UIViewContentModeScaleAspectFill;
    _previewOverlayView.contentMode = UIViewContentModeScaleToFill;
    _previewOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _annotationOverlayView = [[UIView alloc] initWithFrame:CGRectZero];
    _annotationOverlayView.contentMode = UIViewContentModeScaleToFill;
    _annotationOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    
    //self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.videoGravity = AVLayerVideoGravityResize;
    
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    //self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft
    
    [self setUpPreviewOverlayView];
    [self setUpAnnotationOverlayView];
    [self setUpCaptureSessionOutput];
    [self setUpCaptureSessionInput];
    
    if ( self.isUsePinchZoom == YES )
    {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self.cameraView addGestureRecognizer:pinch];
    }
}


#pragma mark - 캡쳐버튼 UI 처리
-(UIImage*)setCaptureButtonImage {
    UIImage *largeBoldDoc;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *largeConfig = [UIImageSymbolConfiguration configurationWithPointSize:60 weight:UIImageSymbolWeightBold scale:UIImageSymbolScaleLarge];
        
        largeBoldDoc = [UIImage systemImageNamed:@"circle.fill" withConfiguration:largeConfig];
    } else {
        largeBoldDoc = [UIImage imageNamed:@"circle_fill"];
    }
    
    return largeBoldDoc;
}

#pragma mark - 진동 기능
- (void)startVibrate {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


#pragma mark - 핀치 줌
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinch {
    CGFloat initialScale = _device.videoZoomFactor;
    CGFloat minAvailableZoomScale = 1.0;
    CGFloat maxAvailableZoomScale = _device.maxAvailableVideoZoomFactor;
    
    NSError *error = nil;
    if ([_device lockForConfiguration:&error]) {
        if ( error != nil ) {
            [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:error.description];
        } else  {
            if (pinch.state == UIGestureRecognizerStateBegan) {
                initialScale = _device.videoZoomFactor;
            } else {
                if (initialScale * pinch.scale < minAvailableZoomScale) {
                    _device.videoZoomFactor = minAvailableZoomScale;
                } else if (initialScale * pinch.scale > maxAvailableZoomScale) {
                    _device.videoZoomFactor = maxAvailableZoomScale;
                } else {
                    _device.videoZoomFactor = initialScale * pinch.scale;
                }
                
                if (fabs(_device.videoZoomFactor - initialScale) >= 10 || fabs(_device.videoZoomFactor - initialScale) <= 10) {
                    [self showToast:[NSString stringWithFormat:@"배율 : %.1f",_device.videoZoomFactor] withDuration:1 delay:0.5 ];
                }
                
            }
            pinch.scale = 1.0;
            [_device unlockForConfiguration];
        }
    }
}

#pragma mark - 핀치줌 변경시 토스트 메시지
- (void)showToast:(NSString *)message withDuration:(double)duration delay:(double)delay {
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    UILabel *toastLabel = [[UILabel alloc]init];
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        toastLabel.frame = CGRectMake(  self.previewOverlayView.frame.origin.x,
                                        self.previewOverlayView.frame.size.height/2,
                                        75,
                                        35);
        //toastLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    } else {
        toastLabel.frame = CGRectMake(  self.cameraView.frame.size.width/2 - 37.5,
                                        self.cameraView.frame.size.height-50,
                                        75,
                                        35);
    }
    
    
    toastLabel.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
    toastLabel.textColor = [UIColor blackColor];
    
    toastLabel.font = [UIFont systemFontOfSize:14.0];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.text = message;
    toastLabel.alpha = 1.0;
    toastLabel.layer.cornerRadius = 16;
    toastLabel.clipsToBounds = YES;
    
    [self.view addSubview:toastLabel];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        toastLabel.alpha = 0.0;
    } completion:^(BOOL isCompleted) {
        [toastLabel removeFromSuperview];
    }];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startSession];
    _timerStatus = YES;
    
    
    /*
     1. 모듈 인스턴스 생성 - > 콜 메소드 ->
     2. ( viewDidLoad  [ onCreated() ] : UI 초기화 및 켑쳐 세션 초기화 ) ->
     3. ( viewDidApper [ onStart() ]   : 캡쳐 스타트 ) ->
     4. ( AVCaptureVideoDataOutputSampleBufferDelegate  : 해당 델리게이터를 통해 마지막 프레임에 이미지 버퍼를 받아옴 ) ->
     5. ( scanBarcodesOnDeviceInImage 함수를 통해 마지막 버퍼의 이미지를 분석 ) ->
     6. 상기 함수에서 MLKBarcodeScanner 스캐너 인스턴스가 스캔결과를 MLKBarcode 인스턴스로 내보냄 ->
     7. 캡처 버튼 클릭시 스캔 결과인 MLKBarcode 인스턴스를 json 형식으로 매핑후 모듈로 전송
     8. 넥사크로로 리턴
     */
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopSession];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _previewLayer.frame = _cameraView.frame;;
    
}


#pragma mark - 버튼 이벤트
- (IBAction)onCaptureBtnClick:(id)sender {

    _alredySend = YES;
    // 비동기처리 Flag 값
    
    if (self.isUseSoundEffect == YES)
        [self playSound];
    
    [self sendToMultiQRBarcodePlugin];
    // 플러그인에 바코드에 대한 정보를 전송하는 함수 호출
    
    if ( self.isUseVibration == YES )
        [self startVibrate];
    // 진동기능
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // 뷰 종료
}

- (IBAction)onBackBtnClick:(id)sender {
    _alredySend = YES;
    // 비동기처리 Flag 값
    
    [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:@"User Cancel" ];
    if ( self.isUseVibration == YES )
        [self startVibrate];
    // 진동기능
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // 뷰 종료
}

#pragma mark - 넥사크로로 전송 ( 테스트 코드 )
- (void) sendToMultiBarcodePlugin2 {
    NSArray *test = [self sortedMutableArrayByDuplicateValue:_array];
    int a = 2;
    @try {
        for( int i = 1; i <= a; i++  ) {
            NSLog(@"%@",[test objectAtIndex: [test count] - i ]);
        }
    } @catch (NSException *exception) {
        [_multiQRBarcodePlugin send:CODE_ERROR withMsg:[exception description]];
    } @finally {
        NSLog(@"Finish");
    }
}

#pragma mark - 사운드 재생

- (void) playSound {
    @try {

        NSError *error;
        // 음악 파일 경로 이름 ( Sample )
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"scan_beep" ofType:@"mp3"];
        // URL로 변환
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        // AVAudioPlayer 객체 생성
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
        // 재생

        if ( error == nil )
            [_avAudioPlayer play];
        else
            [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID
                                   andMsg:[NSString stringWithFormat:@"사운드 재생 실패 : %@",error.description]];
        
    } @catch (NSException *exception) {
        [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID
                               andMsg:[NSString stringWithFormat:@"사운드 재생 실패 : %@",exception.description]];
    } @finally {
        
    }
}


#pragma mark - 배열 요소별 누적 된 횟수 구하는 로직
- (NSMutableDictionary*) getFrequencyCountsDic {
    
    NSMutableDictionary *frequencyCounts = [NSMutableDictionary dictionary];
    
    for (id element in _array) {
        NSNumber *count = frequencyCounts[element];
        if (count == nil) {
            count = @(0);
        }
        count = @(count.intValue + 1);
        frequencyCounts[element] = count;
    }
    
    return frequencyCounts;
}


#pragma mark - 넥사크로로 전송
- (void) sendToMultiQRBarcodePlugin {
    
    if ( self.selectingCount <= 0  )
        [_multiQRBarcodePlugin send:CODE_ERROR withMsg:@"Count Set is null"];
    else {
        @try {
            NSMutableDictionary *frequencyCounts = [self getFrequencyCountsDic];
            NSArray *sortedKeys = [self sortedMutableArrayByDuplicateValue:_array];
            NSString *mostFrequentElement = [sortedKeys lastObject];
            
            NSLog(@"가장 많이 중복된 벨류 : %@", mostFrequentElement);
            NSLog(@"총 누적된 바코드 벨류의 개수 : %lu",(unsigned long)sortedKeys.count);
            NSLog(@"유저가 셋팅한 카운트 할 바코드 벨류의 개수 : %lu", self.selectingCount );
            
            _returnArray = [[NSMutableArray alloc]init];
            
            for ( int i = 0; i < self.selectingCount; i ++ ) {
                int idx = i + 1;
                
                NSString *mapKey    = sortedKeys[sortedKeys.count - idx];
                // DisPlayerValue : rawValue를 가공한 사용자 친화적인 바코드 값
                NSString *rawValue  = [[_barcodeFormatTable valueForKey:mapKey]valueForKey:@"rawValue"];
                // 원시데이터를 UTF-8로 인코딩 한 값.
                NSString *mapValue  = [[_barcodeFormatTable valueForKey:mapKey]valueForKey:@"format"];
                // 바코드 값을 기준으로 포맷 테이블에서 해당 바코드의 포멧을 가져옴
                NSString *valueType = [[_barcodeFormatTable valueForKey:mapKey]valueForKey:@"displayValueType"];
                // 바코드의 벨류 타입
                NSString *count     = [frequencyCounts valueForKey:mapKey];
                // 바코드 값을 기준으로 해당 바코드의 버퍼마다 누적 카운팅 된 숫자를 가져옴
                
                NSLog(@"상위 %d번째로 많이 누적 캡쳐된 바코드의 벨류: %@ 포멧 : %@ 누적 캡처된 수 : %@", idx, mapKey,mapValue,count);
                
                //TODO 중복값을 제거한 바코드 포맷 테이블 [ 키 : 바코드 로우데이터 , 벨류 : 포멧 ]과 누적된 값이 상위로 정의 된 NSDic에서 키 벨류로 다시 매핑하기
                
                NSDictionary *infoDic = @{
                    @"format"           : mapValue,
                    @"displayValue"     : mapKey,
                    @"rawValue"         : rawValue,
                    @"displayValueType" : valueType
                };
                
                [_returnArray addObject:infoDic];
                
            }
        } @catch (NSException *exception) {
            if ( [exception.name isEqualToString:@"NSRangeException"]) {
                //NSLog(@"%@",[exception description]);
            } else{
                [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:[exception description]];
            }
        } @finally {
            if (_returnArray.count <= 0)
                [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:@"No barcodes captured"];
            else
                [_multiQRBarcodePlugin sendEx:CODE_SUCCES eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:(NSString*)_returnArray];
            
            [_array removeAllObjects];
            [_barcodeFormatTable removeAllObjects];
            [_returnArray removeAllObjects];
        }
    }
}

#pragma mark - MLKit 스캔결과
- (void)scanBarcodesOnDeviceInImage:(MLKVisionImage *)image
                              width:(CGFloat)width
                             height:(CGFloat)height
                            options:(MLKBarcodeScannerOptions *)options {
    
    MLKBarcodeScanner *scanner = [MLKBarcodeScanner barcodeScannerWithOptions:options];
    
    NSError *error;
    NSArray<MLKBarcode *> *barcodes = [scanner resultsInImage:image error:&error];
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        // UI Thread에서 사용한다.
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf removeDetectionAnnotations];
        [strongSelf updatePreviewOverlayViewWithLastFrame];
        // UI 작업등을 라스트 프레임에 업데이트 한다
        
        if (error != nil) {
            NSLog(@"Failed to scan barcodes with error: %@", error.localizedDescription);
            [_multiQRBarcodePlugin sendEx:CODE_ERROR eventID:@"_oncallback" serviceID:SERVICE_ID andMsg:error.localizedDescription];
            return;
        }
        
        if (barcodes.count == 0) {
            return;
        }
        
        for (MLKBarcode *barcode in barcodes) {
            
            CGRect normalizedRect = CGRectMake( barcode.frame.origin.x      / width,
                                                barcode.frame.origin.y      / height,
                                                barcode.frame.size.width    / width,
                                                barcode.frame.size.height   / height);
            
            CGRect standardizedRect = CGRectStandardize( [strongSelf.previewLayer rectForMetadataOutputRectOfInterest:normalizedRect] );
            
            // 카메라 화면을 기준으로 박스의 비율을 '상대적'으로 계산
            [UIUtilities addRectangle:standardizedRect
                               toView:strongSelf.annotationOverlayView
                                //color:UIColor.greenColor
                                color:self.boxColor];
            
            
            // 포커스 된 바코드 영역을 MLKit Result를 통해 화면에 그리는 UI 작업
            if ( self.isUseTextLabel == YES ) {
                UILabel *textLabel = [self getTextLabelWithCGRect:standardizedRect withDisplayValue:barcode.displayValue];
                [strongSelf.annotationOverlayView addSubview:textLabel];
            }
            
            // 포커스된 바코드영역에 텍스트 라벨을 화면에 그리는 UI 작업
            NSDictionary *qrBarcodeInfoDic = @{
                @"format"    : [NSString stringWithFormat:@"%ld",(long)barcode.format],
                @"rawValue"  : barcode.rawValue,
                @"displayValueType" : [NSString stringWithFormat:@"%ld",(long)barcode.valueType],
                @"displayValue" : barcode.displayValue
            };
            
            //[_barcodeFormatTable setValue:qrBarcodeInfoDic forKey:barcode.displayValue];
            [_barcodeFormatTable setValue:qrBarcodeInfoDic forKey:barcode.rawValue];
            
            //[_array addObject:barcode.displayValue];
            [_array addObject:barcode.rawValue];
            
            
            NSLog(@"%lu",_array.count);
            
            if ( isUseAutoCapture == YES ) {
                if ( _timerStatus == YES  && isUnlimitedTime == NO) {
                    _timerStatus = NO;
                    [self startTimer];
                }
                
                if ( _array.count >= self.limitCount ) {
                    if ( _alredySend == NO ) {
                        // 진동기능
                        if ( self.isUseVibration == YES )
                            [self startVibrate];
                        
                        //사운드
                        if (self.isUseSoundEffect == YES)
                            [self playSound];
                        
                        // 넥사크로로 전송
                        [self sendToMultiQRBarcodePlugin];
                        
                        // 뷰 종료
                        [self dismissViewControllerAnimated:YES completion:nil];
                        _alredySend = YES;
                        
                    }
                }
            }
        }
    });
}

#pragma mark - 타이머 시작
-(void)startTimer {
    NSString *userInfo = @"AutoScan Timer Start";
    [NSTimer scheduledTimerWithTimeInterval:self.limitTime target:self selector:@selector(timerFire:) userInfo:userInfo repeats:NO];
}

#pragma mark - 타이머 핸들러
-(void)timerFire:(NSTimer*)timer {
    if (_alredySend == NO) {
        if (self.isUseSoundEffect == YES)
            [self playSound];
        
        if ( self.isUseVibration == YES )
            [self startVibrate];
        // 진동기능
        [self sendToMultiQRBarcodePlugin];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 중복된 값 카운팅 후 정렬 함수

- (NSArray*)sortedMutableArrayByDuplicateValue : (NSMutableArray*) array {
    
    NSCountedSet *countedSet = [[NSCountedSet alloc]initWithArray:array];
    
    NSArray *sortedArray = [[countedSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger count1 = [countedSet countForObject:obj1];
        NSUInteger count2 = [countedSet countForObject:obj2];
        return count1 - count2;
    }];
    
    return sortedArray;
}


#pragma mark - 캡쳐세션 설정 [ 해상도 및 초기 설정 ]
- (void)setUpCaptureSessionOutput {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sessionQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            NSLog(@"Failed to setUpCaptureSessionOutput because self was deallocated");
            return;
        }
        [strongSelf.captureSession beginConfiguration];
        
        
        //strongSelf.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        //strongSelf.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        
        //strongSelf.captureSession.sessionPreset = AVCaptureSessionPreset3200x2400;
        strongSelf.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        //strongSelf.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
        //strongSelf.captureSession.sessionPreset = AVCaptureSessionPreset3840x2160;
        
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        output.videoSettings = @{
            (id)
            kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]
        };
        output.alwaysDiscardsLateVideoFrames = YES;
        dispatch_queue_t outputQueue = dispatch_queue_create(videoDataOutputQueueLabel.UTF8String, nil);
        
        
        [output setSampleBufferDelegate:self queue:outputQueue];
        
        // 샘플 버퍼 델리게이트와 콜백을 유도하는 큐를 세팅
        // outputQueue : 비디오 프레임을 순차적으로 받는 시리얼 큐
        
        if ([strongSelf.captureSession canAddOutput:output]) {
            [strongSelf.captureSession addOutput:output];
            [strongSelf.captureSession commitConfiguration];
        } else {
            NSLog(@"%@", @"Failed to add capture session output.");
        }
    });
}

#pragma mark 텍스트 라벨 추가 함수
-(UILabel*)getTextLabelWithCGRect :(CGRect) standardizedRect
                  withDisplayValue:(NSString*) displayValue {
    
    CGRect textLabelRect = [self getRotatedCGRect:standardizedRect];
    UILabel *label = [[UILabel alloc] initWithFrame:textLabelRect];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSMutableString *description = [NSMutableString new];
    if (displayValue)
        [description appendString:displayValue];
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {

        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor yellowColor];
        label.layer.borderWidth = 1.0;
        label.layer.borderColor = [UIColor yellowColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.string = description;
        textLayer.fontSize = label.font.pointSize;
        
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.wrapped = YES;
        textLayer.foregroundColor = label.textColor.CGColor;
        textLayer.backgroundColor = label.backgroundColor.CGColor;
        textLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
        
        textLayer.frame = label.bounds;
        
        CALayer *layer = label.layer;
        [layer addSublayer:textLayer];
        
    } else {
        
        label.numberOfLines = 0;
        label.text = description;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor yellowColor];
        label.layer.borderWidth = 1.0;
        label.layer.borderColor = [UIColor yellowColor].CGColor;
        
    }
    return label;
}


#pragma mark 텍스트 라벨 박스 사이즈 가로세로 대응
-(CGRect) getRotatedCGRect :(CGRect) standardizedRect {
    
    CGRect textLabelRect;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        
        textLabelRect = CGRectMake( standardizedRect.origin.x + standardizedRect.size.width,// X
                                    standardizedRect.origin.y,                              // Y
                                    20,                                                     // Width
                                    standardizedRect.size.height / 2 );                     // Height
    } else {
        textLabelRect = CGRectMake( standardizedRect.origin.x,          // X
                                    standardizedRect.origin.y   - 20,   // Y
                                    standardizedRect.size.width  / 2,   // Width
                                    20 );                               // Height
        /**
         *
         우측 박스 내부 상단에 텍스트 라벨 생성
         CGRect textLabelRect = CGRectMake(  standardizedRect.origin.x + (standardizedRect.size.width  / 2),    // X
                                             standardizedRect.origin.y,//   - 20,                               // Y
                                             standardizedRect.size.width  / 2,                                  // Width
                                             20 );                                                              // Height
         */
    }
    
    return textLabelRect;
}


#pragma mark 카메라 인스턴스 ( Zoom 관련 )
- (void)setUpCaptureSessionInput {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sessionQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            NSLog(@"Failed to setUpCaptureSessionInput because self was deallocated");
            return;
        }
        
        
        AVCaptureDevicePosition cameraPosition = strongSelf.isUseFrontCamera ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        //AVCaptureDevice *device = [strongSelf captureDeviceForPosition:cameraPosition];
        
        strongSelf.device = [strongSelf captureDeviceForPosition:cameraPosition];
        // 카메라 인스턴스 생성
        
        if (strongSelf.device) {
            [strongSelf.captureSession beginConfiguration];
            NSArray<AVCaptureInput *> *currentInputs = strongSelf.captureSession.inputs;
            for (AVCaptureInput *input in currentInputs) {
                [strongSelf.captureSession removeInput:input];
            }
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:weakSelf.device
                                                                                error:&error];
            if (error) {
                NSLog(@"Failed to create capture device input: %@", error.localizedDescription);
                return;
            } else {
                if ([strongSelf.captureSession canAddInput:input]) {
                    [strongSelf.captureSession addInput:input];
                    if ([strongSelf.device lockForConfiguration:&error]) {
                        
                        if ( strongSelf.device.maxAvailableVideoZoomFactor <= self.zoomFactor )
                            strongSelf.device.videoZoomFactor = strongSelf.device.maxAvailableVideoZoomFactor;
                         else if ( weakSelf.device.minAvailableVideoZoomFactor >= self.zoomFactor )
                             strongSelf.device.videoZoomFactor = strongSelf.device.minAvailableVideoZoomFactor;
                         else
                             strongSelf.device.videoZoomFactor = self.zoomFactor;
                        
                        
                        [strongSelf.device unlockForConfiguration];
                    } else {
                        NSLog(@"%@",[error description]);
                    }
                } else {
                    NSLog(@"%@", @"Failed to add capture session input.");
                }
            }
            [strongSelf.captureSession commitConfiguration];
        } else {
            NSLog(@"Failed to get capture device for camera position: %ld", cameraPosition);
        }
    });
}

- (void)startSession {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sessionQueue, ^{
        [weakSelf.captureSession startRunning];
    });
}

- (void)stopSession {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_sessionQueue, ^{
        [weakSelf.captureSession stopRunning];
    });
}

#pragma mark - 카메라 화면영역
- (void)setUpPreviewOverlayView {
    [_cameraView addSubview:_previewOverlayView];
    [NSLayoutConstraint activateConstraints:@[
        [_previewOverlayView.centerYAnchor  constraintEqualToAnchor:_cameraView.centerYAnchor],
        [_previewOverlayView.centerXAnchor  constraintEqualToAnchor:_cameraView.centerXAnchor],
        //[_previewOverlayView.leadingAnchor  constraintEqualToAnchor:_cameraView.leadingAnchor],
        [_previewOverlayView.leftAnchor constraintEqualToAnchor:_cameraView.leftAnchor],
        [_previewOverlayView.rightAnchor constraintEqualToAnchor:_cameraView.rightAnchor],
        [_previewOverlayView.topAnchor constraintEqualToAnchor:_cameraView.topAnchor],
        [_previewOverlayView.bottomAnchor constraintEqualToAnchor:_cameraView.bottomAnchor],
        [_previewOverlayView.widthAnchor constraintEqualToAnchor:_cameraView.widthAnchor],
        [_previewOverlayView.heightAnchor constraintEqualToAnchor:_cameraView.heightAnchor]
        
    ]];
}

#pragma mark - 박스영역
- (void)setUpAnnotationOverlayView {
    [_cameraView addSubview:_annotationOverlayView];
    
    [NSLayoutConstraint activateConstraints:@[
        [_annotationOverlayView.topAnchor      constraintEqualToAnchor:_cameraView.topAnchor],
        [_annotationOverlayView.leadingAnchor  constraintEqualToAnchor:_cameraView.leadingAnchor],
        [_annotationOverlayView.trailingAnchor constraintEqualToAnchor:_cameraView.trailingAnchor],
        [_annotationOverlayView.bottomAnchor   constraintEqualToAnchor:_cameraView.bottomAnchor]
    ]];
}

- (AVCaptureDevice *)captureDeviceForPosition:(AVCaptureDevicePosition)position {
    if (@available(iOS 10, *)) {
        AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession
                                                             discoverySessionWithDeviceTypes:@[ AVCaptureDeviceTypeBuiltInWideAngleCamera ]
                                                             mediaType:AVMediaTypeVideo
                                                             position:AVCaptureDevicePositionUnspecified];
        for (AVCaptureDevice *device in discoverySession.devices) {
            if (device.position == position) {
                return device;
            }
        }
    }
    return nil;
}


- (void)removeDetectionAnnotations {
    for (UIView *annotationView in _annotationOverlayView.subviews) {
        [annotationView removeFromSuperview];
    }
}

- (void)updatePreviewOverlayViewWithLastFrame {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(_lastFrame);
    [self updatePreviewOverlayViewWithImageBuffer:imageBuffer];
}

#pragma mark - 캡쳐영역 ( 이미지 버퍼 )
- (void)updatePreviewOverlayViewWithImageBuffer:(CVImageBufferRef)imageBuffer {
    if (imageBuffer == nil) {
        return;
    }
    UIImageOrientation orientation =
    isUseFrontCamera ? UIImageOrientationLeftMirrored : UIImageOrientationRight;
    UIImage *image = [UIUtilities UIImageFromImageBuffer:imageBuffer orientation:orientation];
    
    _previewOverlayView.image = image;
}


#pragma mark - 캡쳐영역 ( AVCaptureVideoDataOutputSampleBufferDelegate )

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    
    // AVCaptureVideoDataOutputSampleBuffer 델리게이트를 통해 실시간으로 캡쳐된 동영상의 프레임을 버퍼로 해당 뷰컨트롤러에 받는다
    // AVCaptureVideoDataOutputSampleBufferDelegate 는 video data output 에서 sample buffer를 받아오며, 받아오는 video data output의 상태를 감시한다.
    if (imageBuffer) {
        _lastFrame = sampleBuffer;
        
        // 프레임 단위로 버퍼에 들어가서 이미지를 분석한다.
        MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithBuffer:sampleBuffer];
        // 마지막 버퍼를 기준으로 비전이미지 인스턴스 생성
        // 비전 이미지 : 비전 감지에 사용되는 이미지 또는 이미지 버퍼
        
        UIImageOrientation orientation = [UIUtilities
                                          imageOrientationFromDevicePosition:isUseFrontCamera ? AVCaptureDevicePositionFront
                                          : AVCaptureDevicePositionBack];
        
        //디바이스의 회전방향을 참조해서 이미지 방향을 가져온다.
        visionImage.orientation = orientation;
        // 비전 이미지 방향설정
        
        CGFloat imageWidth = CVPixelBufferGetWidth(imageBuffer);
        CGFloat imageHeight = CVPixelBufferGetHeight(imageBuffer);
        // 버퍼를 통해 이미지 가로세로 길이 Get
        
        
        MLKBarcodeScannerOptions *options = [[MLKBarcodeScannerOptions alloc]
                                             initWithFormats: self.barcodeFormat ];
        
        [self scanBarcodesOnDeviceInImage:visionImage
                                    width:imageWidth
                                   height:imageHeight
                                  options:options];
    } else {
        NSLog(@"%@", @"Failed to get image buffer from sample buffer.");
    }
}

@end

NS_ASSUME_NONNULL_END
