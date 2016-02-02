//
//  AddressAnnotation.h
//  Veux
//
//  Created by mac on 10/29/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
@end
