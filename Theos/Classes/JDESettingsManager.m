#import "JDESettingsManager.h"

#define suiteName "dev.extbh.jodelemproved"

@interface JDESettingsManager()
@property (strong, nonatomic) NSUserDefaults *tweakSettings;
@property (strong, nonatomic) NSArray<NSArray*> *features;
@property (strong, nonatomic) NSArray<NSNumber*> *featuresTags;
@end

@implementation JDESettingsManager
- (id) init{
    self = [super init];
    if (self != nil){
        _tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:@suiteName];
        _features = @[@[@"Save images", @"nil", @NO], @[@"Upload from gallery", @"iOS 14+ for now.", @NO], @[@"Location spoofer", @"nil", @NO],
                        @[@"Copy & Paste", @"Require restart to fully change.", @NO], @[@"Confirm votes", @"nil", @YES],
                        @[@"Confirm replies", @"nil", @YES], @[@"Screenshot protection", @"Disable screenshot notification.", @NO], @[@"Tracking protection", @"Stop analytics collection.", @YES],];
    }
    return self;
}
+ (JDESettingsManager *)sharedInstance{

    static JDESettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

    return sharedInstance;

}
- (NSUInteger)numberOfFeatures{ return _features.count; }
- (NSString*)featureNameForRow:(NSUInteger)row{ return [_features objectAtIndex:row][0]; }
- (NSString*)featureDescriptionForRow:(NSUInteger)row{ 
    NSString *tmp = [_features objectAtIndex:row][1];
    if([tmp isEqualToString:@"nil"]) {return nil;} return tmp; 
    }
- (NSNumber*)featureDisabledForRow:(NSUInteger)row{ return [_features objectAtIndex:row][2];}
- (NSNumber*)featureTagForRow:(NSUInteger)row{ return @(row); }
- (void)updateSpoofedLocationWith:(CLLocation*)newLocation { [_tweakSettings setObject:[NSString stringWithFormat:@"%f;%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] forKey:@"spoofed_location"]; }
- (NSString*)spoofedLocation { 
    if([_tweakSettings stringForKey:@"spoofed_location"]){
        return [_tweakSettings stringForKey:@"spoofed_location"];}
    return @"32.61603;44.02488"; }
- (BOOL)featureStateForTag:(NSUInteger)tag {return [_tweakSettings boolForKey:[@(tag) stringValue]]; }
- (BOOL)featureStateChangedTo:(BOOL)newState forTag:(NSUInteger)tag{ [_tweakSettings setBool:newState forKey:[@(tag) stringValue]]; return YES;}

@end