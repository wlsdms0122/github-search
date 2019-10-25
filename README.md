# Github Search
[**Github API**](https://developer.github.com/v3/)를 활용하여 사용자의 정보를 검색할 수 있는 어플리케이션입니다.

# Feature
`Code-base`로 layout을 구현하였으며, 사용된 라이브러리는 다음과 같습니다.

- RxSwift / RxCocoa
- RxDataSources
- ReactorKit
- SnapKit
- Alamofire
- Kingfisher

# Installation
의존성 관리 도구로 [**Carthage**](https://github.com/Carthage/Carthage?source=post_page-----127e71fdd253----------------------)를 사용하였습니다.

`carthage update` 시 [**ReactorKit**](https://github.com/ReactorKit/ReactorKit)에서 오류가 발생함으로 해당 `Repository`에서 설치 섹션을 확인 해주시길 바랍니다.

`Github API` 사용을 위한 `Token`값은 아래의 `HTTPHeaders`에 추가해주시면 됩니다.
```swift
// NetworkService.swift
114: enum GithubApi: ApiType {
       ...
145:   var headers: HTTPHeaders? {
146:     return ["Content-Type": "application/json",
147:             "Accept": "application/json"]
                 // "Authorization": "token `your github api token`"
148:   }
149:
150:   
151: }

```
