//
//  AuthServices.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 07.03.2021.
//

import Alamofire
import Foundation
import GoogleSignIn
import AppAuth

final class AuthServices {
  private struct LogInResponse: Decodable {
    struct DataResponse: Decodable {
      let token: String
    }
    let data: DataResponse
  }
  
  private struct LogInCabinetResponse: Decodable {
    let email: String
//    let student_usertype_name: String
  }
  
  private struct StatusResponse: Decodable {
    struct UserInfo: Decodable {
      let isTeacher: Bool
    }
    let data: UserInfo
  }

  
  
  private struct UserInfoResponse: Decodable {
    let error: String
  }
  
  private let session = makeDefaultSession()
  private var token: Property<String>
  private var user: Property<User>
  
  init(
    token: Property<String>,
    user: Property<User>
  ) {
    self.token = token
    self.user = user
  }
  
  func logIn(authCode: String, completion: @escaping (Bool) -> Void) {
    let headers: HTTPHeaders = ["User-Agent": "Miem App"]
    
    let parameters = ["authCode": authCode]
    session.request("https://cabinet.miem.hse.ru/vue/google", method: .post, parameters: parameters, encoding: JSONEncodingWithoutEscapingSlashes.default, headers: headers).response { response in
      guard let data = response.data,
        let parsedResponse = try? JSONDecoder().decode(LogInResponse.self, from: data),
        !parsedResponse.data.token.isEmpty else {
        completion(false)
        return
      }
      debugPrint(response)
      let encodedTokenData = parsedResponse.data.token.components(separatedBy: ".")
      guard encodedTokenData.count > 1,
        let userInfo = Data(base64Encoded: base64urlToBase64(base64url: encodedTokenData[1])),
        let user = try? JSONDecoder().decode(User.self, from: userInfo) else {
        completion(false)
        return
      }
      self.token.value = parsedResponse.data.token
      self.user.value = user
      
//      self.logInCameras()
      completion(true)
    }
  }
  
  func logInCabinet(_ vc: UIViewController, completion: @escaping (Bool) -> Void) {
    let authorizationEndpoint = URL(string: "https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/auth")!
    let tokenEndpoint = URL(string: "https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/token")!
    let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,
    tokenEndpoint: tokenEndpoint)
    
    let clientID = "miem-ios-app-616"
    let clientSecret = "7531ce00-38ec-477a-aefd-cd3434b87e7a"
    let redirectURI = URL(string: "ru.miem.miemapp://ouath2redirect/*")!
    
    let request = OIDAuthorizationRequest(configuration: configuration, clientId: clientID, clientSecret: clientSecret, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
    
    // performs authentication request
    print("Initiating authorization request with scope: \(request.scope ?? "nil")")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: vc) { authState, error in
             if let authState = authState {
               appDelegate.setAuthState(authState)
           print("Got authorization tokens. Access token: " +
                 "\(authState.lastTokenResponse?.accessToken ?? "nil")")
              self.token.value = (authState.lastTokenResponse?.accessToken! ?? "")
              let token_header = "Bearer " + self.token.value
              let header: HTTPHeaders = ["Authorization": token_header]
              self.session.request("https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/userinfo", method: .get, encoding: JSONEncodingWithoutEscapingSlashes.default, headers: header).response { response in
                print("cabinet response")
                debugPrint(response)
                
                
                guard let data = response.data,
                  let parsedResponse = try? JSONDecoder().decode(LogInCabinetResponse.self, from: data) else {
              completion(false)
                  return
                }
//                print("authState=\(authState.debugDescription)")
//                self.token.value = (authState.lastTokenResponse?.accessToken)!
//                print("token=\(self.token.value)")
                let student = self.getStatus(token: self.token.value, email: parsedResponse.email)
                let user = User(email: parsedResponse.email, student: student)
                self.user.value = user
                
//                self.logInCameras()
                completion(true)
                
                
              }
              
         } else {
           print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
           appDelegate.setAuthState(nil)
          completion(false)
         }
      
      
       }
  }

  private func getStatus(token: String, email: String) -> Bool{
//    api личного кабинета не принимает токен от авторизации через лк
    var isStudent: Bool
    isStudent = true
    let url = "https://devcabinet.miem.vmnet.top/public-api/user/email/" + email
    session.request(url, method: .get).response { response in
      debugPrint(response)
      guard let data = response.data, let parsedResponse = try? JSONDecoder().decode(StatusResponse.self, from: data) else {
        print("error in getStatus")
        return
      }
      if parsedResponse.data.isTeacher {
        isStudent = false
      } else {
        isStudent = true
      }
    }
    return isStudent
  }

