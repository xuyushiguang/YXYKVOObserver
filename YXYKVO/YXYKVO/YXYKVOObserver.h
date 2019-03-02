

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXYKVOObserver : NSObject


-(void)yxy_addObserver:(id)observer withKeyPath:(NSString*)keyPath withBlock:(void(^)(id change))block;

-(void)yxy_removeObserver:(id)observer withKeyPath:(NSString*)keyPath;



@end

NS_ASSUME_NONNULL_END
