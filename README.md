



- 개발의도 : 하이브리드 앱 환경에서 디바이스 카메라를 활용해 실시간으로 여러줄의 바코드와 QR 정보를 얻기 위해 만들어 졌습니다.

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

addEventHandler()
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
