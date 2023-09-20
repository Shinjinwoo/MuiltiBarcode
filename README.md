

- 개발의도 : 하이브리드 앱 환경에서 디바이스 카메라를 활용해 실시간으로 여러줄의 바코드와 QR 정보를 얻기 위해 만들어 졌습니다.

- 바코드 세팅 넥사크로 화면 [WebView에 띄운 HTML5 페이지로 보아도 무방]

<img src="https://lh5.googleusercontent.com/U1Z-SOz9ySDI0BGECf_PI4Vk_meeiKR20_HIVXcbwJ5Z_ntnQ4PnEKendj1Zp8LVIMRekz4ej1pTsHNjG-F2zWA3f-vrcq_EO5s4U3h7Uxas_1LNYE9nLmhgpgxJL2NBJosknkoUSydQTu1QKIS0J-E" width="294" height="635"/>

- 캡쳐 화면 [Native ViewController]

<img src="https://lh4.googleusercontent.com/8RE-nCtonMSpOwt8MiX-ZBSmxG-h_tjWGI94F5Y0n9z48pobbd6XmBrvdjhioGWtLcQLxxrElbZffnSCzgdIBViMXJOKScKu76gQzPkaovm0V--7jU5W_7-it3HZ_6ZKBj3SarypU5RaRHVQCvy0srY" width="294" height="635"/>

- 캡쳐 결과 전송

<img src="https://lh5.googleusercontent.com/iU2bKvnThl7GXQTYFdZrMUkScHkDHPrkic59cNriuAgyF7vfWUIDDZi8CAw1QQX6Ei2PmpbeheyljjP2pAJeSYm8fYzf2WbjdLwgQb3F5jY9j5MyTRa7ZyZzsGHuTdixM0yzwwgHxgW8rKoS6vqsU8g" width="294" height="635"/>



## 플러그인 사용 개요


|플러그인명|MultiQRBarcode|
|:---:|:---:|
|서비스 메소드명| scan |


- Scan 결과 Result Code

| reason | Code |
|:---:|:---:|
|카메라 퍼미션 획득 실패 | -9 |
| 성공 | 0 |
| 실패 | -1 |



1. 연동 Javascript 복사
	레포지토리의 nexacroN_ui/nexacrolib/component 폴더에서 아래 파일을 
    넥사크로 프로젝트 → Tools →Option → Project → Nexacro SDK → Base Library
    경로에 복사


