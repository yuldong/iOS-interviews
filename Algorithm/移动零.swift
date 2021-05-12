func moveZeroes(_ nums: inout [Int]) {
    for i in 0..<nums.count {
        if nums[i] == 0 {
            let temp = nums[i]
            var j = i
            while j < nums.count - 1 {
                nums[j] = nums[j + 1]
                j = j + 1
            }
            nums[j] = temp
        }
    }
}