//
//  ViewController.m
//  HamburgMenu
//
//  Created by Ben on 15/1/16.
//  Copyright (c) 2015年 Tuniu. All rights reserved.
//

#import "ViewController.h"
#import "HamburgButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HamburgButton *button = [[HamburgButton alloc] initWithFrame:CGRectMake(133, 133, 54, 54)];
    [button addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggle:(id)sender
{
    HamburgButton *button = (HamburgButton *)sender;
    button.showMenu = !button.showMenu;
}

@end
