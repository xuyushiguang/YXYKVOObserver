

#import "YXYKVOObserver.h"

@interface _ObserverInfo : NSObject

@property (nonatomic,weak)id observer;
@property (nonatomic,copy)NSString *keyPath;
@property (nonatomic,copy)void(^block)(id change);
@end

@implementation _ObserverInfo

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


@interface YXYKVOObserver()
@property(nonatomic,strong)NSMapTable *observerMap;
@end


@implementation YXYKVOObserver
- (NSMapTable *)observerMap
{
    if (!_observerMap) {
        _observerMap = [NSMapTable new];
    }
    return _observerMap;
}

-(void)yxy_addObserver:(id)observer withKeyPath:(NSString*)keyPath withBlock:(void(^)(id change))block
{
    NSMapTable *mapInfo = [self.observerMap objectForKey:observer];
    if (!mapInfo) {
        mapInfo = [NSMapTable new];
        [self.observerMap setObject:mapInfo forKey:observer];
    }

    _ObserverInfo *info = [mapInfo objectForKey:keyPath];
    if (info) {
        [self yxy_removeObserver:observer withKeyPath:keyPath];
    }
    info = [[_ObserverInfo alloc] initWithObserver:observer withKeyPath:keyPath withBlock:block];
    [observer addObserver:info forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [mapInfo setObject:info forKey:keyPath];
}

-(void)yxy_removeObserver:(id)observer withKeyPath:(NSString*)keyPath
{
    NSMapTable *mapInfo = [self.observerMap objectForKey:observer];
    if (!mapInfo) {
        return;
    }

    _ObserverInfo *info = [mapInfo objectForKey:keyPath];
    if (!info) {return;}
    [observer removeObserver:info forKeyPath:keyPath context:nil];
    [mapInfo removeObjectForKey:keyPath];
    if (mapInfo.count<=0) {
        [self.observerMap removeObjectForKey:observer];
    }
}














@end
