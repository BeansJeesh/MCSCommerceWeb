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

#import "MCSCheckoutUrlBuilder.h"
#import "MCSCheckoutRequest.h"
#import "MCSConfigurationManager.h"

NSString * const _Nonnull kAllowedCardTypesKey                  = @"allowedCardTypes";
NSString * const _Nonnull kAmountKey                            = @"amount";
NSString * const _Nonnull kCartIdKey                            = @"cartId";
NSString * const _Nonnull kCurrencyKey                          = @"currency";
NSString * const _Nonnull kLocaleKey                            = @"locale";
NSString * const _Nonnull kCheckoutIDKey                        = @"checkoutId";
NSString * const _Nonnull kSuppress3Ds                          = @"suppress3Ds";
NSString * const _Nonnull kCVC2SupportKey                       = @"cvc2Support";
NSString * const _Nonnull kSuppressShippingAdressKey            = @"suppressShippingAddress";
NSString * const _Nonnull kValidityPeriodMinutesKey             = @"validityPeriodMinutes";
NSString * const _Nonnull kUnpridictableNumberKey               = @"unpredictableNumber";
NSString * const _Nonnull kShippingLocationProfileKey           = @"shippingLocationProfile";
NSString * const _Nonnull kMerchantNameKey                      = @"merchantName";
NSString * const _Nonnull kCryptoOptionsKey                     = @"cryptoOptions";
NSString * const _Nonnull kChannelKey                           = @"channel";
NSString * const _Nonnull kChannelValue                         = @"mobile";
NSString * const _Nonnull kSdkVersionKey                        = @"sdkVersion";
NSString * const _Nonnull kPlatformKey                          = @"platform";
NSString * const _Nonnull kPlatformValue                        = @"ios";

@implementation MCSCheckoutUrlBuilder

+ (NSURL *)urlForCheckout {
    MCSConfiguration *configuration = [[MCSConfigurationManager sharedManager] configuration];
    MCSCheckoutRequest *checkoutRequest = [[MCSConfigurationManager sharedManager] checkoutRequest];
    
    if (![[configuration.checkoutUrl substringFromIndex:[configuration.checkoutUrl length] - 1] isEqualToString:@"/"] ) {
        configuration.checkoutUrl = [[configuration checkoutUrl] stringByAppendingString:@"/"];
    }
    
    NSDictionary *queryDictionary = [MCSCheckoutUrlBuilder dictionaryForCheckoutRequest:checkoutRequest configuration:configuration];
    NSURLComponents *components = [NSURLComponents componentsWithString:configuration.checkoutUrl];
    NSMutableArray *queryItems = [NSMutableArray array];
    
    for (NSString *key in queryDictionary) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryDictionary[key]]];
    }
    
    components.queryItems = queryItems;
    
    NSLog(@"URL generated: %@", components.URL);
    
    return components.URL;
}

+ (NSDictionary *)dictionaryForCheckoutRequest:(MCSCheckoutRequest *)checkoutRequest configuration:(MCSConfiguration *)configuration {
    NSMutableDictionary *checkoutRequestDictionary = [[NSMutableDictionary alloc] init];
    
    [checkoutRequestDictionary setValue:[checkoutRequest.amount stringValue] forKey:kAmountKey];
    [checkoutRequestDictionary setValue:checkoutRequest.cartId forKey:kCartIdKey];
    [checkoutRequestDictionary setValue:checkoutRequest.currency forKey:kCurrencyKey];
    [checkoutRequestDictionary setValue:configuration.locale.localeIdentifier forKey:kLocaleKey];
    [checkoutRequestDictionary setValue:configuration.checkoutId forKey:kCheckoutIDKey];
    [checkoutRequestDictionary setValue:[MCSCheckoutUrlBuilder nilOrStringForBool:checkoutRequest.suppress3Ds] forKey:kSuppress3Ds];
    [checkoutRequestDictionary setValue:[MCSCheckoutUrlBuilder nilOrStringForBool:checkoutRequest.cvc2Support] forKey:kCVC2SupportKey];
    [checkoutRequestDictionary setValue:[MCSCheckoutUrlBuilder nilOrStringForNumber:checkoutRequest.validityPeriodMinutes] forKey:kValidityPeriodMinutesKey];
    [checkoutRequestDictionary setValue:checkoutRequest.suppressShippingAddress ? @"true" : @"false"
                                 forKey:kSuppressShippingAdressKey];
    [checkoutRequestDictionary setValue:checkoutRequest.unpredictableNumber forKey:kUnpridictableNumberKey];
    [checkoutRequestDictionary setValue:checkoutRequest.shippingLocationProfile forKey:kShippingLocationProfileKey];
    [checkoutRequestDictionary setValue:[configuration.allowedCardTypes.allObjects componentsJoinedByString:@","] forKey:kAllowedCardTypesKey];
    [checkoutRequestDictionary setValue:kChannelValue forKey:kChannelKey];
    
    if (checkoutRequest.cryptoOptions != nil) {
        for (MCSCryptoOptions *option in checkoutRequest.cryptoOptions) {
            NSString *cryptoFormatKey = [NSString stringWithFormat:@"%@CryptoFormat", option.cardType];
            NSString *cryptoFormatValue = [[option.format allObjects] componentsJoinedByString:@","];
            
            [checkoutRequestDictionary setValue:cryptoFormatValue forKey:cryptoFormatKey];
        }
    }
    
    // Used for remote logging
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    [checkoutRequestDictionary setValue:frameworkBundle.infoDictionary[@"CFBundleShortVersionString"] forKey:kSdkVersionKey];
    [checkoutRequestDictionary setValue:kPlatformValue forKey:kPlatformKey];
    
    return checkoutRequestDictionary;
}

+ (NSString *_Nullable) nilOrStringForBool:(NSNumber *)value {
    if (value != nil) {
        return value.boolValue ? @"true" : @"false";
    } else {
        return nil;
    }
}

+ (NSString *_Nullable) nilOrStringForNumber:(NSNumber *)value {
    if (value != nil) {
        return [value stringValue];
    } else {
        return nil;
    }
}

@end
