//
//  main.swift
//  BasicAlgorithm
//
//  Created by yulidong on 2021/5/11.
//

import Foundation

func moveZeroes(_ nums: inout [Int]) {
    var left = 0
    var right = 0
    while right < nums.count {
        if nums[right] != 0 {
            nums.swapAt(left, right)
            left = left + 1
        }
        right = right + 1
    }
}

var nums = [1, 0, 3, 12, 0]

moveZeroes(&nums)
print(nums)
