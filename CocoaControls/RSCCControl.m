//
//  RSCCControl.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCCControl.h"

@implementation RSCCControl

- initWithAssignment:(void (^)(RSCCControl *))assignment {

  return self = super.init ? !assignment ?: assignment(self) , self : nil;
}

- (NSString*) description {

    return [NSString stringWithFormat:@"[Title : %@] [License : %@] [Date : %@] [Image : %@] [Link : %@] [CocoaPods : %d] [Rating : %f] [Apps using this Control : %d] [Pod : %@] [Source : %@]",
    self.title, self.license, self.date, self.image, self.link, self.isOnCocoaPods, self.rating, self.appsUsingThisControl, self.pod, self.source];
}

@end
