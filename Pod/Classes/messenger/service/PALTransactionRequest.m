#import "PALTransactionRequest.h"
#import "NSDictionary+PAL.h"

@implementation PALTransactionRequest

- (instancetype) initWithPurchaseId:(NSString*) purchaseId
                           itemName:(NSString*) itemName
                           currency:(NSString*) currency
                              price:(NSDecimalNumber*) price
                       purchaseDate:(NSDate*) purchaseDate
                              extra:(NSDictionary*) extra {
  self = [super init];
  if (self) {
    _purchaseId = purchaseId;
    _itemName = itemName;
    _currency = currency;
    _price = price;
    _purchaseDate = purchaseDate;
    _extra = extra;
  }

  return self;
}

- (NSData*) toJson {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  dictionary[@"purchase_id"] = self.purchaseId;
  dictionary[@"item_name"] = self.itemName;
  dictionary[@"currency"] = self.currency;
  dictionary[@"price"] = self.price.stringValue;
  dictionary[@"purchase_date"] = [self convertDateToString:self.purchaseDate];
  if (self.extra) {
    dictionary[@"extra"] = self.extra;
  }
  return [dictionary pal_JSONData];
}

- (NSString*) convertDateToString:(NSDate*) date {
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

  return [formatter stringFromDate:date];
}

+ (PALTransactionRequest*) create:(NSString*) purchaseId
                         itemName:(NSString*) itemName
                         currency:(NSString*) currency
                            price:(NSDecimalNumber*) price
                     purchaseDate:(NSDate*) purchaseDate
                            extra:(NSDictionary*) extra {
  return [[PALTransactionRequest alloc]
      initWithPurchaseId:purchaseId
                itemName:itemName
                currency:currency
                   price:price
            purchaseDate:purchaseDate
                   extra:extra];

}

@end
