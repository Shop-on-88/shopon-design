# 매일 샘플 추가 작업 절차

이 저장소(Shop-on-88/shopon-design)는 design.shoponph.online 에 자동 반영된다(서버가 5분마다 pull).
매일 실행되는 예약 작업은 아래 절차로 **종류마다 1개씩, 총 4개**의 새 샘플을 만들어 올린다.

## 0. 준비
- 제작 규칙은 docs/BRIEF.md 를 먼저 읽고 그대로 따른다(가상 상호, 실적·후기·"BEST"·"1위" 금지, 실존 브랜드 로고·문구 금지, 외부 이미지 금지, 인라인 SVG 일러스트, Google Fonts 만).
- samples/manifest.json 을 읽어 이미 있는 샘플의 type·cat·name 을 확인한다. 같은 업종·같은 스타일을 반복하지 않는다.

## 1. 오늘 만들 4개 정하기
- type 4종: homepage, menu, sns, landing 각 1개.
- 업종(cat)은 그 type 에서 아직 없거나 가장 적은 업종을 고른다. 업종 후보: food(한식·고기·분식·중식·일식·양식·베이커리·치킨·주점), cafe, beauty(헤어·네일·속눈썹·피부), spa(마사지·찜질), travel(여행사·골프투어·리조트), shop(쇼핑몰), etc(학원·부동산·병원 외 의료효능 문구 없는 업종·피트니스·노래방/KTV·세탁·꽃집·사진관·인테리어·자동차정비·펜션·렌터카·환전/송금 제외).
- 4개 중 1개는 영어판(필리핀 현지 고객 대상, ₱)으로 만든다. 나머지는 한국어(한국 가게는 원, 필리핀 교민 가게는 ₱).
- 4개는 서로 색·배치·글꼴이 겹치지 않게.

## 2. 종류별 산출물 (samples/<slug>/)
slug 는 영문 소문자-하이픈, 기존과 겹치지 않게(예: menu-chicken-01).
- homepage: index.html (반응형 단일 파일, 7~10구역, 예약·상담은 화면 안 동작만)
- landing: index.html (한 장짜리 광고 착지 페이지, 신청 양식은 화면 안 동작만, 후기 섹션 없음)
- menu: page1.png(+page2.png) A4 세로 2480×3508, index.html = 이미지를 보여 주는 보기 페이지(메뉴판 이미지 크게 + "이 디자인으로 상담하기" 버튼 → https://design.shoponph.online/#inquiry). 웹메뉴판 겸용이면 메뉴판 HTML 자체를 index.html 로 해도 된다.
- sns: feed.png 1080×1080, portrait.png 1080×1350, story.png 1080×1920, index.html = 세 장을 보여 주는 보기 페이지(같은 상담 버튼).
- 공통: thumb.jpg 720×450(품질 78). homepage·landing 은 PC 1440×900 첫 화면을 찍어 줄인 것, menu·sns 는 대표 이미지를 16:10 으로 보기 좋게 배치한 것(배경 위에 이미지를 올린 썸네일).
- 렌더링: python3 playwright, chromium.launch(executable_path='/usr/bin/google-chrome', args=['--no-sandbox']) (없으면 pip install playwright && playwright install chromium 후 기본 실행), document.fonts.ready 대기.

## 3. 검수 (각 샘플마다, 통과 못 하면 올리지 않는다)
- 개발 후 캡처를 직접 열어 보고 넘침·잘림·겹침·빈 그림·가로 스크롤(375/1440)·11px 미만 글자를 고친다. 2회 반복.
- 별도의 "디자이너" 서브에이전트에게 캡처를 보여 주고 OK/수정 판정을 받는다(코드 안 고치고 판정만). 수정이면 고치고 다시 판정. 3번 안에 통과 못 하면 그 샘플은 오늘 제외.
- grep 으로 BEST, 1위, 인기, 후기, 별점, 최저가, 역대급 이 없는지 확인. 실존 브랜드명 없는지 확인.

## 4. 목록 갱신과 올리기
- samples/manifest.json 의 items 맨 앞에 통과한 샘플 항목 추가: {"slug","type","cat","code","name","name_en","desc","desc_en","added":"YYYY-MM-DD"}
  - code 규칙: SD- + 종류 약자(HP 홈페이지, MN 메뉴판, SN SNS, LP 랜딩) + 업종 약자(FD,CF,BT,SP,TR,SH,ET) + 두 자리 번호. 같은 접두가 있으면 번호를 이어서.
- manifest.json 이 올바른 JSON 인지 python 으로 검사.
- 커밋 메시지는 반드시 "샘플: " 으로 시작하고 추가한 샘플 이름을 나열한다(서버가 이 커밋을 보고 텔레그램 알림을 보낸다). 예: "샘플: 메뉴판 바삭치킨, SNS 꽃집 봄 이벤트, 랜딩 네일 첫 방문, 홈페이지 세탁소"
- git push. 실패하면 한 번만 재시도하고, 그래도 실패하면 이유를 보고한다.

## 5. 보고
마지막 응답에 오늘 추가한 샘플 4개(이름·종류·업종·주소 https://design.shoponph.online/samples/<slug>/)와 제외된 것이 있으면 그 이유를 짧게.
