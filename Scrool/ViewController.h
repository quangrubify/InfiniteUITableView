//
//  ViewController.h
//  Scrool
//
//  Created by quang on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteTableView.h"

@interface ViewController : UIViewController<InfiniteTableViewDelegate>

{
    InfiniteTableView *scrollView;
    UITextField *text;
}

@end
