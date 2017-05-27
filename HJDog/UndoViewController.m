//
//  UndoViewController.m
//  HJDog
//
//  Created by whj on 2017/5/27.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "UndoViewController.h"

@interface UndoViewController () {

    NSUndoManager *undoManager;
    
    NSUInteger index;
}

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation UndoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initUndoManager];
    [self p_addObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self p_cleanObserver];
}

- (void)p_initUndoManager {

    undoManager = [[NSUndoManager alloc] init];
    undoManager.levelsOfUndo = 99;
}

#pragma mark - OverWrite 

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    if (!methodSignature) {
        
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    
    NSLog(@"%s", __func__);
    
    return methodSignature;
}

#pragma mark - Notifications

- (void)p_addObserver {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_undoDidChange:) name:NSUndoManagerDidUndoChangeNotification object:undoManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_redoDidChange:) name:NSUndoManagerDidRedoChangeNotification object:undoManager];
}

- (void)p_cleanObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:undoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:undoManager];
}

#pragma mark - Actions

- (IBAction)registerButtonAction:(id)sender {
    
    index++;
    [self p_registerSetInputTextField:[@(index) description]];
}

- (IBAction)perareButtonAction:(id)sender {
    
    index++;
    [self p_registerSetInputTextField:[@(index) description]];
}

- (IBAction)undoButtonAction:(id)sender {

    [undoManager undo];
}

- (IBAction)redoButtonAction:(id)sender {
    
    [undoManager redo];
}

- (void)p_registerSetInputTextField:(NSString *)text {

    if (self.inputTextField.text != text) {
        
        [undoManager registerUndoWithTarget:self selector:@selector(p_preareSetInputTextField:) object:self.inputTextField.text];
        self.inputTextField.text = text;
    }
}

- (void)p_preareSetInputTextField:(NSString *)text {
    
    if (self.inputTextField.text != text) {
        
        [[undoManager prepareWithInvocationTarget:self] p_preareSetInputTextField:self.inputTextField.text];
        self.inputTextField.text = text;
    }
}

- (void)p_undoDidChange:(NSNotification *)aNotification {
    
    NSLog(@"%s", __func__);
}

- (void)p_redoDidChange:(NSNotification *)aNotification {
    
    NSLog(@"%s", __func__);
}


@end
