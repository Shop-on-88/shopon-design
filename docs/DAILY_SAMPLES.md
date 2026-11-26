# 매일 샘플 추가 작업 절차

이 저장소(Shop-on-88/shopon-design)는 design.shoponph.online 에 자동 반영된다(서버가 5분마다 pull).
매일 실행되는 예약 작업은 아래 절차로 **종류마다 1개씩, 총 4개**의 새 샘플을 만들어 올린다.

## 0. 준비
- 제작 규칙은 docs/BRIEF.md 를 먼저 읽고 그대로 따른다(가상 상호, 실적·후기·"BEST"·"1위" 금지, 실존 브랜드 로고·문구 금지, 외부 이미지 금지, 인라인 SVG 일러스트, Google Fonts 만).
- 디자인 품질 기준 docs/DESIGN_QUALITY.md 도 처음부터 끝까지 읽는다. 샘플마다 코드를 쓰기 전에 "방향 다섯 줄"을 먼저 정하고, 완성 후 그 문서의 체크리스트로 스스로 점검한다. 디자이너 검수도 BRIEF.md 와 DESIGN_QUALITY.md 둘 다를 기준으로 한다(보라색 그라데이션·그라데이션 글자·이모지 아이콘·깜빡이는 효과·hover 확대·과장 문구·헤드라인 위 알약 배지 등은 바로 수정 대상).
- index.html 안의 시안 목록({s:'slug',code:'SD-..',cat:'..',ko:[이름,종류,스타일],en:[...]} 항목들)과 썸네일 목록("slug": "/samples/thumbs/slug.jpg")을 읽어 이미 있는 샘플을 확인한다. 같은 업종·같은 스타일을 반복하지 않는다.

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
- 공통: 썸네일은 samples/thumbs/<slug>.jpg 720×450(품질 78). homepage·landing 은 PC 1440×900 첫 화면을 찍어 줄인 것, menu·sns 는 대표 이미지를 16:10 으로 보기 좋게 배치한 것(배경 위에 이미지를 올린 썸네일).
- 렌더링: python3 playwright, chromium.launch(executable_path='/usr/bin/google-chrome', args=['--no-sandbox']) (없으면 pip install playwright && playwright install chromium 후 기본 실행), document.fonts.ready 대기.

## 3. 검수 (각 샘플마다, 통과 못 하면 올리지 않는다)
- 개발 후 캡처를 직접 열어 보고 넘침·잘림·겹침·빈 그림·가로 스크롤(375/1440)·11px 미만 글자를 고친다. 2회 반복.
- 별도의 "디자이너" 서브에이전트에게 캡처를 보여 주고 OK/수정 판정을 받는다(코드 안 고치고 판정만). 수정이면 고치고 다시 판정. 3번 안에 통과 못 하면 그 샘플은 오늘 제외.
- grep 으로 BEST, 1위, 인기, 후기, 별점, 최저가, 역대급 이 없는지 확인. 실존 브랜드명 없는지 확인.

## 4. 목록 갱신과 올리기
- index.html 의 시안 목록 배열에 통과한 샘플 항목을 기존 같은 종류 항목 뒤에 추가한다. 형식은 기존 항목과 똑같이:
  {s:'menu-pho',code:'SD-MN04',cat:'menu',ko:['이름','메뉴판','스타일 두세 단어'],en:['Name','Menu','style words']}
  - cat: 홈페이지는 업종(food, beauty, travel, shop 등 기존 값 중 하나), 메뉴판은 'menu', SNS 광고는 'sns', 랜딩페이지는 'landing'.
  - code: 홈페이지는 SD-+업종약자(FD,CF,HR,SP,TR,SH 등)+번호, 메뉴판 SD-MN, SNS SD-SN, 랜딩 SD-LP + 이어지는 두 자리 번호.
- 같은 파일의 썸네일 목록 객체에도 "slug": "/samples/thumbs/slug.jpg" 를 추가한다.
- 고친 index.html 을 로컬 서버(python3 -m http.server)로 열어 갤러리에 새 카드 4개가 썸네일과 함께 보이는지, JS 오류가 없는지 playwright 로 확인한다.
- 커밋 메시지는 반드시 "샘플: " 으로 시작하고 추가한 샘플 이름을 나열한다(서버가 이 커밋을 보고 텔레그램 알림을 보낸다). 예: "샘플: 메뉴판 바삭치킨, SNS 꽃집 봄 이벤트, 랜딩 네일 첫 방문, 홈페이지 세탁소"
- git push. 실패하면 한 번만 재시도하고, 그래도 실패하면 이유를 보고한다.

## 5. 보고
마지막 응답에 오늘 추가한 샘플 4개(이름·종류·업종·주소 https://design.shoponph.online/samples/<slug>/)와 제외된 것이 있으면 그 이유를 짧게.
