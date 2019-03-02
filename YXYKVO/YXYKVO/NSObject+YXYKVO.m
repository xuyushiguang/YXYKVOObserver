

#import "NSObject+YXYKVO.h"
#include <objc/runtime.h>

@interface _YXYObserverInfo : NSObject

@property (nonatomic,weak)id observer;
@property (nonatomic,copy)NSString *keyPath;
@property (nonatomic,copy)void(^block)(id change);
@end

@implementation _YXYObserverInfo

-(instancetype)initWithObserver:(id)observer withKeyPath:(NSString*)keyPath withBlock:(void(^)(id change))block
{
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath = [keyPath copy];
        self.block = [block copy];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.block(change);
}

@end




@implementation NSObject (YXYKVO)
static void *const YXYMapTable = "YXYMapTable";


-(void)yxy_addObserver:(id)observer forKeyPath:(NSString*)keyPath forBlock:(void(^)(id change))block
{
    NSMapTable *observerMap = (NSMapTable*)objc_getAssociatedObject(self, YXYMapTable);
    if (!observerMap) {
        observerMap = [NSMapTable new];
        objc_setAssociatedObject(self, YXYMapTable, observerMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSMapTable *mapInfo = [observerMap objectForKey:observer];
    if (!mapInfo) {
        mapInfo = [NSMapTable new];
        [observerMap setObject:mapInfo forKey:observer];
    }
    
    _YXYObserverInfo *info = [mapInfo objectForKey:keyPath];
    if (info) {
        [self yxy_removeObserver:observer forKeyPath:keyPath];
    }
    info = [[_YXYObserverInfo alloc] initWithObserver:observer withKeyPath:keyPath withBlock:block];
    [observer addObserver:info forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [mapInfo setObject:info forKey:keyPath];
}

-(void)yxy_removeObserver:(id)observer forKeyPath:(NSString*)keyPath
{
    NSMapTable *observerMap = (NSMapTable *)objc_getAssociatedObject(self, YXYMapTable);
    if (!observerMap) {
        return;
    }
    NSMapTable *mapInfo = [observerMap objectForKey:observer];
    if (!mapInfo) {
        return;
    }
    
    _YXYObserverInfo *info = [mapInfo objectForKey:keyPath];
    if (!info) {return;}
    [observer removeObserver:info forKeyPath:keyPath context:nil];
    [mapInfo removeObjectForKey:keyPath];
    if (mapInfo.count<=0) {
        [observerMap removeObjectForKey:observer];
    }
}









@end