|![](https://lh5.googleusercontent.com/1aajGU6hkkAUqvPpm7k6WGf5ema0VpsKOD3xXDvTdo4MMcCvt698c5ZwRGpuqQqVwCVnANxncsq83dKC8a6Xulh_k1h4r0-py7pfkrsehcpKdPHu84tVokg-CWH2zDff7kSMrwDDo386eazTD3UuLsc) |
|:---:|
|**![](https://lh6.googleusercontent.com/BWHdFMQ5VecJ7MhQiF1YTTeX5Bb84ptjPbjEYGaHwAPM8aJWrVTAoqN803MIQS056_T-G4nj-vSXcnjlcGSqkwgU6ACeiIvPjCSZjYnWSMu-Vbm8kjpGiQk_3XrPxLJhc-hDarj1hDNolcgDHeghScA)** |

2. 넥사크로 TypeDefinition의 Objects에 MultiQRBarcodePlugin.json 등록

| **![](https://lh6.googleusercontent.com/fLiCm83Tfb5GnUi4HuLTIqYgJf-TW6ULkYQdNeF8vOqN0R9Nx0HRnHM8H6UynsQNeFMKXXqJ-tzf-3IbWwpUv9Y4imiPAZzLHGw8Gbi_m4h_Z-G2ZF-fVd7FWU0u-08bfyCSTsIq0qenbsKqr_XPOKo)**| **![](https://lh5.googleusercontent.com/EGbXNlDfNYnz3-CDSelLKh1h_0p6ojtOFLmpwEMP7Inqthux9RIf1C33AdZSA8DmD9mjTCy1oFD2_QcAm6rhZv-6OZrmS2-8S-jKlweOMQvZ-kmJ4A5oO0PupZqoGPVY2tftuJ2-Xp-TP-Cdf0LQvuo)**|
|---|---|

3. MultiQRBarcodePlugin 연동 함수
  
## 모듈 생성자
 - nexacro.MultiQRBarcodePlugin() 함수를 사용합니다.
```javascript
this.addChild("multiQRBarcodePlugin",new nexacro.MultiQRBarcodePlugin());
```
##  callMethod()
 - 모듈의 기능을 호출하는 함수 입니다.
 - scan [ 스캔시작 ] : 유저가 설정한 Input param으로 스캔 시작

```javascript
 var param = { "cameraID"       : "1",    
               "useTextLabel"   : "true",
               "useSound"       : "false",   
               "useAutoCapture" : "false", 
               "limitCount"     : "200",
               "zoomFactor"     : "2.0",
               "scanFormat":[ this.multiBarcodePlugin.FORMAT.CODE_39,
                              this.multiBarcodePlugin.FORMAT.CODE_93 ] }
```

|<center>명칭</center>|<center>설명</center>|
|---|---|
|cameraID|전면 카메라로 전환여부 [ 기본값 : 후면 카메라 ]|
|useTextLabel|캡쳐 화면에 바인딩할 네이티브 텍스트 라벨 사용여부|
|useSound|사운드 효과 사용여부|
|useAutoCapture|오토 캡쳐 사용여부|
|limitCount|데이터 누적 카운트|
|zoomFactor|카메라 확대 배율 [ float ]|
|scanFormat|스캔할 포맷 [ Array 형식 ]|


사용예 )

```Javascript
this.multiQRBarcodePlugin.callMethod("scan", param);
```

## addEventHandler()
	1) callMethod() 함수 호출 후 결과를 받아오는 함수를 "oncallback" 에 등록해 줍니다.
		등록할 함수는 모듈 Object 와 처리 결과값 입니다.
           처리 결과값에는 아래 값들을 포함합니다.
                - svcid : 모듈 호출 시 사용한 서비스 ID 이 경우 “sacn”
                - reason : 호출 성공여부 (성공 : 0, 실패 : -1, 카메라 권한 획득 실패 : -9 )
                - returnvalue : 모듈 호출 결과 메세지가 JSON Object 값으로 리턴됩니다.

사용예 ) 

```Javascript
this.MultiQRBarcodePlugin_onload = function(obj:nexacro.Form,e:nexacro.LoadEventInfo) {
    // FROM onLoad 이벤트시 
    this.addChild("multiQRBarcode",new nexacro.MultiQRBarcodePlugin());
    this.multiQRBarcode.addEventHandler(
        "oncallback",this.on_MultiQRBarcodePlugin_callback,this);
};


this.on_MultiQRBarcodePlugin_callback = function(obj, e) {
    trace("this.on_MultiBarcodePlugin_callback ::: "+e.svcid);
    trace("this.on_MultiBarcodePlugin_callback ::: "+e.reason);
    trace("this.on_MultiBarcodePlugin_callback ::: "+JSON.stringify(e.returnvalue)); 
}

```

## 상수 정리표

MultiQRBarcodePlugin.js에 등록

