# AI 챗봇 앱 README

## 팀원 :busts_in_silhouette: 
| 프로필 사진 | <a href="https://github.com/shlim0"><img src="https://avatars.githubusercontent.com/u/46235301?v=4" width=90></a> | <a href="https://github.com/shlim0"><img src="https://avatars.githubusercontent.com/u/99116619?v=4" width=90></a> |
| ---- | ---------- | --------- | 
| in Github | [@JJong](https://github.com/shlim0) | [@Remaked-Swain](https://github.com/Remaked-Swain)
| in SeSAC | 쫑 | 스웨인

---

## 프로젝트 구조
### Network Layer
- `ChattingRoomViewController` 내부에서 `NetworkRequestBuilder`를 통해 URL 통신에 대한 정보를 build 한 뒤, `NetworkManager`를 통해 URL 통신을 한다.
![image](https://hackmd.io/_uploads/Bkt-rVzqp.png)
### Modern Cell Configuration - Custom Configuration
- [Modern Cell Configuraion](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)을 참고하여 Custom Configuration 하였음.
    - `ChattingRoomViewController`
![Untitled](https://hackmd.io/_uploads/ByGUrVG5a.png)
### ChattingRoomListView with CoreData
- `CoreData`를 활용해, `ChattingRoomEntity`와 `MessageEntity`를 만들어 기기에 데이터를 저장한다. 앱이 실행중일 때는, `ChattingRoomModel`로 데이터를 받아오고, 앱을 종료할 때는 `ChattingRoomModel`에 있는 데이터를 `ChattingRoomEntity`에 저장한다.
![image](https://hackmd.io/_uploads/rkO6v4zcp.png)

-------------
## 사용 경험
- [x] Request 및 Response를 위한 데이터 모델 설명
- [x] CodingKeys 프로토콜의 활용
- [x] Swift Concurrency: URL Session을 활용한 서버와의 통신
    - [x] `async`, `await`을 활용한 비동기 처리
- [x] Builder pattern 활용
- [x] Safe Area을 고려한 오토레이아웃 구현
- [x] `UICollectionView`
- [x] `DiffableDataSource`
- [x] `UICollectionViewCompositionalLayout`
- [x] Modern Cell Configuration
    - [x] `ChattingRoomListViewController` - `defaultContentConfiguration()`
    - [x] `ChattingRoomViewController` - CustomConfiguration으로 구현
- [x] cell의 재사용
- [x] Core Animation: `CALayer`, `CAReplicatorLayer` - 로딩 표시
- [x] `UIBezierPath`, `CAShapeLayer` - 말풍선 표시
- [x] `CoreData`를 활용한 데이터 저장 및 불러오기
- [x] Date 타입의 이해
- [x] `UINavigationController`를 이용한 화면 전환
- [x] protocol oriented programming

------------

## 실행 화면 스크린샷
- 아이폰 15 Pro

| 메인 화면 | 새로운 채팅방 | 채팅방 저장 |
|:-------:|:-------:|:-------:|
| ![image](https://hackmd.io/_uploads/SyyMgVf9p.png) | ![image](https://hackmd.io/_uploads/r1QEkVz56.png) | ![Simulator Screen Recording - iPhone 15 Pro - 2024-01-27 at 17 29 27](https://github.com/Remaked-Swain/ios-chat-bot/assets/46235301/933c2670-0e22-4156-afd9-607ead722eb0) |

| 채팅 화면 | 긴 채팅 | 동적 입력창 |
|:-------:|:-------:|:-------:|
| <img src="https://github.com/tasty-code/ios-chat-bot/assets/46235301/2cdae929-1ea2-4746-908b-4d86f2fb5da9" alt="chat" width="295px" height="640px"> |  ![2  long story](https://github.com/tasty-code/ios-chat-bot/assets/46235301/bd68cc95-0d2f-45db-8c2c-e4a9dcd83967) |  ![3  keyboard and dynamic text view](https://github.com/tasty-code/ios-chat-bot/assets/46235301/8307a587-0b50-4d40-87ad-8f7a87d9c57d) |

| 사용자 입력시 화면이 이동 | 에러 발생 후 채팅 재요청 |
|:-------:|:-------:|
|  ![4  push blue message](https://github.com/tasty-code/ios-chat-bot/assets/46235301/12c1b3b9-f12d-47e8-9bbf-b221dad68b42) |  ![5  error but still execution](https://github.com/tasty-code/ios-chat-bot/assets/46235301/cf4b6ade-ecd6-40e4-9230-7048b3b46b9c) |

| Network Error | Server-side Error | Unknown Error |
|:-------:|:-------:|:-------:|
|  ![network error](https://github.com/tasty-code/ios-chat-bot/assets/46235301/e42c9e71-4554-4958-a697-2c0c8b941311) |  ![server error](https://github.com/tasty-code/ios-chat-bot/assets/46235301/619de5d8-d905-4332-92f4-95c6e2bcd33d) |  ![unknown error](https://github.com/tasty-code/ios-chat-bot/assets/46235301/f8d1d12e-ca4d-4ce8-85ea-fd9efcb55178) |


- 아이패드 6세대 Pro (12.9)
![아이패두](https://github.com/tasty-code/ios-chat-bot/assets/46235301/36839f27-d72e-4f8a-b119-5e29f59333af)

-----------------

## Trouble SHOOTING
- **말풍선과 로딩 인디케이터, 그리고 텍스트의 위치 조정**
    텍스트나 로딩 인디케이터가 말풍선 배경 영역 밖으로 삐져나오는 문제가 존재했다.

|출발지|도착지|비고|
|:-|:-|:-|
|`BubbleLabel`|`MessageContentView`|Text와 Loading Indicator를 말풍선 배경과 Padding을 주기 위한 LayoutMarginsGuide로 제약 설정|
|`MessageContentView`|`MessageView`|배경 Padding이 확보된 말풍선을 그릴 수 있도록 LayoutMarginsGuide에 제약 설정|
|`MessageView`|`MessageCellContentView`|List CollectionView Layout의 좌, 우측 정렬을 잡아주도록 제약 설정|
|`MessageCellContentView`|`MessageCell`|Cell Configuration과 Modern Cell Auto-sizing|

> 뷰 계층구조를 위와 같이 설정한 덕분에, 상위 뷰에서는 하위 뷰를 온전히 '뷰'로만 바라볼 수 있도록 하고 자잘한 세팅은 메세징을 통해 구성할 수 있게 되었다.
> 또한 각 단계에서 필요한 Auto Layout을 통해 UICollectionView의 Self-sizing을 지원하면서도, 정렬이 맞지 않는다거나 말풍선 배경의 경계를 넘어 삐져나오는 텍스트, 로딩 인디케이터의 위치를 정확히 맞추고 말풍선 배경의 적절한 크기를 CGRect 계산 없이 자동으로 계산되게 할 수 있었다.

- **NSLayoutConstraints Engine 부하**
    동일하거나 반복적으로 Auto Layout 제약사항을 다시 계산하는 것은 엔진 모듈에 부하를 주어 성능 상 좋지 않다.
```swift
NSLayoutConstraint.activate([
    messageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
    messageView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
    messageView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: labelWidthRatio)
])

if appliedConfiguration.role == .user {
    leadingConstraint?.isActive = false
    trailingConstraint?.isActive = true
} else {
    leadingConstraint?.isActive = true
    trailingConstraint?.isActive = false
}
```

> Content Configuration을 통해 받아온 Role 값을 가지고 좌측, 또는 우측 정렬을 선택적으로 수행해야 할 때, 기존 제약사항을 부수고 다시 계산하는 것이 아니라 단순히 껐다 켜는 것으로 엔진 부하를 줄일 수 있었다.

- **On-Disk 작업 최소화**
CoreData Framework는 Data에 대한 Persistance를 지원하는 기능을 가지고 있다. 그러나 값을 다루는 것은 결국 In-Memory에서 수행해야 하므로 Disk-Memory 교환이 잦으면 그만큼 비용이 증가하게 된다.
> 우리는 메세지가 누적될 때마다 CoreData에 저장을 요청하는 것이 아닌, 채팅방에서 나갈 때 누적되어있던 메세지를 일괄적으로 저장하게하여 Disk-Memory 접근을 한 번만 수행하게 하는 것으로 이를 해결했다. 또한, `NSPredicate`를 이용하여 Disk-Memory 작업 범위를 줄였다.

## PR
[STEP 1](https://github.com/tasty-code/ios-chat-bot/pull/2)

[STEP 2](https://github.com/tasty-code/ios-chat-bot/pull/16)

[STEP 3](https://github.com/tasty-code/ios-chat-bot/pull/21)

STEP 4 - 구현했으나 시간상 제출하지 못함
