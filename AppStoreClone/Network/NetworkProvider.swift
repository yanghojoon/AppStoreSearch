import Foundation
import RxSwift

struct NetworkProvider {
    
    // MARK: - Properties
    private let session: URLSession
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Methods
    func fetchData<T: Codable>(api: APIProtocol, decodingType: T.Type) -> Observable<T> {
        return Observable.create { emitter in
            guard let task = dataTask(api: api, emitter: emitter) else {
                return Disposables.create()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func dataTask<T: Codable>(api: APIProtocol, emitter: AnyObserver<T>) -> URLSessionDataTask? {
        guard let urlRequest = URLRequest(api: api) else {
            emitter.onError(NetworkError.urlIsNil)
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200..<300
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                emitter.onError(NetworkError.statusCodeError)
                return
            }
            
            if let data = data {
                guard let decodedData = JSONParser<T>().decode(from: data) else {
                    emitter.onError(JSONParserError.decodingFail)
                    return
                }
                
                emitter.onNext(decodedData)
            }
        }
        emitter.onCompleted()
        
        return task
    }
    
}

// MARK: - Error
extension NetworkProvider {
    
    private enum NetworkError: Error, LocalizedError {
        
        case statusCodeError
        case unknownError
        case urlIsNil
        
        var errorDescription: String? {
            switch self {
            case .statusCodeError:
                return "정상적인 StatusCode가 아닙니다."
            case .unknownError:
                return "알수 없는 에러가 발생했습니다."
            case .urlIsNil:
                return "정상적인 URL이 아닙니다."
            }
        }
        
    }
    
}
