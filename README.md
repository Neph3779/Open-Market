**프로젝트명: 오픈마켓**

**프로젝트 설명:** 서버로부터 상품의 정보를 받아와서 collection view를 통해 두가지 형태로 보여주고, 상품을 직접 앱 내에서 제작하여 서버로 업로드할 수 있는 앱

**진행기간: 2021/05/10 ~ 2021/05/28 (약 3주)**

**프로젝트 진행인원: 2인**

## 주요 학습 내용

- URLSession
- 비동기 프로그래밍
- HTTP 통신
- multipart/form-data를 통한 텍스트, 파일 업로드
- Protocol Oriented Programming을 통해 testable한 코드 작성하기



## 프로젝트 진행 과정





## 주요 피드백과 개선내역

**Step1 PR 링크:** https://github.com/yagom-academy/ios-open-market/pull/25

**Step2 PR 링크:** https://github.com/yagom-academy/ios-open-market/pull/31

<br/>



## 프로젝트를 진행하며 느낀점



## 이후 리팩토링 내역

**2021.10.13**

> 안녕하세요! 갱신된 오픈마켓 API를 전달드립니다 
>
> 주요 변경사항은 아래와 같습니다. 
>
> 1. host 주소가 변경되었습니다 
> 2. 상품 리스트 조회에 search_value 쿼리가 추가되었습니다. 
> 3. 상품삭제를 위해 2번의 API를 거쳐야만 합니다(상품삭제 URI 조회 -> 상품삭제) 자세한 사항은 전달해드리는 API 명세를 참고해주시길 바랍니다. 아울러 기존 데이터는 리셋되었습니다. 
>
> API 이용에 필요한 벤더 정보도 함께 전달드리니 API를 참고하시어 이용바랍니다. {    "name": "secondVendor",    "accessId":"secondVendor",    "secret":"kbs111111",    "identifier": "9f12b7ca-4aa0-11ed-a200-83859d23efd1" }

다음과 같은 메세지를 전달받았고 API 명세서를 확인해보니 model쪽의 변경, encoding 로직의 변경도 필요했기에 리팩토링을 진행하면서 지난 프로젝트 진행 기간중에 완료하지 못한 구현을 진행하기로 했다.



서버로 post시

사용자로부터 가져온 정보를

encoding이 가능한 모델에 담고 // encoding 실패 가능

이 모델을 바탕으로 request의 httpBody를 제작하고 + 요청에 맞는 request header를 구성하고 // request 구성시 에러 발생 가능, RequestBodyEncoder 객체 사용

request를 만들어 URLSession의 dataTask를 실행 // dataTask completion에 에러처리, 데이터 처리 로직 필요



request를 만드는 객체 필요 (?) 

모든 api call마다 필요한 request 형식이 다를텐데 

