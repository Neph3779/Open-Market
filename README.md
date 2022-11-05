**프로젝트명: 오픈마켓**

**프로젝트 설명:** 서버로부터 상품의 정보를 받아와서 collection view를 통해 두가지 형태로 보여주고, 상품을 직접 앱 내에서 제작, 수정, 삭제 요청을 보낼 수 있는 앱

**진행기간: 2021/05/10 ~ 2021/05/28 (약 3주)**

**프로젝트 진행인원: 2인**

**작동화면**

| ![1](https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221105183216.gif) | ![2](https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221105183312.gif) | ![3](https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221105183342.gif) |
| :----------------------------------------------------------: | ------------------------------------------------------------ | ------------------------------------------------------------ |



## 주요 학습 내용

- URLSession
- 비동기 프로그래밍
- HTTP 통신
- multipart/form-data를 통한 텍스트, 파일 업로드
- Protocol Oriented Programming을 통해 testable한 코드 작성하기
  - URLProtocol을 활용하여 네트워크 의존성이 없는 테스트 작성



## 작업 진행과정

**네트워크 계층 구현 및 단위 테스트**

UML을 작성하며 네트워크 계층에 대한 설계를 진행함

각 구조에 대한 설명과 개선은 [1차 PR](https://github.com/yagom-academy/ios-open-market/pull/25)에 기재

| <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514144528.jpg" alt="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514144528.jpg" style="zoom:50%;" /> | <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514141453.jpg" alt="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514141453.jpg" style="zoom:50%;" /> | <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514141259.jpg" alt="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20210514141259.jpg" style="zoom:50%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |



****


## 주요 피드백과 개선내역

**Step1 PR 링크:** https://github.com/yagom-academy/ios-open-market/pull/25

**Step2 PR 링크:** https://github.com/yagom-academy/ios-open-market/pull/31

<br/>

>피드백 1: generic을 사용했네요! 아마도 decode하기 위함이라고 생각되는데, 이러면 `SessionManager`의 역할은 어디까지인가요?
>네트워킹하는 객체? 아니면 네트워킹을 하고 결과를 디코딩해서 모델 객체를 넘겨주는 객체? 후자라면 한 객체가 두 가지 일을 하고 있는 건 아닐까요?
>`SessionManager`는 네트워크에서 데이터를 받아오는 역할만 하고, 중간 계층을 하나 더 둬서 디코드 후 모델을 넘겨주는 방식은 어떨까요?

SessionManager라는 네트워크 계층을 두어서 네트워크 통신작업을 진행했었다.

하지만 어디부터 어디까지가 SessionManager가 처리할 역할인지 정해지지 않았었기에 문제가 되었다.

받아온 Data를 검사하는 작업, Data를 가공하여 원하는 type으로 변환하는 작업, 네트워킹 요청시 필요한 요소들을 만드는 작업 등 다양한 작업들이 존재했고 분리할 수 있는 기능들은 분리하여 별도의 객체로 만들어주었다.



> ```swift
> var item: Page.Item? {
>         didSet {
>             DispatchQueue.global().async {
>                 guard let thumnailURL = self.item?.thumbnails[0],
> ```
>
> 피드백 2: 예전에 서버에 값을 한번 찔러봤는데, 빈 thumnails이 내려오는 경우가 있더라고요. 물론 그런 경우는 서버가 잘못된 경우지만, 이 부분은 `self.item?.thumbnails.first` 정도면 더 안전하지 않을까 싶네요.

guard let 구문 내에서도 배열의 잘못된 인덱스에 접근하면 런타임 에러가 발생하기에 인덱스를 통한 접근보다는 first를 통해 접근하는 것이 더 좋다는 것을 알게되었다.



> ```swift
>            DispatchQueue.global().async {
>                 guard let thumnailURL = self.item?.thumbnails[0],
>                       let url = URL(string: thumnailURL),
>                       let data = try? Data(contentsOf: url),
>                       let image = UIImage(data: data) else { return }
>                 DispatchQueue.main.async {
>                     self.imageView.image = image
>                 }
>             }
> ```
>
> 피드백 3: 무거운 작업은 비동기로 돌리고, UI 반영 작업은 main 스레드에서 하는거 좋네요! 👍👍
> 다만, 셀이 재사용 되었을 때 해당 이미지 리퀘스트의 결과는 어떻게 되는지 생각해보면 좋을 것 같습니다.

DispatchQueue의 global 큐에 Data를 UIImage로 변환하는 작업을 맡기고 main 스레드에서 변환된 image를 설정하는 코드를 작성하였는데, 셀은 재활용되니 만약 셀이 재활용되어 다른 컨텐츠를 보여주어야 하는 상황과 image 로드를 완료한 시점이 겹친다면 엉뚱한 이미지가 셀에 들어가게 된다는 것을 알 수 있었다. 
이를 해결하기 위해 셀별로 image로드 로직과 셀을 구성하는 요소를 담은 인스턴스(item)을 가지게 하여 재활용 되는 시점에는 에러가 발생하지 않도록 조정했다.



> 피드백 4: `Equatable`을 채택한 이유는 뭔가요? 이 프로토콜이 프로덕트 코드에서 사용되나요? 아니면 테스트를 위한 프로토콜 채택인가요? 실제로 사용되지않지만 테스트를 위해 채택한 프로토콜이라면 유닛테스트 타겟에서 `OpenMarketError`가 프로토콜을 채택하게 하는게 좋지않을까요?

테스트 코드를 작성하다 상황에 따라 알맞은 Error를 내뿜는지 확인하기 위해 Equatable 프로토콜을 채택시켜주었다. 하지만 이는 프로덕트 코드가 아닌 테스트 코드에서만 채택시켜서 사용하는 것이 더 적절하다고 생각되어 수정하였다.



> 피드백 5: Equatable을 채택해서 한번만 assertion이 일어났으면 좋겠네요~ 테스트 메소드에는 하나의 assertion만 있는 것이 좋습니다. 무엇을 검증하고자 하는지 나타내니까요.

테스트 코드도 의도와 의미가 명확히 전달되어야 한다는 점을 다시 느꼈다. 여러개의 assertion이 존재하는것보다는 Equatable을 채택하여 인스턴스의 내용이 동일한지 체크하는 것이 더 낫다고 느껴 수정하였다.



## 프로젝트를 진행하며 느낀점

처음으로 네트워크 통신작업을 진행해보며 REST API의 개념, multipart/form-data의 구성방법, 인코딩과 디코딩의 개념 등 다양한 개념에 대해 학습했다. 동시에 Unit test에서 네트워크 의존성이 없는 테스트도 진행해보았다.

네트워킹 로직을 분리하며 코드의 구조에 대해 깊게 고민해보았고 testable한 코드를 만들기 위해 노력하다보니 자연스럽게 객체간의 커플링 문제가 해결되는 것도 알 수 있었다. 

야곰 아카데미에서 진행한 프로젝트 중 팀원과 가장 많은 대화를 한 프로젝트였는데 페어 프로그래밍을 적극 활용하여 서로가 서로의 코드에 대해 완전히 이해하고 더 좋은 코드를 만들어나갈 수 있었다.



## 프로젝트 기간 이후 리팩토링 내역

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



### 이전 코드들의 문제점

- 난해한 네트워크 로직
  - 주어진 API 명세서에만 집중해 사용가능한 "모든" API call을 하나의 객체가 모두 해결하도록 하려다보니 인코딩과 관련한 로직, api 콜 로직 자체가 지나치게 복잡했었다.
  - 당시에 주어진 API 명세서가 이후에 변경될 가능성을 고려하지 않고 중복코드를 줄이는 것만 생각하다보니 생긴 결과였다.
  - 예를 들면 당시에는 POST요청의 httpBody가 오직 multipart/form-data로만 구성되었었다면 바뀐 명세서에서는 POST 요청의 종류가 늘어났고 그 중 json body를 요구하는 경우가 늘었는데 이에 유연하게 대처하기 어렵다.
- 일단 만들고 본 protocol들
  - 지나친 범용성을 추구하다보니 프로토콜을 과하게 많이 생성하여 사용했었다. 시간이 지나고 보면 난해한 코드도 많았고 무조건 범용성만 높인다고 좋은 코드가 되는 것이 아니라고 생각하게 되어 이 부분도 해결하는 시간을 가졌다.
- 컴플리션의 컴플리션의 컴플리션...
  - 비동기 처리 방법을 다양하게 알고있지 못하였기에 생긴 문제들이 종종 있었다.



### 해결한 방법

- 화면에 따른 폴더 분리를 진행한 뒤, 해당 화면이 사용하는 API관리 객체를 각 화면마다 만들어주었다.

  - 각 api콜마다 필요한 인자가 다르므로 모든걸 하나의 객체가 관리하기 보단 화면별로 이를 분리하였고 코드가 이전보다 훨씬 이해하기 쉬워졌다.

- dispatch group을 활용해 컴플리션 피라미드를 최대한 줄여보았다.

- 각 화면마다 viewModel을 만들어 난잡하게 적혀있는 뷰 생성 코드와 로직들을 분리시켜주었다.