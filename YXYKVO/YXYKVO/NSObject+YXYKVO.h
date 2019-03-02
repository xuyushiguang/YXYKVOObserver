

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YXYKVO)

-(void)yxy_addObserver:(id)observer forKeyPath:(NSString*)keyPath forBlock:(void(^)(id change))block;

-(void)yxy_removeObserver:(id)observer forKeyPath:(NSString*)keyPath;

@end

NS_ASSUME_NONNULL_END
