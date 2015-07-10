//
//  MasksViewController.m
//  textfieldmasks
//
//  Created by Lucas Eduardo Schlögl on 08/07/15.
//  Copyright (c) 2015 Lucas Eduardo Schlögl. All rights reserved.
//

#import "MasksViewController.h"
#import "UIColor+PS.h"
#import "VMaskTextField.h"
#import "SHSPhoneTextField.h"
#import "UIFont+PS.h"

@interface MasksViewController ()
@property (nonatomic, strong) VMaskTextField *vmaskTextField;
@property (nonatomic, strong) SHSPhoneTextField *shsphoneTextField;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation MasksViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"f2f2f2"]];
    
    float width = self.view.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, width-20, 30)];
    [titleLabel setText:@"Máscaras Telefônicas:"];
    [titleLabel setFont:[UIFont avenirDemiWithSize:20.0f]];
    [titleLabel setTextColor:[UIColor colorFromHexString:@"e31c21"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    
    UILabel *vmaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 140, 40)];
    [vmaskLabel setText:@"VMaskTextField:"];
    [self configureLabel:vmaskLabel];
    [self.view addSubview:vmaskLabel];
    
    _vmaskTextField = [[VMaskTextField alloc] initWithFrame:CGRectMake(155, 90, width-165, 40)];
    [_vmaskTextField setDelegate:self];
    [_vmaskTextField setMask:@"(##) ####-#####"];
    [self configureTextField:_vmaskTextField];
    [self.view addSubview:_vmaskTextField];

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 140, width, 1)];
        [line2 setBackgroundColor:[UIColor colorFromHexString:@"bdbdc1" alpha:0.6f]];
        [self.view addSubview:line2];

    UILabel *shsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 140, 40)];
    [shsLabel setText:@"SHSPhoneTextField:"];
    [self configureLabel:shsLabel];
    [self.view addSubview:shsLabel];
    
    _shsphoneTextField = [[SHSPhoneTextField alloc] initWithFrame:CGRectMake(155, 150, width-165, 40)];
    [_shsphoneTextField setDelegate:self];
    [_shsphoneTextField.formatter setDefaultOutputPattern:@"(##) ####-#####"];
    [_shsphoneTextField.formatter addOutputPattern:@"(##) #####-####" forRegExp:@"\\d{11}"];
    [self configureTextField:_shsphoneTextField];
    [self.view addSubview:_shsphoneTextField];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 200, width, 1)];
        [line setBackgroundColor:[UIColor colorFromHexString:@"bdbdc1" alpha:0.6f]];
        [self.view addSubview:line];

    UILabel *regexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 140, 40)];
    [regexLabel setText:@"Nativo:"];
    [self configureLabel:regexLabel];
    [self.view addSubview:regexLabel];

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(155, 210, width-165, 40)];
    [_textField setDelegate:self];
    [self configureTextField:_textField];
    [self.view addSubview:_textField];

}

#pragma mark - Configure Field Methods

- (void) configureLabel:(UILabel *) label {
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont avenirRegularWithSize:14.0f]];
    [label setTextAlignment:NSTextAlignmentRight];
}

- (void) configureTextField:(UITextField *) textField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField.layer setBorderColor:[UIColor colorFromHexString:@"bdbdc1"].CGColor];
    [textField.layer setBorderWidth:1.0f];
    [textField.layer setCornerRadius:3.0f];
    [textField setPlaceholder:@"(__) ____-_____"];
}

#pragma mark - TextField Methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _vmaskTextField) {
       
        NSString *stripppedNumber = [_vmaskTextField.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [_vmaskTextField.text length])];

        
        if(range.length > 0 && [stripppedNumber length] >= 10) {
            [_vmaskTextField setMask:@"(##) ####-#####"];
            stripppedNumber = [stripppedNumber stringByReplacingOccurrencesOfString:@"(\\d{2})(\\d{4})(\\d+)"
                                                                         withString:@"($1) $2-$3"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, [stripppedNumber length])];
            
            [_vmaskTextField setText:stripppedNumber];
        } else if([stripppedNumber length] >= 10) {
            [_vmaskTextField setMask:@"(##) #####-####"];

            stripppedNumber = [stripppedNumber stringByReplacingOccurrencesOfString:@"(\\d{2})(\\d{5})(\\d+)"
                                                                   withString:@"($1) $2-$3"
                                                                      options:NSRegularExpressionSearch
                                                                        range:NSMakeRange(0, [stripppedNumber length])];
            
            [_vmaskTextField setText:stripppedNumber];

        }
        
        VMaskTextField *maskTextField = (VMaskTextField *)textField;
        return [maskTextField shouldChangeCharactersInRange:range replacementString:string];
        

    }
    
    if(textField == _textField) {
        
    
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        BOOL deleting = [newText length] < [textField.text length];
        
        NSString *stripppedNumber = [newText stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [newText length])];
        NSUInteger digits = [stripppedNumber length];
        
        if (digits > 11)
            stripppedNumber = [stripppedNumber substringToIndex:11];
        
        UITextRange *selectedRange = [textField selectedTextRange];
        NSInteger oldLength = [textField.text length];
        
        if (digits == 0)
            textField.text = @"";
        else if (digits < 2 || (digits == 2 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@", stripppedNumber];
        else if (digits < 7 || (digits == 7 && deleting))
            textField.text = [NSString stringWithFormat:@"(%@) %@", [stripppedNumber substringToIndex:2], [stripppedNumber substringFromIndex:2]];
        else if(digits >= 11)
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", [stripppedNumber substringToIndex:2], [stripppedNumber substringWithRange:NSMakeRange(2, 5)], [stripppedNumber substringFromIndex:7]];
        else
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", [stripppedNumber substringToIndex:2], [stripppedNumber substringWithRange:NSMakeRange(2, 4)], [stripppedNumber substringFromIndex:6]];
        
        UITextPosition *newPosition = [textField positionFromPosition:selectedRange.start offset:[textField.text length] - oldLength];
        UITextRange *newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        [textField setSelectedTextRange:newRange];
        
        
        return NO;

        
    }
    
    
    return YES;
}

@end
