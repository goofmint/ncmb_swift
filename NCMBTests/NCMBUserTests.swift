/*
 Copyright 2019 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


import XCTest
@testable import NCMB

/// NCMBUser のテストクラスです。
final class NCMBUserTests: NCMBTestCase {

    func test_isIgnoredKey() {
        let sut : NCMBUser = NCMBUser()
        sut["takanokun"] = 42
        XCTAssertTrue(sut.isIgnoredKey(field: "objectId"))
        XCTAssertTrue(sut.isIgnoredKey(field: "acl"))
        XCTAssertTrue(sut.isIgnoredKey(field: "createDate"))
        XCTAssertTrue(sut.isIgnoredKey(field: "updateDate"))
        XCTAssertFalse(sut.isIgnoredKey(field: "userName"))
        XCTAssertFalse(sut.isIgnoredKey(field: "password"))
        XCTAssertFalse(sut.isIgnoredKey(field: "mailAddress"))
        XCTAssertFalse(sut.isIgnoredKey(field: "authData"))
        XCTAssertFalse(sut.isIgnoredKey(field: "sessionToken"))
        XCTAssertFalse(sut.isIgnoredKey(field: "mailAddressConfirm"))
        XCTAssertFalse(sut.isIgnoredKey(field: "temporaryPassword"))
        XCTAssertFalse(sut.isIgnoredKey(field: "takanokun"))
    }

    func test_isIgnoredKey_setFieldValue() {
        let sut : NCMBUser = NCMBUser()
        sut["objectId"] = "abc"
        sut["acl"] = NCMBACL.default
        sut["createDate"] = "def"
        sut["updateDate"] = "ghi"
        sut["userName"] = "jkl"
        sut["password"] = "mno"
        sut["mailAddress"] = "pqr"
        sut["authData"] = "stu"
        sut["sessionToken"] = "vwx"
        sut["mailAddressConfirm"] = "yza"
        sut["temporaryPassword"] = "bcd"
        sut["takanokun"] = "efg"
        XCTAssertNil(sut["objectId"])
        XCTAssertNil(sut["acl"])
        XCTAssertNil(sut["createDate"])
        XCTAssertNil(sut["updateDate"])
        XCTAssertEqual(sut["userName"], "jkl")
        XCTAssertEqual(sut["password"], "mno")
        XCTAssertEqual(sut["mailAddress"], "pqr")
        XCTAssertEqual(sut["authData"], "stu")
        XCTAssertEqual(sut["sessionToken"], "vwx")
        XCTAssertEqual(sut["mailAddressConfirm"], "yza")
        XCTAssertEqual(sut["temporaryPassword"], "bcd")
        XCTAssertEqual(sut["takanokun"], "efg")
    }

    func test_copy() {
        let sut : NCMBUser = NCMBUser()
        sut.userName = "takano_san"
        sut.password = "pswdpswd"

        let user = sut
        let user2 = sut.copy

        sut.userName = "takanokun"
        XCTAssertEqual(user.userName, "takanokun")
        XCTAssertEqual(user2.userName, "takano_san")
    }

    func test_currentUserSessionToken() {
        XCTAssertNil(NCMBUser.currentUserSessionToken)

        let user : NCMBUser = NCMBUser()
        user["sessionToken"] = "takanokun"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUserSessionToken, "takanokun")
    }

    func test_sessionToken() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertNil(sut.sessionToken)
        sut["sessionToken"] = "takanokun"
        XCTAssertEqual(sut.sessionToken, "takanokun")
    }

    func test_userName() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertNil(sut.userName)
        sut.userName = "takanokun"
        XCTAssertEqual(sut.userName, "takanokun")
    }

    func test_password() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertNil(sut.password)
        sut.password = "takanokun"
        XCTAssertEqual(sut.password, "takanokun")
    }

    func test_mailAddress() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertNil(sut.mailAddress)
        sut.mailAddress = "takanokun"
        XCTAssertEqual(sut.mailAddress, "takanokun")
    }

    func test_authData_default() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertNil(sut.authData)
    }

    func test_authData_field_not_dictionary() {
        let sut : NCMBUser = NCMBUser()
        sut["authData"] = "takanokun"
        XCTAssertNil(sut.authData)
    }

    func test_authData_field_dictionary() {
        let sut : NCMBUser = NCMBUser()
        let authData : [String : Any] = ["takanokun" : 42]
        sut["authData"] = authData
        XCTAssertNotNil(sut.authData)
        XCTAssertEqual(sut.authData!.count, 1)
        XCTAssertEqual(sut.authData!["takanokun"]! as! Int, 42)
    }

    func test_currentUser_noLocalFile_noMemory() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)
        NCMBUser._currentUser = nil
        XCTAssertNil(NCMBUser.currentUser)
    }

    func test_currentUser_LocalFile_noMemory() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)
        NCMBUser._currentUser = nil
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takanokun")
        XCTAssertEqual(NCMBUser.currentUser!.password, "abcdefgh")
    }

    func test_currentUser_LocalFile_Memory() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)
        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")
    }

    func test_isAuthenticated() {
        let sut : NCMBUser = NCMBUser()
        XCTAssertFalse(sut.isAuthenticated)
        sut["sessionToken"] = "takanokun"
        XCTAssertTrue(sut.isAuthenticated)
    }

    func test_automaticCurrentUser_noCurrentUser_success() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // NCMBUser._currentUser = nil

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let result : NCMBResult<NCMBUser> = NCMBUser.automaticCurrentUser()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        let user : NCMBUser = NCMBTestUtil.getResponse(result: result)!
        XCTAssertEqual(user.objectId, "aTAe6VXd3ZElDtlG")
        XCTAssertEqual(user.userName, "ljmuJgf4ri")
        XCTAssertEqual(user["createDate"], "2013-08-16T11:49:44.991Z")
        XCTAssertEqual(user.sessionToken, "esMM7OVu4PlK5spYNLLrR15io")
        let currentUser = NCMBUser.currentUser
        XCTAssertEqual(currentUser!.objectId, "aTAe6VXd3ZElDtlG")
        XCTAssertEqual(currentUser!.userName, "ljmuJgf4ri")
        XCTAssertEqual(currentUser!["createDate"], "2013-08-16T11:49:44.991Z")
        XCTAssertEqual(currentUser!.sessionToken, "esMM7OVu4PlK5spYNLLrR15io")
    }

    func test_automaticCurrentUser_noCurrentUser_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let result : NCMBResult<NCMBUser> = NCMBUser.automaticCurrentUser()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
        XCTAssertNil(NCMBUser.currentUser)
    }

    func test_automaticCurrentUser_noCurrentUser_failure_automaticUserNotAvailable() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可しない
        NCMBUser.disableAutomaticUser()

        let result : NCMBResult<NCMBUser> = NCMBUser.automaticCurrentUser()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! NCMBUserError, NCMBUserError.automaticUserNotAvailable)
        XCTAssertNil(NCMBUser.currentUser)
    }

    func test_automaticCurrentUser_currentUser() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // カレントユーザーが存在する場合
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertEqual(NCMBUser.currentUser!.userName, "takanokun")

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let result : NCMBResult<NCMBUser> = NCMBUser.automaticCurrentUser()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        let user : NCMBUser = NCMBTestUtil.getResponse(result: result)!
        XCTAssertEqual(user.userName, "takanokun")
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takanokun")
    }

    func test_automaticCurrentUserInBackground_noCurrentUser_success() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let expectation : XCTestExpectation? = self.expectation(description: "test_automaticCurrentUserInBackground_noCurrentUser_success")
        NCMBUser.automaticCurrentUserInBackground(callback: { (result: NCMBResult<NCMBUser>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            let user : NCMBUser = NCMBTestUtil.getResponse(result: result)!
            XCTAssertEqual(user.objectId, "aTAe6VXd3ZElDtlG")
            XCTAssertEqual(user.userName, "ljmuJgf4ri")
            XCTAssertEqual(user["createDate"], "2013-08-16T11:49:44.991Z")
            XCTAssertEqual(user.sessionToken, "esMM7OVu4PlK5spYNLLrR15io")
            let currentUser = NCMBUser.currentUser
            XCTAssertEqual(currentUser!.objectId, "aTAe6VXd3ZElDtlG")
            XCTAssertEqual(currentUser!.userName, "ljmuJgf4ri")
            XCTAssertEqual(currentUser!["createDate"], "2013-08-16T11:49:44.991Z")
            XCTAssertEqual(currentUser!.sessionToken, "esMM7OVu4PlK5spYNLLrR15io")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_automaticCurrentUserInBackground_noCurrentUser_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let expectation : XCTestExpectation? = self.expectation(description: "test_automaticCurrentUserInBackground_noCurrentUser_failure")
        NCMBUser.automaticCurrentUserInBackground(callback: { (result: NCMBResult<NCMBUser>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            XCTAssertNil(NCMBUser.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_automaticCurrentUserInBackground_noCurrentUser_failure_automaticUserNotAvailable() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // カレントユーザーが存在しない場合のため、ローカルファイルは無し
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        // 匿名ユーザーの使用を許可しない
        NCMBUser.disableAutomaticUser()

        let expectation : XCTestExpectation? = self.expectation(description: "test_automaticCurrentUserInBackground_noCurrentUser_failure_automaticUserNotAvailable")
        NCMBUser.automaticCurrentUserInBackground(callback: { (result: NCMBResult<NCMBUser>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! NCMBUserError, NCMBUserError.automaticUserNotAvailable)
            XCTAssertNil(NCMBUser.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_automaticCurrentUserInBackground_currentUser() {
        let body : Data? = "{\"createDate\":\"2013-08-16T11:49:44.991Z\",\"objectId\":\"aTAe6VXd3ZElDtlG\",\"userName\":\"ljmuJgf4ri\",\"authData\":{\"anonymous\":{\"id\":\"3dc72085-911b-4798-9707-d69e879a6185\"}},\"sessionToken\":\"esMM7OVu4PlK5spYNLLrR15io\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        // カレントユーザーが存在する場合
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertEqual(NCMBUser.currentUser!.userName, "takanokun")

        // 匿名ユーザーの使用を許可する
        NCMBUser.enableAutomaticUser()

        let expectation : XCTestExpectation? = self.expectation(description: "test_automaticCurrentUserInBackground_noCurrentUser_failure")
        NCMBUser.automaticCurrentUserInBackground(callback: { (result: NCMBResult<NCMBUser>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            let user : NCMBUser = NCMBTestUtil.getResponse(result: result)!
            XCTAssertEqual(user.userName, "takanokun")
            XCTAssertEqual(NCMBUser.currentUser!.userName, "takanokun")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUp_default_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        _ = sut.signUp()
        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].queryItems.count, 0)
        XCTAssertTrue(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"userName\":\"Yamada Tarou\""))
        XCTAssertTrue(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"password\":\"abcd1234\""))
    }

    func test_signUp_default_success() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let result : NCMBResult<Void> = sut.signUp()
        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertEqual(sut.objectId, "epaKcaYZqsREdSMY")
        XCTAssertEqual(sut["createDate"], "2013-08-28T11:27:16.446Z")
        XCTAssertEqual(sut.sessionToken, "iXDIelJRY3ULBdms281VTmc5O")
    }

    func test_signUp_default_success_saveData() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        _ = sut.signUp()
        XCTAssertEqual(manager.saveLog.count, 1)
        XCTAssertEqual(manager.saveLog[0].type, NCMBLocalFileType.currentUser)
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"userName\":\"Yamada Tarou\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"password\":\"abcd1234\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"objectId\":\"epaKcaYZqsREdSMY\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"sessionToken\":\"iXDIelJRY3ULBdms281VTmc5O\""))
    }

    func test_signUp_default_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let result : NCMBResult<Void> = sut.signUp()
        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
        XCTAssertEqual(sut.userName, "Yamada Tarou")
        XCTAssertEqual(sut.password, "abcd1234")
        XCTAssertNil(sut.objectId)
        XCTAssertNil(sut.sessionToken)
    }

    func test_signUpInBackground_default_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_request")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].queryItems.count, 0)
            XCTAssertTrue(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"userName\":\"Yamada Tarou\""))
            XCTAssertTrue(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"password\":\"abcd1234\""))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUpInBackground_default_success() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_success")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertEqual(sut.objectId, "epaKcaYZqsREdSMY")
            XCTAssertEqual(sut["createDate"], "2013-08-28T11:27:16.446Z")
            XCTAssertEqual(sut.sessionToken, "iXDIelJRY3ULBdms281VTmc5O")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUpInBackground_default_success_currentUser() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        XCTAssertNil(NCMBUser.currentUser)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_success")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            let currentUser = NCMBUser.currentUser
            XCTAssertEqual(currentUser!.objectId, "epaKcaYZqsREdSMY")
            XCTAssertEqual(currentUser!["createDate"], "2013-08-28T11:27:16.446Z")
            XCTAssertEqual(currentUser!.sessionToken, "iXDIelJRY3ULBdms281VTmc5O")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUpInBackground_default_success_saveData() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_success_saveData")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(manager.saveLog.count, 1)
            XCTAssertEqual(manager.saveLog[0].type, NCMBLocalFileType.currentUser)
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"userName\":\"Yamada Tarou\""))
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"password\":\"abcd1234\""))
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"objectId\":\"epaKcaYZqsREdSMY\""))
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"sessionToken\":\"iXDIelJRY3ULBdms281VTmc5O\""))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUpInBackground_default_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_failure")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            XCTAssertEqual(sut.userName, "Yamada Tarou")
            XCTAssertEqual(sut.password, "abcd1234")
            XCTAssertNil(sut.objectId)
            XCTAssertNil(sut.sessionToken)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_signUpInBackground_default_failure_currentUser() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        XCTAssertNil(NCMBUser.currentUser)

        let sut : NCMBUser = NCMBUser()
        sut.userName = "Yamada Tarou"
        sut.password = "abcd1234"

        let expectation : XCTestExpectation? = self.expectation(description: "test_signUpInBackground_default_failure")
        sut.signUpInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertNil(NCMBUser.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestAuthenticationMailInBackground_request() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestAuthenticationMailInBackground_request")
        NCMBUser.requestAuthenticationMailInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].queryItems.count, 0)
            XCTAssertEqual(executor.requests[0].body!, "{\"mailAddress\":\"sample@example.com\"}".data(using: .utf8))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestAuthenticationMailInBackground_success() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestAuthenticationMailInBackground_success")
        NCMBUser.requestAuthenticationMailInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestAuthenticationMailInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestAuthenticationMailInBackground_failure")
        NCMBUser.requestAuthenticationMailInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestAuthenticationMail_request() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        _ = NCMBUser.requestAuthenticationMail(mailAddress: "sample@example.com")
        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].queryItems.count, 0)
        XCTAssertEqual(executor.requests[0].body!, "{\"mailAddress\":\"sample@example.com\"}".data(using: .utf8))
    }

    func test_requestAuthenticationMail_success() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let result : NCMBResult<Void> = NCMBUser.requestAuthenticationMail(mailAddress: "sample@example.com")
        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
    }

    func test_requestAuthenticationMail_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let result : NCMBResult<Void> = NCMBUser.requestAuthenticationMail(mailAddress: "sample@example.com")
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
    }

    func test_logIn_userName_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        _ = NCMBUser.logIn(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234")

        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].queryItems.count, 2)
        XCTAssertEqual(executor.requests[0].queryItems["userName"], "Yamada Tarou")
        XCTAssertEqual(executor.requests[0].queryItems["password"], "abcd1234")
        XCTAssertNil(executor.requests[0].body)
    }

    func test_logIn_mailAddress_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        _ = NCMBUser.logIn(userName: nil, mailAddress: "sample@example.com", password: "abcd1234")

        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].queryItems.count, 2)
        XCTAssertEqual(executor.requests[0].queryItems["mailAddress"], "sample@example.com")
        XCTAssertEqual(executor.requests[0].queryItems["password"], "abcd1234")
        XCTAssertNil(executor.requests[0].body)
    }

    func test_logIn_success() {
        let body : Data? = "{\"objectId\":\"09Mp23m4bEOInUqT\",\"userName\":\"user01\",\"mailAddress\":null,\"mailAddressConfirm\":null,\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\",\"createDate\":\"2013-08-28T07:46:09.801Z\",\"updateDate\":\"2013-08-30T05:32:03.868Z\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        XCTAssertNil(NCMBUser.currentUser)

        let result : NCMBResult<Void> = NCMBUser.logIn(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234")

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertNotNil(NCMBUser.currentUser)
        XCTAssertEqual(NCMBUser.currentUser!.objectId, "09Mp23m4bEOInUqT")
        XCTAssertEqual(NCMBUser.currentUser!.sessionToken, "ebDH8TtmLoygzjqjaI4EWFfxc")
        XCTAssertEqual(NCMBUser.currentUser!.userName, "user01")
        XCTAssertNil(NCMBUser.currentUser!.password) // password not in response
    }

    func test_logIn_success_saveFile() {
        let body : Data? = "{\"objectId\":\"09Mp23m4bEOInUqT\",\"userName\":\"user01\",\"mailAddress\":null,\"mailAddressConfirm\":null,\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\",\"createDate\":\"2013-08-28T07:46:09.801Z\",\"updateDate\":\"2013-08-30T05:32:03.868Z\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        _ = NCMBUser.logIn(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234")

        XCTAssertEqual(manager.saveLog.count, 1)
        XCTAssertEqual(manager.saveLog[0].type, .currentUser)
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"objectId\":\"09Mp23m4bEOInUqT\""))
        XCTAssertFalse(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"password\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\""))
    }

    func test_logIn_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        XCTAssertNil(NCMBUser.currentUser)

        let result : NCMBResult<Void> = NCMBUser.logIn(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234")

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertNil(NCMBUser.currentUser)
    }

    func test_logIn_failure_DontSaveFile() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        _ = NCMBUser.logIn(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234")

        XCTAssertEqual(manager.saveLog.count, 0)
    }

    func test_logInInBackground_userName_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_userName_request")
        NCMBUser.logInInBackground(userName: "Yamada Tarou", mailAddress: nil, password: "abcd1234", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].queryItems.count, 2)
            XCTAssertEqual(executor.requests[0].queryItems["userName"], "Yamada Tarou")
            XCTAssertEqual(executor.requests[0].queryItems["password"], "abcd1234")
            XCTAssertNil(executor.requests[0].body)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logInInBackground_mailAddress_request() {
        let contents : [String : Any] = ["createDate":"2013-08-28T11:27:16.446Z", "objectId":"epaKcaYZqsREdSMY", "sessionToken":"iXDIelJRY3ULBdms281VTmc5O", "userName":"Yamada Tarou"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_mailAddress_request")
        NCMBUser.logInInBackground(userName: nil, mailAddress: "sample@example.com", password: "abcd1234", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].queryItems.count, 2)
            XCTAssertEqual(executor.requests[0].queryItems["mailAddress"], "sample@example.com")
            XCTAssertEqual(executor.requests[0].queryItems["password"], "abcd1234")
            XCTAssertNil(executor.requests[0].body)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logInInBackground_success() {
        let body : Data? = "{\"objectId\":\"09Mp23m4bEOInUqT\",\"userName\":\"user01\",\"mailAddress\":null,\"mailAddressConfirm\":null,\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\",\"createDate\":\"2013-08-28T07:46:09.801Z\",\"updateDate\":\"2013-08-30T05:32:03.868Z\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        XCTAssertNil(NCMBUser.currentUser)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_success")
        NCMBUser.logInInBackground(userName: "user01", mailAddress: nil, password: "passwd", callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertNotNil(NCMBUser.currentUser)
            XCTAssertEqual(NCMBUser.currentUser!.objectId, "09Mp23m4bEOInUqT")
            XCTAssertEqual(NCMBUser.currentUser!.sessionToken, "ebDH8TtmLoygzjqjaI4EWFfxc")
            XCTAssertEqual(NCMBUser.currentUser!.userName, "user01")
            XCTAssertNil(NCMBUser.currentUser!.password) // password not in response
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logInInBackground_success_saveFile() {
        let body : Data? = "{\"objectId\":\"09Mp23m4bEOInUqT\",\"userName\":\"user01\",\"mailAddress\":null,\"mailAddressConfirm\":null,\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\",\"createDate\":\"2013-08-28T07:46:09.801Z\",\"updateDate\":\"2013-08-30T05:32:03.868Z\"}".data(using: .utf8)!
        let response : NCMBResponse = MockResponseBuilder.createResponse(body: body, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_success_saveFile")
        NCMBUser.logInInBackground(userName: "user01", mailAddress: nil, password: "passwd", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(manager.saveLog.count, 1)
            XCTAssertEqual(manager.saveLog[0].type, .currentUser)
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"objectId\":\"09Mp23m4bEOInUqT\""))
            XCTAssertFalse(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"password\""))
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"sessionToken\":\"ebDH8TtmLoygzjqjaI4EWFfxc\""))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logInInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        XCTAssertNil(NCMBUser.currentUser)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_failure")
        NCMBUser.logInInBackground(userName: "user01", mailAddress: nil, password: "passwd", callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertNil(NCMBUser.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logInInBackground_failure_DontSaveFile() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        XCTAssertNil(NCMBUser.currentUser)

        let expectation : XCTestExpectation? = self.expectation(description: "test_logInInBackground_failure_DontSaveFile")
        NCMBUser.logInInBackground(userName: "user01", mailAddress: nil, password: "passwd", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(manager.saveLog.count, 0)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logOut_success() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let result : NCMBResult<Void> = NCMBUser.logOut()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertNil(NCMBUser.currentUser)
    }

    func test_logOut_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let result : NCMBResult<Void> = NCMBUser.logOut()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertNotNil(NCMBUser.currentUser)
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")
    }

    func test_logOut_success_deleteFile() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let result : NCMBResult<Void> = NCMBUser.logOut()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertEqual(manager.deleteLog.count, 1)
        XCTAssertEqual(manager.deleteLog[0], NCMBLocalFileType.currentUser)
    }

    func test_logOut_failure_dontDeleteFile() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let result : NCMBResult<Void> = NCMBUser.logOut()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(manager.deleteLog.count, 0)
    }

    func test_logOutInBackground_success() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let expectation : XCTestExpectation? = self.expectation(description: "test_logOutInBackground_success")
        NCMBUser.logOutInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertNil(NCMBUser.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logOutInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let expectation : XCTestExpectation? = self.expectation(description: "test_logOutInBackground_failure")
        NCMBUser.logOutInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertNotNil(NCMBUser.currentUser)
            XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
            XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logOutInBackground_success_deleteFile() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let expectation : XCTestExpectation? = self.expectation(description: "test_logOutInBackground_success_deleteFile")
        NCMBUser.logOutInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertEqual(manager.deleteLog.count, 1)
            XCTAssertEqual(manager.deleteLog[0], NCMBLocalFileType.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_logOutInBackground_failure_dontDeleteFile() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user
        XCTAssertEqual(NCMBUser.currentUser!.userName, "takano_san")
        XCTAssertEqual(NCMBUser.currentUser!.password, "pswdpswd")

        let expectation : XCTestExpectation? = self.expectation(description: "test_logOutInBackground_failure_dontDeleteFile")
        NCMBUser.logOutInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(manager.deleteLog.count, 0)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestPasswordReset_request() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        _ = NCMBUser.requestPasswordReset(mailAddress: "sample@example.com")
        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].queryItems.count, 0)
        XCTAssertEqual(executor.requests[0].body!, "{\"mailAddress\":\"sample@example.com\"}".data(using: .utf8))
    }

    func test_requestPasswordReset_success() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let result : NCMBResult<Void> = NCMBUser.requestPasswordReset(mailAddress: "sample@example.com")
        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
    }

    func test_requestPasswordReset_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let result : NCMBResult<Void> = NCMBUser.requestPasswordReset(mailAddress: "sample@example.com")
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
    }

    func test_requestPasswordResetInBackground_request() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestPasswordResetInBackground_request")
        NCMBUser.requestPasswordResetInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].queryItems.count, 0)
            XCTAssertEqual(executor.requests[0].body!, "{\"mailAddress\":\"sample@example.com\"}".data(using: .utf8))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestPasswordResetInBackground_success() {
        let contents : [String : Any] = ["createDate":"2013-09-04T04:31:43.371Z"]
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestPasswordResetInBackground_success")
        NCMBUser.requestPasswordResetInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_requestPasswordResetInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let expectation : XCTestExpectation? = self.expectation(description: "test_requestPasswordResetInBackground_failure")
        NCMBUser.requestPasswordResetInBackground(mailAddress: "sample@example.com", callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_fetch_success() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["field2"] = "value2"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 200)
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .success(response)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let result : NCMBResult<Void> = sut.fetch()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertEqual(sut.objectId, "abcdefg12345")
        XCTAssertNil(sut["field1"])
        XCTAssertEqual(sut["field2"], "value2")
    }

    func test_fetch_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let result : NCMBResult<Void> = sut.fetch()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
        XCTAssertEqual(sut.objectId, "abcdefg12345")
        XCTAssertEqual(sut["field1"], "value1")
    }

    func test_fetchInBackground_success() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["field2"] = "value2"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 200)
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .success(response)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_fetchInBackground_success")
        sut.fetchInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertEqual(sut.objectId, "abcdefg12345")
            XCTAssertNil(sut["field1"])
            XCTAssertEqual(sut["field2"], "value2")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_fetchInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_fetchInBackground_failure")
        sut.fetchInBackground(callback: { result in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            XCTAssertEqual(sut.objectId, "abcdefg12345")
            XCTAssertEqual(sut["field1"], "value1")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_fetchInBackground_reset_modifiedFields() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["field2"] = "value2"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 200)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_fetchInBackground_reset_modifiedFields")
        sut.fetchInBackground(callback: { (result: NCMBResult<Void>) in
            sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
                XCTAssertEqual(executor.requests.count, 2)
                XCTAssertEqual(String(data: executor.requests[1].body!, encoding: .utf8)!, "{}")
                expectation?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_save_success() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"
        XCTAssertEqual(sut.needUpdate, true)

        let result : NCMBResult<Void> = sut.save()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertEqual(executor.requests.count, 1)
        XCTAssertEqual(executor.requests[0].method, NCMBHTTPMethod.put)
        XCTAssertEqual(String(data: executor.requests[0].body!, encoding: .utf8)!, "{\"field1\":\"value1\"}")
        XCTAssertEqual(sut.objectId, "abcdefg12345")
        XCTAssertEqual(sut["field1"], "value1")
        XCTAssertEqual(sut["craeteDate"], "1986-02-04T12:34:56.789Z")
        XCTAssertEqual(sut.needUpdate, false)
    }

    func test_save_haveNotObjectId_failure() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut["field1"] = "value1"

        let result : NCMBResult<Void> = sut.save()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! NCMBInvalidRequestError, NCMBInvalidRequestError.emptyObjectId)
        XCTAssertEqual(sut["field1"], "value1")
    }

    func test_save_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"
        XCTAssertEqual(sut.needUpdate, true)

        let result : NCMBResult<Void> = sut.save()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
        XCTAssertEqual(sut["field1"], "value1")
    }

    func test_saveInBackground_success() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"
        XCTAssertEqual(sut.needUpdate, true)

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_success")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertEqual(executor.requests.count, 1)
            XCTAssertEqual(executor.requests[0].method, NCMBHTTPMethod.put)
            XCTAssertEqual(String(data: executor.requests[0].body!, encoding: .utf8)!, "{\"field1\":\"value1\"}")
            XCTAssertEqual(sut.objectId, "abcdefg12345")
            XCTAssertEqual(sut["field1"], "value1")
            XCTAssertEqual(sut["craeteDate"], "1986-02-04T12:34:56.789Z")
            XCTAssertEqual(sut.needUpdate, false)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_success_currentUser() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let user : NCMBUser = NCMBUser()
        user.objectId = "abcdefg12345"
        user.userName = "takano_san"
        user.password = "pswdpswd"
        user["sessionToken"] = "iXDIelJRY3ULBdms281VTmc5O"
        NCMBUser._currentUser = user

        let sut : NCMBUser = NCMBUser.currentUser!
        sut["field1"] = "value1"
        XCTAssertEqual(sut.sessionToken, "iXDIelJRY3ULBdms281VTmc5O")

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_success_currentUser")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertEqual(executor.requests.count, 1) // currentUser
            XCTAssertTrue(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"field1\":\"value1\""))
            XCTAssertFalse(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"sessionToken\""))
            XCTAssertFalse(String(data: executor.requests[0].body!, encoding: .utf8)!.contains("\"iXDIelJRY3ULBdms281VTmc5O\""))
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_haveNotObjectId_failure() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_success_insert")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! NCMBInvalidRequestError, NCMBInvalidRequestError.emptyObjectId)
            XCTAssertEqual(sut["field1"], "value1")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)

    }

    func test_saveInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"
        XCTAssertEqual(sut.needUpdate, true)

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_failure")
        sut.saveInBackground(callback: { result in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            XCTAssertEqual(sut["field1"], "value1")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_reset_modifiedFields() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_reset_modifiedFields")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            sut["field2"] = "value2"
            sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
                XCTAssertEqual(executor.requests.count, 2)
                XCTAssertEqual(String(data: executor.requests[1].body!, encoding: .utf8)!, "{\"field2\":\"value2\"}")
                expectation?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_modifiedFields_null() {
        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_modifiedFields_null")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            sut.removeField(field: "field1")
            sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
                XCTAssertEqual(executor.requests.count, 2)
                XCTAssertEqual(String(data: executor.requests[1].body!, encoding: .utf8)!, "{\"field1\":null}")
                expectation?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_saveToLocalFile_currentUser() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.objectId = "abcdefg12345"
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user

        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_saveToLocalFile")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))

            XCTAssertEqual(manager.saveLog.count, 1)
            XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"field1\":\"value1\""))
            XCTAssertEqual(manager.saveLog[0].type, NCMBLocalFileType.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_saveInBackground_saveToLocalFile_notCurrentUser() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.objectId = "hijklmn789"
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user

        var contents : [String : Any] = [:]
        contents["objectId"] = "abcdefg12345"
        contents["craeteDate"] = "1986-02-04T12:34:56.789Z"
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: contents, statusCode: 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_saveInBackground_saveToLocalFile")
        sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))

            XCTAssertEqual(manager.saveLog.count, 0)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_delete_success() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .success(response)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let result : NCMBResult<Void> = sut.delete()

        XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
        XCTAssertNil(sut.objectId)
        XCTAssertNil(sut["field1"])
    }

    func test_delete_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let result : NCMBResult<Void> = sut.delete()

        XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
        XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
        XCTAssertEqual(sut.objectId, "abcdefg12345")
        XCTAssertEqual(sut["field1"], "value1")
    }

    func test_deleteInBackground_success() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .success(response)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_deleteInBackground_success")
        sut.deleteInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertTrue(NCMBTestUtil.checkResultIsSuccess(result: result))
            XCTAssertNil(sut.objectId)
            XCTAssertNil(sut["field1"])
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_deleteInBackground_failure() {
        NCMBRequestExecutorFactory.setInstance(executor: MockRequestExecutor(result: .failure(DummyErrors.dummyError)))

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_deleteInBackground_failure")
        sut.deleteInBackground(callback: { result in
            XCTAssertTrue(NCMBTestUtil.checkResultIsFailure(result: result))
            XCTAssertEqual(NCMBTestUtil.getError(result: result)! as! DummyErrors, DummyErrors.dummyError)
            XCTAssertEqual(sut.objectId, "abcdefg12345")
            XCTAssertEqual(sut["field1"], "value1")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_deleteInBackground_reset_modifiedFields() {
        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_deleteInBackground_reset_modifiedFields")
        sut.deleteInBackground(callback: { (result: NCMBResult<Void>) in
            sut.objectId = "abcdefg12345"
            sut.saveInBackground(callback: { (result: NCMBResult<Void>) in
                XCTAssertEqual(executor.requests.count, 2)
                XCTAssertEqual(String(data: executor.requests[1].body!, encoding: .utf8)!, "{}")
                expectation?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_deleteInBackground_deleteLocalFile_currentUser() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.objectId = "abcdefg12345"
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user

        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_deleteInBackground_deleteLocalFile_currentUser")
        sut.deleteInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(manager.deleteLog.count, 1)
            XCTAssertEqual(manager.deleteLog[0], NCMBLocalFileType.currentUser)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_deleteInBackground_deleteLocalFile_notCurrentUser() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser = NCMBUser()
        user.objectId = "hijklmn789"
        user.userName = "takano_san"
        user.password = "pswdpswd"
        NCMBUser._currentUser = user

        let response : NCMBResponse = MockResponseBuilder.createResponse(contents: [:], statusCode : 201)
        let executor : MockRequestExecutor = MockRequestExecutor(result: .success(response))
        NCMBRequestExecutorFactory.setInstance(executor: executor)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "abcdefg12345"
        sut["field1"] = "value1"

        let expectation : XCTestExpectation? = self.expectation(description: "test_deleteInBackground_deleteLocalFile_notCurrentUser")
        sut.deleteInBackground(callback: { (result: NCMBResult<Void>) in
            XCTAssertEqual(manager.deleteLog.count, 0)
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1.00, handler: nil)
    }

    func test_loadFromFile_success() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "{\"userName\":\"takanokun\",\"password\":\"abcdefgh\",\"sessionToken\":\"jklmnopqr45678\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser? = NCMBUser.loadFromFile()
        XCTAssertEqual(user!.userName, "takanokun")
        XCTAssertEqual(user!.sessionToken, "jklmnopqr45678")
    }

    func test_loadFromFile_noData() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser? = NCMBUser.loadFromFile()
        XCTAssertNil(user)
    }

    func test_loadFromFile_invalidJson() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: "\"userName\":\"takanokun\",\"password\":\"abcdefgh\"}".data(using: .utf8)!)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let user : NCMBUser? = NCMBUser.loadFromFile()
        XCTAssertNil(user)
    }

    func test_saveToFile() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "hijklmn789"
        sut.userName = "takano_san"
        sut.password = "pswdpswd"
        sut["sessionToken"] = "mnopqrstuv123456789"

        sut.saveToFile()

        XCTAssertEqual(manager.saveLog.count, 1)
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"objectId\":\"hijklmn789\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"userName\":\"takano_san\""))
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"password\":\"pswdpswd\""))
    }

    func test_saveToFile_localFile_have_sessionToken() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "hijklmn789"
        sut.userName = "takano_san"
        sut.password = "pswdpswd"
        sut["sessionToken"] = "mnopqrstuv123456789"

        sut.saveToFile()

        XCTAssertEqual(manager.saveLog.count, 1)
        XCTAssertTrue(String(data: manager.saveLog[0].data, encoding: .utf8)!.contains("\"sessionToken\":\"mnopqrstuv123456789\""))
    }

    func test_saveToFile_user_have_sessionToken() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        let sut : NCMBUser = NCMBUser()
        sut.objectId = "hijklmn789"
        sut.userName = "takano_san"
        sut.password = "pswdpswd"
        sut["sessionToken"] = "mnopqrstuv123456789"

        sut.saveToFile()

        XCTAssertEqual(sut.sessionToken, "mnopqrstuv123456789")
    }

    func test_deleteFile() {
        let manager : MockLocalFileManager = MockLocalFileManager(loadResponse: nil)
        NCMBLocalFileManagerFactory.setInstance(manager: manager)

        NCMBUser.deleteFile()

        XCTAssertEqual(manager.deleteLog.count, 1)
        XCTAssertEqual(manager.deleteLog[0], NCMBLocalFileType.currentUser)
    }

    static var allTests = [
        ("test_isIgnoredKey", test_isIgnoredKey),
        ("test_isIgnoredKey_setFieldValue", test_isIgnoredKey_setFieldValue),
        ("test_copy", test_copy),
        ("test_currentUserSessionToken", test_currentUserSessionToken),
        ("test_sessionToken", test_sessionToken),
        ("test_userName", test_userName),
        ("test_password", test_password),
        ("test_mailAddress", test_mailAddress),
        ("test_authData_default", test_authData_default),
        ("test_authData_field_not_dictionary", test_authData_field_not_dictionary),
        ("test_authData_field_dictionary", test_authData_field_dictionary),
        ("test_currentUser_noLocalFile_noMemory", test_currentUser_noLocalFile_noMemory),
        ("test_currentUser_LocalFile_noMemory", test_currentUser_LocalFile_noMemory),
        ("test_currentUser_LocalFile_Memory", test_currentUser_LocalFile_Memory),
        ("test_isAuthenticated", test_isAuthenticated),
        ("test_automaticCurrentUser_noCurrentUser_success", test_automaticCurrentUser_noCurrentUser_success),
        ("test_automaticCurrentUser_noCurrentUser_failure", test_automaticCurrentUser_noCurrentUser_failure),
        ("test_automaticCurrentUser_noCurrentUser_failure_automaticUserNotAvailable", test_automaticCurrentUser_noCurrentUser_failure_automaticUserNotAvailable),
        ("test_automaticCurrentUser_currentUser", test_automaticCurrentUser_currentUser),
        ("test_automaticCurrentUserInBackground_noCurrentUser_success", test_automaticCurrentUserInBackground_noCurrentUser_success),
        ("test_automaticCurrentUserInBackground_noCurrentUser_failure", test_automaticCurrentUserInBackground_noCurrentUser_failure),
        ("test_automaticCurrentUserInBackground_noCurrentUser_failure_automaticUserNotAvailable", test_automaticCurrentUserInBackground_noCurrentUser_failure_automaticUserNotAvailable),
        ("test_automaticCurrentUserInBackground_currentUser", test_automaticCurrentUserInBackground_currentUser),
        ("test_signUp_default_request", test_signUp_default_request),
        ("test_signUp_default_success", test_signUp_default_success),
        ("test_signUp_default_success_saveData", test_signUp_default_success_saveData),
        ("test_signUp_default_failure", test_signUp_default_failure),
        ("test_signUpInBackground_default_request", test_signUpInBackground_default_request),
        ("test_signUpInBackground_default_success", test_signUpInBackground_default_success),
        ("test_signUpInBackground_default_success_currentUser", test_signUpInBackground_default_success_currentUser),
        ("test_signUpInBackground_default_success_saveData", test_signUpInBackground_default_success_saveData),
        ("test_signUpInBackground_default_failure", test_signUpInBackground_default_failure),
        ("test_signUpInBackground_default_failure_currentUser", test_signUpInBackground_default_failure_currentUser),
        ("test_requestAuthenticationMailInBackground_request", test_requestAuthenticationMailInBackground_request),
        ("test_requestAuthenticationMailInBackground_success", test_requestAuthenticationMailInBackground_success),
        ("test_requestAuthenticationMailInBackground_failure", test_requestAuthenticationMailInBackground_failure),
        ("test_requestAuthenticationMail_request", test_requestAuthenticationMail_request),
        ("test_requestAuthenticationMail_success", test_requestAuthenticationMail_success),
        ("test_requestAuthenticationMail_failure", test_requestAuthenticationMail_failure),
        ("test_logIn_userName_request", test_logIn_userName_request),
        ("test_logIn_mailAddress_request", test_logIn_mailAddress_request),
        ("test_logIn_success", test_logIn_success),
        ("test_logIn_success_saveFile", test_logIn_success_saveFile),
        ("test_logIn_failure", test_logIn_failure),
        ("test_logIn_failure_DontSaveFile", test_logIn_failure_DontSaveFile),
        ("test_logInInBackground_userName_request", test_logInInBackground_userName_request),
        ("test_logInInBackground_mailAddress_request", test_logInInBackground_mailAddress_request),
        ("test_logInInBackground_success", test_logInInBackground_success),
        ("test_logInInBackground_success_saveFile", test_logInInBackground_success_saveFile),
        ("test_logInInBackground_failure", test_logInInBackground_failure),
        ("test_logInInBackground_failure_DontSaveFile", test_logInInBackground_failure_DontSaveFile),
        ("test_logOut_success", test_logOut_success),
        ("test_logOut_failure", test_logOut_failure),
        ("test_logOut_success_deleteFile", test_logOut_success_deleteFile),
        ("test_logOut_failure_dontDeleteFile", test_logOut_failure_dontDeleteFile),
        ("test_logOutInBackground_success", test_logOutInBackground_success),
        ("test_logOutInBackground_failure", test_logOutInBackground_failure),
        ("test_logOutInBackground_success_deleteFile", test_logOutInBackground_success_deleteFile),
        ("test_logOutInBackground_failure_dontDeleteFile", test_logOutInBackground_failure_dontDeleteFile),
        ("test_requestPasswordReset_request", test_requestPasswordReset_request),
        ("test_requestPasswordReset_success", test_requestPasswordReset_success),
        ("test_requestPasswordReset_failure", test_requestPasswordReset_failure),
        ("test_requestPasswordResetInBackground_request", test_requestPasswordResetInBackground_request),
        ("test_requestPasswordResetInBackground_success", test_requestPasswordResetInBackground_success),
        ("test_requestPasswordResetInBackground_failure", test_requestPasswordResetInBackground_failure),
        ("test_fetch_success", test_fetch_success),
        ("test_fetch_failure", test_fetch_failure),
        ("test_fetchInBackground_success", test_fetchInBackground_success),
        ("test_fetchInBackground_failure", test_fetchInBackground_failure),
        ("test_fetchInBackground_reset_modifiedFields", test_fetchInBackground_reset_modifiedFields),
        ("test_save_success", test_save_success),
        ("test_save_haveNotObjectId_failure", test_save_haveNotObjectId_failure),
        ("test_save_failure", test_save_failure),
        ("test_saveInBackground_success", test_saveInBackground_success),
        ("test_saveInBackground_success_currentUser", test_saveInBackground_success_currentUser),
        ("test_saveInBackground_haveNotObjectId_failure", test_saveInBackground_haveNotObjectId_failure),
        ("test_saveInBackground_failure", test_saveInBackground_failure),
        ("test_saveInBackground_reset_modifiedFields", test_saveInBackground_reset_modifiedFields),
        ("test_saveInBackground_modifiedFields_null", test_saveInBackground_modifiedFields_null),
        ("test_saveInBackground_saveToLocalFile_currentUser", test_saveInBackground_saveToLocalFile_currentUser),
        ("test_saveInBackground_saveToLocalFile_notCurrentUser", test_saveInBackground_saveToLocalFile_notCurrentUser),
        ("test_delete_success", test_delete_success),
        ("test_delete_failure", test_delete_failure),
        ("test_deleteInBackground_success", test_deleteInBackground_success),
        ("test_deleteInBackground_failure", test_deleteInBackground_failure),
        ("test_deleteInBackground_reset_modifiedFields", test_deleteInBackground_reset_modifiedFields),
        ("test_deleteInBackground_deleteLocalFile_currentUser", test_deleteInBackground_deleteLocalFile_currentUser),
        ("test_deleteInBackground_deleteLocalFile_notCurrentUser", test_deleteInBackground_deleteLocalFile_notCurrentUser),
        ("test_loadFromFile_success", test_loadFromFile_success),
        ("test_loadFromFile_noData", test_loadFromFile_noData),
        ("test_loadFromFile_invalidJson", test_loadFromFile_invalidJson),
        ("test_saveToFile", test_saveToFile),
        ("test_saveToFile_localFile_have_sessionToken", test_saveToFile_localFile_have_sessionToken),
        ("test_saveToFile_user_have_sessionToken", test_saveToFile_user_have_sessionToken),
        ("test_deleteFile", test_deleteFile),
    ]
}
