//
//  ViewController.m
//  CalculatorDemo
//
//  Created by Podul on 2018/1/8.
//  Copyright © 2018年 Podul. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"


static NSString *_strResult = @"0";         ///< 用来储存结果

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClick:(UIButton *)sender {
    _lblResult.text = [Calculator.sharedInstance caluculator:sender.titleLabel.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
