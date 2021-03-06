//
//  QPLoginView.m
//  
//
//  Created by Nie on 2016/10/25.
//
//

#import "QPLoginView.h"
#import "TabBarController.h"

@interface QPLoginView ()<UITextFieldDelegate>
{
    UIImageView *accountImage;
    UIImageView *pwdImage;
    UIImageView *logoImage;
    UIImageView *inputImage;
    NSArray *allTextFields;
}
@property (nonatomic, strong) TabBarController *tabBarController;

@property (nonatomic, assign) CGRect defaultViewRect;

@end

@implementation QPLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
    }
    return self;
}

#pragma mark - configureSubViews
- (void)configureSubViews
{
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *color = [UIColor whiteColor];
    
    logoImage=[[UIImageView alloc] init];
    logoImage.frame = CGRectMake((SCREEN_WIDTH-284/2)/2,216/2 , 284/2, 164/2);
    logoImage.image = [UIImage imageNamed:@"logo.png"];
    [self addSubview:logoImage];
    
    accountImage=[[UIImageView alloc] init];
    accountImage.size = CGSizeMake(25, 25);
    accountImage.image = [UIImage imageNamed:@"user.png"];
    
    self.loginIdTextField = [[UITextField alloc] init];
    self.loginIdTextField.frame = CGRectMake(70,260, SCREEN_WIDTH-140, 25);
    self.loginIdTextField.font = font;
    self.loginIdTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.loginIdTextField.placeholder = @"请输入手机号";
    self.loginIdTextField.backgroundColor = color;
    self.loginIdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.loginIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.loginIdTextField.leftView = accountImage;
    self.loginIdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginIdTextField.delegate = self;
    [self addSubview:self.loginIdTextField];
    
    inputImage = [[UIImageView alloc] init];
    inputImage.frame = CGRectMake(self.loginIdTextField.x,self.loginIdTextField.bottom-0.5 ,self.loginIdTextField.width, 0.5);
    inputImage.image = [UIImage imageNamed:@"login_input.png"];
    [self addSubview:inputImage];
    
    pwdImage = [[UIImageView alloc] init];
    pwdImage.size = CGSizeMake(25, 25);
    pwdImage.image = [UIImage imageNamed:@"lock.png"];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.frame=CGRectMake(70,self.loginIdTextField.bottom+30, SCREEN_WIDTH-140,30);
    self.passwordTextField.font = font;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.backgroundColor = color;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.passwordTextField  setSecureTextEntry:YES];
    self.passwordTextField.leftView = pwdImage;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    [self addSubview:self.passwordTextField];
    
    inputImage = [[UIImageView alloc] init];
    inputImage.frame = CGRectMake(self.passwordTextField.x,self.passwordTextField.bottom-0.5 ,self.passwordTextField.width, 0.5);
    inputImage.image = [UIImage imageNamed:@"login_input.png"];
    [self addSubview:inputImage];
    
    UIButton *footBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.frame=CGRectMake(70, self.passwordTextField.bottom+30, SCREEN_WIDTH-140, 40);
    [footBtn setTitle:@"登录" forState:UIControlStateNormal];
    [footBtn setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [footBtn setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateHighlighted];
    [footBtn  addTarget:self action:@selector(performLoginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:footBtn];
    
    UIButton *forgetBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame=CGRectMake(100, footBtn.bottom+75, SCREEN_WIDTH-200, 30);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn  addTarget:self action:@selector(performForgotPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetBtn];
}

#pragma mark - ButtonAction
- (void)performLoginAction
{
    if (self.loginIdTextField.text.length == 0) {
        [[QPHUDManager sharedInstance]showTextOnly:@"手机号不能为空"];
        return;
    }
    
    if ( self.passwordTextField.text.length == 0) {
        [[QPHUDManager sharedInstance]showTextOnly:@"您还没有输入密码呢"];
        return;
    }
    
    [[QPHUDManager sharedInstance]showProgressWithText:@"登录中"];
    if ([self.loginIdTextField.text isEqualToString:@"15701189832"] &&
        [self.passwordTextField.text isEqualToString:@"123456"]) {
        [[QPHUDManager sharedInstance]hiddenHUD];
        [[QPHUDManager sharedInstance]showTextOnly:@"登录成功"];
        self.tabBarController = [[TabBarController alloc]init];
        self.window.rootViewController = self.tabBarController;
    } else {
        [[QPHUDManager sharedInstance]hiddenHUD];
        [[QPHUDManager sharedInstance]showTextOnly:@"手机号号或者密码错误"];
    }
    
 }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    CGRect rc = [self convertRect:textField.frame toView:window];
    NSLog(@"%f  %f",rc.origin.y, rc.size.height );
    [self updateViewFrame:rc];

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
  
    [self recoverViewFrame];

}

//忘记密码
- (void)performForgotPasswordAction
{
    [[QPHUDManager sharedInstance]showTextOnly:@"点击忘记密码"];
    
}

- (void)updateViewFrame:(CGRect)rect
{
    int y = rect.origin.y + rect.size.height + ([[UIScreen mainScreen] bounds].size.height > 480?30:0);
    int h = self.height - 260;
    int yh = y - h;
    if (yh > 0) {
        [UIView animateWithDuration:0.3 animations:^{
             self.y = self.y-yh;
        } completion:^(BOOL completion){
            
        }];
    }
    
}
- (void)recoverViewFrame
{
    [UIView animateWithDuration:0.3 animations:^{
         self.y = 64;
    } completion:^(BOOL completion){
        
    }];
}

@end
