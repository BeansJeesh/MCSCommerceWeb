/* Copyright © 2019 Mastercard. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 =============================================================================*/

#import <XCTest/XCTest.h>
#import "MCCPaymentMethod.h"
#import "MCCSVGImage.h"

@interface MCCPaymentMethodTests : XCTestCase

@end

@implementation MCCPaymentMethodTests

-(void)testInitialization{
    MCCPaymentMethod *paymentMethod = [[MCCPaymentMethod alloc] init];
    
    XCTAssertTrue([paymentMethod.paymentMethodID isEqualToString: @"101"],@"paymentMethodID should be the same");
}

-(void)testInitWithID{
    
    MCCPaymentMethod *paymentMethod = [[MCCPaymentMethod alloc] initWithID:@"101"];
    
    XCTAssertTrue([paymentMethod.paymentMethodID isEqualToString: @"101"],@"paymentMethodID should be the same");
}

@end
