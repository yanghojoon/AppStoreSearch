# 🏬 프로젝트 개요 
[iTunes API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1)를 활용해 앱스토어 검색 및 검색 결과 / 상세 앱 정보를 보여줍니다. 

## 🗂 파일 디렉토리 구조
```
├── AppStoreClone
│   ├── App
│   ├── Presentation
│   │   ├── AppList
│   │   │   ├── View
│   │   │   └── ViewModel
│   │   ├── AppDetail
│   │   │   ├── View
│   │   │   └── ViewModel
│   ├── Network
│   ├── Model
│   ├── Protocol
│   ├── Utiltiy
│   ├── Extension
│   └── Resource
└── AppStoreCloneTests
    └──Mock
```

## 사용한 오픈소스 / 프로젝트 정보
- iOS Deployment Target : 따로 기준은 없었으나 현재 대부분의 앱이 iOS 13.0 이상으로 타겟을 잡고 있어 `iOS 13.0`으로 설정
- `RxSwift` / `RxCocoa` : 비동기 처리를 return 값으로 처리하여 코드의 Depth를 줄이기 위해 사용

# 😃 추가 기능 및 UI
- URL을 통한 스크린샷 구현
    - `orthogonalScrollingBehavior`를 통해 `Pagination`을 구현했습니다.  
- 받기 버튼은 구현하지 못했으나 이를 대체하여 가격 버튼(User Interaction은 안됨)을 추가 
- App의 Description에서 더보기 버튼 구현 
    - 실제 앱스토어에서 더보기 버튼을 누르면 전체 Description을 볼 수 있고 다시 줄이는 버튼은 존재하지 않아 이와 동일하게 구현했습니다.
- 공유 버튼을 누르면 `ActivitiyView`를 통해 App의 `trackViewUrl`을 전송할 수 있도록 했습니다. 
- ActivityIndicator를 통해 앱의 List를 불러오고 있음을 보여줍니다.

# [Feature - 1] 아이튠즈 API를 통해 네트워크 통신을 하여 앱 리스트를 띄워줍니다.
## 기능 요약
아이튠즈 API를 Get을 통해 받아와 필요한 정보를 List에 띄워줍니다.
앱 설치의 경우 따로 진행하지 않고 현재 앱의 가격을 표시하도록 구현했습니다. 

## 작업 내용
### 1. 네트워크 구현 및 API 추상화
현재는 Get 메서드만 사용해서 기능 구현을 할 수 있지만 추후 POST, PUT, DELETE 같은 작업이 추가될 수 있기 때문에 `APIProtocol`을 따로 두었습니다. 이를 통해 새로운 기능의 API가 추가되더라도 해당 프로토콜을 채택하면 되도록 했습니다. 
또한 MockURLSession을 통한 테스트를 위해 URLSession도 `URLSessionProtocol`로 추상화하여 항상 동일한 결과가 나오는 `dataTask` 메서드를 구현할 수 있도록 했습니다. 

네트워크에서 Data를 fetch하는 메서드의 경우 Rx를 통해 비동기 코드를 처리할 수 있도록 했습니다. 기존 completionHandler를 통해서도 처리가 가능하나 코드의 Depth가 깊어질 수 있어, 반환 타입으로 비동기로 처리할 데이터를 넘겨주는 Rx를 사용했습니다.

### 2. CollectionView를 통한 앱 리스트 구현
리스트 형태인 만큼 TableView를 사용할 수 있었으나, CollectionView가 더욱 다양한 형태로 Cell을 커스텀할 수 있었기 때문에 CollectionView를 사용했습니다. 
CollectionView를 구현할 때에는 DiffableDataSource와 Compositional Layout을 사용했습니다. 현재 많은 앱들이 최소 Deployment를 iOS 13.0 이상으로 잡고 있는데 DiffableDataSource와 Compositional Layout 모두 iOS 13.0 이후로 사용이 가능하고, 검색 시 애니메이션이 적용되어 UX 경험을 향상시킬 수 있다는 점에서 해당 기술을 사용했습니다. 

### 3. 검색 시 화면 상단으로 이동하도록 구현
기존에는 검색을 하더라도 현재 보고 있는 indexPath의 row가 유지됐습니다. 하지만 새롭게 검색을 할 경우 대부분의 사용자들이 처음에 있는 리스트부터 확인하고 싶을 것이라 판단했고, 검색을 하면 화면 상단으로 이동할 수 있도록 구현했습니다. 

구현의 경우 collectionView의 contentOffset을 수정하는 방식으로 했습니다. 
```swift
self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
```

### 4. 리스트의 Paging 기능 구현
검색 `limit`만큼 검색결과가 온 경우 리스트를 추가적으로 불러올 수 있도록 구현했습니다. 
API 상에서 page를 처리해줄 수 있는 로직이 존재하지 않아, 현재 검색 `limit`인 `40개`만큼 검색 결과가 나온 경우 `리스트의 마지막 앱 이름`을 기준으로 다시 검색을 하여 List를 추가로 불러올 수 있도록 했습니다. 

