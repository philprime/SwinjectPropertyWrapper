import Quick
import Nimble
@testable import SwinjectPropertyWrapper
import Swinject

final class InjectTests: QuickSpec {

    private class TestService {}

    private class TestClass {
        @Inject var service: TestService
    }

    override func spec() {
        describe("Inject") {
            describe("resolving") {
                context("global injection resolver not set") {
                    it("should not throw a precondition failure before accessing value") {
                        let service = TestService()

                        let container = Container()
                        container.register(TestService.self, factory: { _ in service })

                        expect {
                            let _ = TestClass()
                        }.toNot(throwAssertion())
                    }

                    it("should throw a precondition failure") {
                        let service = TestService()

                        let container = Container()
                        container.register(TestService.self, factory: { _ in service })

                        expect {
                            InjectSettings.resolver = nil
                            let object = TestClass()
                            let _ = object.service
                        }.to(throwAssertion())
                    }
                }

                context("global injection resolver is set") {
                    var container: Container!

                    beforeEach {
                        container = Container()
                        InjectSettings.resolver = container
                    }

                    context("service is not registered") {
                        it("should not throw a precondition failure before accessing value") {
                            expect {
                                let _ = TestClass()
                            }.toNot(throwAssertion())
                        }

                        it("should throw a precondition failure") {
                            expect {
                                let object = TestClass()
                                let _ = object.service
                            }.to(throwAssertion())
                        }
                    }

                    context("service is registered") {
                        let service = TestService()

                        beforeEach {
                            container.register(TestService.self, factory: { _ in service })
                        }

                        it("should not throw a precondition failure before accessing value") {
                            expect {
                                let _ = TestClass()
                            }.toNot(throwAssertion())
                        }

                        it("should return registered service") {
                            expect(TestClass().service) === service
                        }

                        it("should not initalize value more than once") {
                            let object = TestClass()
                            expect(object.service) === service
                            expect(object.service) === service
                        }
                    }
                }

                context("custom resolver set") {
                    it("should use custom resolver") {
                        class CustomResolverTestSettings {
                            static let container = Container()
                        }
                        class CustomResolverTestObject {
                            @Inject(resolver: CustomResolverTestSettings.container) var service: TestService
                        }

                        let service = TestService()
                        CustomResolverTestSettings.container.register(TestService.self, factory: { _ in service })

                        let object = CustomResolverTestObject()
                        expect(object.service) === service
                    }

                    context("custom service name") {
                        it("should use custom name") {
                            class CustomResolverTestSettings {
                                static let container = Container()
                            }
                            class CustomResolverTestObject {
                                @Inject(name: "MyAwesomeTestService", resolver: CustomResolverTestSettings.container) var service: TestService
                            }

                            let service = TestService()
                            CustomResolverTestSettings.container.register(TestService.self, name: "MyAwesomeTestService", factory: { _ in service })

                            let object = CustomResolverTestObject()
                            expect(object.service) === service
                        }

                        it("should fail to resolve without name") {
                            class CustomResolverTestSettings {
                                static let container = Container()
                            }
                            class CustomResolverTestObject {
                                @Inject(name: "MyAwesomeTestService", resolver: CustomResolverTestSettings.container) var service: TestService
                            }

                            let service = TestService()
                            CustomResolverTestSettings.container.register(TestService.self, factory: { _ in service })

                            let object = CustomResolverTestObject()
                            expect{
                                _ = object.service
                            }.to(throwAssertion())
                        }
                    }
                }
            }
            describe("setter") {
                it("should set value and initalized state") {
                    let object = TestClass()
                    let service = TestService()
                    object.service = service
                    expect(object.service) === service
                }
            }
        }
    }
}
