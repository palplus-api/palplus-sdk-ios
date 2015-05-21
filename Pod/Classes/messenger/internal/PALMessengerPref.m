#import "PALMessengerPref.h"
#import "PALAccessToken.h"

static NSString* const AccessTokenKey = @"PALAccessToken";

@implementation PALMessengerPref

+ (void) storeAccessToken:(PALAccessToken*) accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:accessToken]
                                              forKey:AccessTokenKey];
}

+ (PALAccessToken*) loadAccessToken
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenKey];
    if (!data)
    {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void) clearAccessToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AccessTokenKey];
}

+ (id) load:(NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+ (void) store:(NSString*) key value:(id) value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}


@end
