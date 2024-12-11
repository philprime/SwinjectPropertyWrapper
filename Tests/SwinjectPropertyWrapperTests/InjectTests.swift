import Foundation
import XCTest
@testable import SwinjectPropertyWrapper
import Swinject
import CwlPreconditionTesting

final class InjectTests: XCTestCase {
    
    private class TestService {}
    
    private class TestClass {
        @Inject var service: TestService
    }
    
    @MainActor override func setUp() {
        super.setUp()
        // Reset resolver before each test
        InjectSettings.resolver = nil
    }
    
    @MainActor func testNoResolverSetShouldNotThrowBeforeAccess() {
        let service = TestService()
        let container = Container()
        container.register(TestService.self, factory: { _ in service })
        
        // Should not throw when creating instance
        _ = TestClass()
    }
    
    @MainActor func testNoResolverSetShouldThrowOnAccess() {
        let service = TestService()
        let container = Container()
        container.register(TestService.self, factory: { _ in service })
        
        let object = TestClass()
        let e = catchBadInstruction {
            _ = object.service
        }
        XCTAssertNotNil(e)
    }
    
    @MainActor func testUnregisteredServiceShouldNotThrowBeforeAccess() {
        let container = Container()
        InjectSettings.resolver = container
        
        // Should not throw when creating instance
        _ = TestClass()
    }
    
    @MainActor func testUnregisteredServiceShouldThrowOnAccess() {
        let container = Container()
        InjectSettings.resolver = container
        
        let object = TestClass()
        let e = catchBadInstruction {
            _ = object.service
        }
        XCTAssertNotNil(e)
    }
    
    @MainActor func testRegisteredServiceResolution() {
        let container = Container()
        InjectSettings.resolver = container
        
        let service = TestService()
        container.register(TestService.self, factory: { _ in service })
        
        let object = TestClass()
        XCTAssertTrue(object.service === service)
    }
    
    @MainActor func testServiceSingletonBehavior() {
        let container = Container()
        InjectSettings.resolver = container
        
        let service = TestService()
        container.register(TestService.self, factory: { _ in service })
        
        let object = TestClass()
        let firstAccess = object.service
        let secondAccess = object.service
        
        XCTAssertTrue(firstAccess === secondAccess)
        XCTAssertTrue(firstAccess === service)
    }
    
    @MainActor func testCustomResolver() {
        class CustomResolverTestSettings {
            static let container = Container()
        }
        class CustomResolverTestObject {
            @Inject(resolver: CustomResolverTestSettings.container) var service: TestService
        }
        
        let service = TestService()
        CustomResolverTestSettings.container.register(TestService.self, factory: { _ in service })
        
        let object = CustomResolverTestObject()
        XCTAssertTrue(object.service === service)
    }
    
    @MainActor func testCustomServiceName() {
        class CustomResolverTestSettings {
            static let container = Container()
        }
        class CustomResolverTestObject {
            @Inject(name: "MyAwesomeTestService", resolver: CustomResolverTestSettings.container) var service: TestService
        }
        
        let service = TestService()
        CustomResolverTestSettings.container.register(TestService.self, name: "MyAwesomeTestService", factory: { _ in service })
        
        let object = CustomResolverTestObject()
        XCTAssertTrue(object.service === service)
    }
    
    @MainActor func testCustomServiceNameFailureWithoutName() {
        class CustomResolverTestSettings {
            static let container = Container()
        }
        class CustomResolverTestObject {
            @Inject(name: "MyAwesomeTestService", resolver: CustomResolverTestSettings.container) var service: TestService
        }
        
        let service = TestService()
        CustomResolverTestSettings.container.register(TestService.self, factory: { _ in service })

        let object = CustomResolverTestObject()
        let e = catchBadInstruction {
            _ = object.service
        }
        XCTAssertNotNil(e)
    }
    
    @MainActor func testSetterBehavior() {
        let object = TestClass()
        let service = TestService()
        object.service = service
        XCTAssertTrue(object.service === service)
    }
}