//  private func logInCameras() {
//    let headers: HTTPHeaders = ["key": token.value]
//    session.request("http://19111.miem.vmnet.top/login_token", method: .get, headers: headers).response {
//      Logger.shared.log($0.debugDescription)
//      debugPrint($0)
//    }
//
//  }
  
  func logOut() {
    let headers: HTTPHeaders = ["x-auth-token": token.value]
    session.request("https://cabinet.miem.hse.ru/logout", method: .post, headers: headers).response {
      Logger.shared.log($0.debugDescription)
      debugPrint($0)
    }
    token.value = ""
    GIDSignIn.sharedInstance().signOut()
    
//    let authorizationEndpoint = URL(string: "https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/auth")!
//    let tokenEndpoint = URL(string: "https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/logout")!
//    let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,
//    tokenEndpoint: tokenEndpoint)
//
//    let clientID = "miem-ios-app-616"
//    let clientSecret = "7531ce00-38ec-477a-aefd-cd3434b87e7a"
//    let redirectURI = URL(string: "ru.miem.miemapp://ouath2redirect/*")!
//
//    let request = OIDAuthorizationRequest(configuration: configuration, clientId: clientID, clientSecret: clientSecret, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
//
//    let logOutUrl = "https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/logout"

    print("debugLOgout")
    session.request("https://profile.miem.hse.ru/auth/realms/MIEM/protocol/openid-connect/logout", method: .get).response {
      debugPrint($0)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.currentAuthorizationFlow = nil
    appDelegate.setAuthState(nil)
  }
  
  

}

public struct JSONEncodingWithoutEscapingSlashes: ParameterEncoding {
  public static var `default`: JSONEncodingWithoutEscapingSlashes { return JSONEncodingWithoutEscapingSlashes() }
  public static var prettyPrinted: JSONEncodingWithoutEscapingSlashes { return JSONEncodingWithoutEscapingSlashes(options: .prettyPrinted) }

  public let options: JSONSerialization.WritingOptions

  public init(options: JSONSerialization.WritingOptions = []) {
      self.options = options
  }

  public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
      var urlRequest = try urlRequest.asURLRequest()
      guard let parameters = parameters else { return urlRequest }
      do {
        let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)?.replacingOccurrences(of: "\\/", with: "/")
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
          urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.httpBody = string!.data(using: .utf8)
      } catch {
        throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
      }
      return urlRequest
  }

  public func encode(_ urlRequest: URLRequestConvertible, withJSONObject jsonObject: Any? = nil) throws -> URLRequest {
    var urlRequest = try urlRequest.asURLRequest()
    guard let jsonObject = jsonObject else { return urlRequest }
    do {
      let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
      let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)?.replacingOccurrences(of: "\\/", with: "/")
      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
      urlRequest.httpBody = string!.data(using: .utf8)
    } catch {
      throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
    }
    return urlRequest
  }
}

private func base64urlToBase64(base64url: String) -> String {
  var base64 = base64url
    .replacingOccurrences(of: "-", with: "+")
    .replacingOccurrences(of: "_", with: "/")
  if base64.count % 4 != 0 {
    base64.append(String(repeating: "=", count: 4 - base64.count % 4))
  }
  return base64
}
