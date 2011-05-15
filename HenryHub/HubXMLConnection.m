//
//  XMLView.m
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HubXMLConnection.h"
#import "TBXML.h"
#import "HubPiece.h"


@implementation HubXMLConnection

// VARS
@synthesize pieceXML=_pieceXML, receivedData=_receivedData, stringXML=_stringXML;

- (BOOL)connect:(NSString *)idString
{
    // Creating the request
    NSURLRequest *theRequest = [NSURLRequest 
                                requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://hub.henryart.org/index.php/app/hubpiece/%@", idString]]
                                cachePolicy: NSURLRequestUseProtocolCachePolicy
                                timeoutInterval: 60.0];
    
    // Creating connection + loading data
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(theConnection) // 'connection' would return nil if connection failed
    {
        NSLog(@"Connection established.");
        self.receivedData = [[NSMutableData alloc] retain];
        [theConnection release];
        //[theRequest release];
        return TRUE;
    }
    else 
    {
        NSLog(@"Connection failed.");
        [theConnection release];
        //[theRequest release];
    }
    return FALSE;
}

/*      NSURLConnection delegate methods : START      */

// The following are delegate methods for NSURLConnection. Similar to callback 
// functions, this is how the connection object, which is working in the 
// background, can asynchronously communicate back to its delegate on the thread
// from which it was started - in this case, the main thread.
//

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response received");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Data received");
    // Add data to our NSMutableData instance variable
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Report NSError sent
    NSLog(@"Failed with error: %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [connection release];
    [self.receivedData release];    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished loading. Received %d  bytes of data", [self.receivedData length]);
    
    // All data loaded now do something with it.
    self.stringXML = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    // Notify any observers about this having finished loading
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HubXMLLoaded" object:nil];
}

/*      NSURLConnection delegate methods : END        */

- (void)dealloc
{
    // Release instance variables here
    [self.pieceXML release];
    [self.receivedData release];
    
    [super dealloc];
}

@end


