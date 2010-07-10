//
//  CRDataToObjectTransformer.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//


//////////////////////////////////////////////////////////////////////
// Value transformer, converts objects <-> NSData
//////////////////////////////////////////////////////////////////////
@interface CRDataToObjectTransformer : NSValueTransformer
{
}

+ (id)transformer;

@end