- 바코드 포멧 상수 
```Javascript
// 바코드에서 사용하는 포맷 상수
MultiQRBarcodePlugin.FORMAT = {
    UNKNOWN     : -1,   // 포맷특정 불가
    ALL_FORMATS : 0,    // 모든 포맷
    CODE_128    : 1,    // CODE_128
    CODE_39     : 2,    // CODE_39
    CODE_93     : 4,    // CODE_93
    CODABAR     : 8,    // CODABAR
    DATA_MATRIX : 16,   // DATA_MATRIX
    EAN_13      : 32,   // EAN_13
    EAN_8       : 64,   // EAN_8
    ITF         : 128,  // ITF
    QR_CODE     : 256,  // QR_CODE
    UPC_A       : 512,  // UPC_A
    UPC_E       : 1024, // UPC_E
    PDF417      : 2048, // PDF417
    AZTEC       : 4096  // AZTEC
};
```
- 바코드 valueType 상수 
```Javascript
MultiQRBarcodePlugin.TYPE = {
    UNKNOWN         : 0,    // 밸류 타입 특정 불가
    CONTACT_INFO    : 1,    // 연락처 정보
    EMAIL           : 2,    // 이메일 주소
    ISBN            : 3,    // ISBN의 바코드 값 유형
    PHONE           : 4,    // 전화번호 유형
    PRODUCT         : 5,    // 프로덕트 코드
    SMS             : 6,    // SMS 값 유형입니다.
    TEXT            : 7,    // 일반 텍스트의 바코드 값 유형입니다.
    URL             : 8,    // URL/북마크의 바코드 값 유형입니다.
    WIFI            : 9,    // Wi-Fi 액세스 포인트 세부정보
    GEO             : 10,   // 지리 좌표의 바코드 값 유형입니다.
    CALENDAR_EVENT  : 11,   // QRCode에 담겨져 있는 달력 이벤트
    DRIVER_LICENSE  : 12    // 운전면허증 데이터의 바코드 값 유형입니다. 
};```



## Xcode 프로젝트 설정

1. cocoapod 라이브러리 설치 
	사용예 ) Podfile : [코코아팟 사용법 참조](https://velog.io/@james-chun-dev/Xcode-Cocoapod-%EC%82%AC%EC%9A%A9%EB%B2%95) 

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'nexacroApp' do
 # Comment the next line if you don't want to use dynamic frameworks
 use_frameworks!


 # Pods for nexacroApp
 pod 'GoogleMLKit/BarcodeScanning', '3.2.0'


end
```

2. 샘플 프로젝트 ‘MultiQRBarcode’ 디렉토리 내에 필요한 파일, 프로젝트에 첨부

| <center>파일명</center> |<center>용도</center> |
|---|---|
| MultiQRBarcodePlugin.h,<br> MultiQRBarcodePlugin.m| 멀티 바코드 플러그인 인스턴스iOS Runtime의 경우<br> h,m파일명을‘MultiQRBarcodePlugin’ 으로 <br>일치 시켜야 JS에서 인스턴스 인식|
|MultiQRBarcodeViewController.h,<br>MultiQRBarcodeViewController.m|멀티 바코드 인식 및 화면 제어용 뷰 컨트롤러|
| MultiQRBarcodeViewController.xib | 네이티브 UI용 XIB 파일 |
| UiUtilites.h,UiUtilites.m | 네이티브 UI 제어용 유틸리티 파일 |
| scan_beep.mp3 | 스캔 사운드 파일 |


3. AppDelegate.h 파일 내 MultiQRBarcodePlugin 인스턴스 synthesize 코드 삽입

- AppDelegate.h 파일
```objc
#import "MultiQRBarcodePlugin.h"

@interface AppViewController : NexacroMainViewController
{
    
}
@property (nonatomic, assign) MultiQRBarcodePlugin *multiQRBarcodePlugin;
@end

```

- AppDelegate.m 파일 
```objc
#import "AppDelegate.h"
@implementation AppViewController
@synthesize multiQRBarcodePlugin;

@end
```

4. info.plist에 카메라 권한 설정 부여
	- info.plist에만 카메라 권한 사용이 명시 되면, iOS Runtime 모듈 내에서 코드로 후 처리
		 [카메라 권한 설정 참조](https://adjh54.tistory.com/126)

5. PluginCommonNP 프레임워크 추가
	- 샘플 프로젝트에 같이 첨부된 Library/PluginCommonNP.framework 추가
