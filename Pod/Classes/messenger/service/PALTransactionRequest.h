#import <Foundation/Foundation.h>

@interface PALTransactionRequest : NSObject

@property (nonatomic, readonly, copy) NSString* purchaseId;
@property (nonatomic, readonly, copy) NSString* itemName;
@property (nonatomic, readonly, copy) NSString* currency;
@property (nonatomic, readonly, copy) NSDecimalNumber* price;
@property (nonatomic, readonly, strong) NSDate* purchaseDate;
@property (nonatomic, readonly, strong) NSDictionary* extra;

//- (instancetype) initWithPurchaseId:(NSString*) purchaseId itemName:(NSString*) itemName currency:(NSString*) currency price:(NSDecimalNumber*) price purchaseDate:(NSDate*) purchaseDate extra:(NSDictionary*) extra;

- (NSData*) toJson;

+ (PALTransactionRequest*) create:(NSString*) purchaseId
                         itemName:(NSString*) itemName
                         currency:(NSString*) currency
                            price:(NSDecimalNumber*) price
                     purchaseDate:(NSDate*) purchaseDate
                            extra:(NSDictionary*) extra;
@end
