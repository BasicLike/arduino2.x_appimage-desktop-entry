# AppImage .desktop 생성 스크립트 사용 안내

## 실행 방법

### 1. 스크립트에 실행 권한 부여

터미널에서 아래 명령어를 입력하세요. (스크립트 파일명이 `appimage-desktop-entry.sh`라고 가정)

```bash
chmod +x appimage-desktop-entry.sh```

### 2. 스크립트 실행

2.1 실행
```bash
./appimage-desktop-entry.sh ~/Downloads/arduino-ide_2.3.6_Linux_64bit.AppImage
실행하면 AppImage 내부에서 사용할 아이콘 목록이 표시되고, 선택할 번호를 입력합니다. 기본값은 1번입니다.

2.2 아이콘 선택

실행하면 AppImage 내부에서 사용할 아이콘 목록이 표시되고, 선택할 번호를 입력합니다. 기본값은 1번입니다.

### 3. 메뉴 제거

시스템 메뉴에 등록된 .desktop 파일과 아이콘을 삭제하려면 두 번째 인자로 --remove 옵션을 사용하세요.

```bash
./appimage-desktop-entry.sh ~/Downloads/arduino-ide_2.3.6_Linux_64bit.AppImage --remove
