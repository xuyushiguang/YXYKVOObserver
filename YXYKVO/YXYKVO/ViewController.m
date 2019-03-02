

#import "ViewController.h"
#import "YXYKVOObserver.h"
#import "NSObject+YXYKVO.h"
#import "Model.h"
@interface ViewController ()
{
    YXYKVOObserver *_kvo;
    Model *_m;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(100, 100, 100, 50);
    [bt setTitle:@"button" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(actionForButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    _m = [Model new];
    _m.name = @"123";
    
    [self yxy_addObserver:_m forKeyPath:@"name" forBlock:^(id  _Nonnull change) {
        NSLog(@"self  new = %@",change[NSKeyValueChangeNewKey]);
    }];
    
    _kvo = [YXYKVOObserver new];
    [_kvo yxy_addObserver:_m forKeyPath:@"name" forBlock:^(id  _Nonnull change) {
        NSLog(@"_kvo new = %@",change[NSKeyValueChangeNewKey]);
    }];
    
}

-(void)actionForButton
{
    _m.name = @"qwe";
}


@end