`리스트의 마지막 앱 이름`을 통해 결과를 요청하는 경우 이미 불러온 앱을 다시 보여주는 경우가 있었습니다. 이 때 `DiffableDataSource`로 들어가는 값은 항상 `Hashable`해야 하기 때문에 리스트가 깨지는 문제가 발생했고, 이를 해결하기 위해 `HashableApp`이라는 타입을 추가로 두고 unique한 값인 `UUID`를 가지고 있도록 했습니다.

또한 `리스트의 마지막 앱 이름`을 기준으로 검색을 하는 것이기 때문에 List에 연속으로 동일한 앱이 나타나는 문제가 있어 추가로 리스트를 불러오는 경우 App 배열의 처음 요소는 지우고 View로 보내주는 방식을 선택했습니다. 


## 테스트 방법
### 1. JSONParser 테스트
JSON 데이터를 잘 decoding하는 지 확인하기 위해 `JSONParserTests`를 만들었습니다.
해당 UnitTest를 통해 API 예시로 MockSearchResult를 두고 이를 잘 decoding하는지 테스트할 수 있습니다. 

### 2. MockURLSession을 통한 테스트
MockURLSession의 경우 네트워크 연결 상태와 무방하게 테스트를 진행할 수 있어 `MockURLSession`을 통한 테스트도 만들었습니다.
현재는 Get만 하기 때문에 크게 상관은 없으나 Post / Put / Delete 같은 요청을 한다면 서버의 데이터를 불필요하게 수정하기 때문에 해당 테스트가 필요하다 판단했습니다. 
이를 통해 `NetworkProvider`의 `fetchData` 메서드를 테스트할 수 있습니다. 

## 화면 동작 예시
<img src="https://user-images.githubusercontent.com/90880660/171981806-d5cfab5f-439e-4e1c-972c-9787788a4f38.gif" width=250>

# [Feature - 2] 셀을 누르면 앱에 대한 상세화면이 나옵니다.
## 기능 요약
List에서 Cell을 선택하는 경우 해당 App에 대한 정보를 띄워줍니다. 
공유 버튼을 누를 경우 `Activity View`를 통해 앱의 링크 공유도 가능합니다. 

## 작업 내용
### 1. Flow Coordinator를 통한 의존성 관리
화면을 띄우는 역할을 Coordinator가 담당하도록 하고 여기서 생성자 주입을 통해 의존성을 관리해주었습니다. 
따라서 View와 ViewModel이 의존하지 않도록 했습니다. 화면을 띄우는 것은 Action 타입(`AppListViewAction`)을 따로 두어 FlowCoordinator에서 해당 Action을 주입하도록 했습니다. 

### 2. 전체적인 화면 구성 
전체를 담는 `ScrollView`에 `StackView`를 올려 각 항목들을 넣어줄 수 있도록 했습니다. 
크게 구분한 화면은 다음과 같습니다. 
- **TitleStackView**: 앱의 아이콘, 이름, 회사, 가격, 공유 버튼이 올라갑니다. 
- **SummaryScrollView**: 앱의 평가, 연령, 개발자, 카테고리, 언어를 간단하게 표현하기 위한 View입니다. 
    - SummaryScrollView의 경우 CollectionView와 고민했으나, 같은 위치에 서로 다른 데이터를 추가해줘야 했고 따라서 Scroll이 되는 StackView로 구현했습니다. 
- **screenshotCollectionView**: 앱의 스크린샷이 들어가는 View입니다. 
    - 해당 CollectionView의 경우 사용자가 사용하며 데이터가 변하는 일이 없기 때문에, `DiffableDataSource`를 적용하지 않았습니다. 다만 Pagination을 `orthogonalScrollingBehavior`를 통해 구현해주기 위해 `Compositional Layout`을 사용했습니다. 
- **descriptionTextView**: 앱의 설명이 들어가는 View입니다. 
    - 설명의 경우 2줄(띄어쓰기 포함)까지만 보이고 추가적으로 설명을 더 보고 싶은 경우 `더보기`를 누를 수 있도록 했습니다. 
    - `더보기`의 경우 누르면 사라지며 다시 설명을 줄일 수는 없습니다. (앱스토어의 구현이 이렇게 되어 있음)

화면 구분선의 경우 UIView를 통해 추가해줬습니다. 

### 3. ActivityIndicator, ActivityView 추가 
명세에는 나와있지 않았지만 사용자가 검색 버튼을 누르고 리스트를 불러올 때 `ActivityIndicator`가 돌아가도록 구현했습니다. 
또한 공유 버튼을 누르는 경우 `ActivityView`를 통해 `trackViewUrl`을 전송할 수 있도록 구현했습니다. 

## 화면 동작 예시
<img src="https://user-images.githubusercontent.com/90880660/172093982-936711a9-0818-457e-907e-3e55b0a10043.gif" width=300>
