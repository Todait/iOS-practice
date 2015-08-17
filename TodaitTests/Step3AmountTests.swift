//
//  Step3AmountTests.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest

class Step3AmountTests: XCTestCase {
   
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    let close = 0
    let green = 1
    let over = 2
    
    func dateCalulate(data:[Int],mask:[Int])->[Int]{
        
        var startOfWeek = data[8]
        var totalAmount = data[7]
        
        var calculateData:[Int] = [0,0,0,0,0,0,0]
        
        for var index = 0 ; index < 7 ; index++ {
            
            let arrayIndex = (index + startOfWeek)%7
            
            if mask[arrayIndex] == 1 {
                if totalAmount - data[arrayIndex] >= 0{
                    totalAmount -= data[arrayIndex]
                    calculateData[arrayIndex] = green
                }else{
                    calculateData[arrayIndex] = over
                }
            }else{
                calculateData[arrayIndex] = close
            }
        }
        
        return calculateData
    }
    
    func testDateCalculate(){
        
        
        var data = [200,20,30,40,50,60,290,360,4]
        var mask = [1,0,1,0,0,1,0]
      
        XCTAssertEqual(dateCalulate(data,mask:mask),[1,0,1,0,0,1,0],"")
        mask = [1,0,1,1,1,1,0]
        XCTAssertEqual(dateCalulate(data,mask:mask),[1,0,1,0,0,1,0],"")

        
    }
    
}
