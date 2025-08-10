# AppImage.desktop 생성 스크립트 사용 안내

- 이 스크립트는 Arduino 2.x AppImage에서 아이콘을 추출하고  `.desktop` 파일을 생성하여 우분투 24 이상 시스템 메뉴에서 쉽게 실행할 수 있도록 합니다.  
- Electron 샌드박스 문제 해결을 위해 자동으로 `ELECTRON_DISABLE_SANDBOX=1` 환경변수를 추가합니다.
- ELECTRON_DISABLE_SANDBOX=1 옵션은 샌드박스 격리 기능을 꺼서 보안이 약화될 수 있으니 신뢰할 수 있는 AppImage에만 사용하세요.

## 사용법

### 0. 스크립트 다운

```bash
wget https://github.com/BasicLike/arduino2.x_appimage-desktop-entry/blob/main/appimage-desktop-entry.sh
```


### 1. 스크립트에 실행 권한 부여

터미널에서 아래 명령어를 입력하세요. (스크립트 파일명이 `appimage-desktop-entry.sh`라고 가정)

```bash
chmod +x appimage-desktop-entry.sh
```


### 2. 스크립트 실행

실행하면 AppImage 내부에서 사용할 아이콘 목록이 표시되고, 선택할 번호를 입력합니다. 기본값은 1번입니다.

```bash
./appimage-desktop-entry.sh ~/Downloads/arduino-ide_2.3.6_Linux_64bit.AppImage
```


### 3. 메뉴 제거

시스템 메뉴에 등록된 .desktop 파일과 아이콘을 삭제하려면 두 번째 인자로 --remove 옵션을 사용하세요.

```bash
./appimage-desktop-entry.sh ~/Downloads/arduino-ide_2.3.6_Linux_64bit.AppImage --remove
```
