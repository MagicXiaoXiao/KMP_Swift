//
//  main.swift
//  KMP_Swift
//
//  Created by 漫不经心的魔导师 on 2019/3/16.
//  Copyright © 2019年 卡塞尔学院. All rights reserved.
//

import Foundation


/// 构造相同前后缀个数表
///
/// - Parameters:
///   - pattern: 需匹配的字符串
///   - count: 字符串长度
/// - Returns: [Int]
func prefix_table(pattern:String, count: Int) -> [Int] {
    
    var patternCharList = Array(pattern) //将字符串转换为字符数组
    var prefix_table = Array<Int>(repeating: 0, count: count) //创建前缀表
    prefix_table[0] = 0 //将首位相同前缀数标记设为0 （第一位无相同前缀数）
    var len: Int = 0 //字符数组索引
    var i: Int = 1 //前缀表索引（从1开始因为第0个已被标记为0）
    
    while i < count {
        if patternCharList[i] == patternCharList[len] { //后元素比较前1个元素相等情况
            len += 1
            prefix_table[i] = len //将自增后的索引赋值
            i += 1
        }else { //不相等情况
            if len > 0 { //判断不是第一个元素
                len = prefix_table[len - 1]
            }else { //判断是第一个元素的情况
                prefix_table[i] = len //直接将0（当前len = 0, i = 1）赋值到第二个元素（第一个元素初始时就已经确定是0）
                i += 1
            }
        }
    }
    
    prefix_table.insert(-1, at: 0) //将-1插入第一位元素
    _ = prefix_table.popLast() //将最后位元素移除/推出(由于popLast有返回值，我们又不需要使用，所以用 _ 接收)
    
    return prefix_table
}


/// kmp搜索匹配字符串
///
/// - Parameters:
///   - text: 文本
///   - pattern: 需匹配的字符串
/// - Returns: 返回索引值（返回-1则没有找到）
func kmp_search(text: String, pattern: String) -> Int {
    let textC = Array(text)
    let patternC = Array(pattern)
    let prefixTable = prefix_table(pattern: pattern, count: pattern.count) //获取相同前后缀数表
    
    let n = pattern.count //需匹配的字符串长度
    let m = text.count //文本长度
    var i: Int = 0,j: Int = 0 //i为文本的索引，j为匹配字符串的索引
    
    while i < m { //遍历文本
        if j == n - 1 && textC[i] == patternC[j] { //如果j索引到达匹配字符串尾部并且文本索引的元素和匹配字符串的元素相等的话。
            return i - j //已找到对应字符串，返回第一个匹配索引
//            j = prefixTable[j] //需要继续匹配则取消注释它并删除上面return
        }
        
        if textC[i] == patternC[j] { //判断俩索引元素是否相等
            i += 1; j += 1 //是则将索引往后移，用以继续查找
        }else {
            j = prefixTable[j] //不是则将z字符匹配索引指向对应的相同前后缀数表的元素
            if j == -1 { //如果指向的是 -1 元素
                i += 1; j += 1 //则整体都向后移1位
            }
        }
    }
    return -1 //循环结束还没查找到则返回-1
}

//用例
let parrern = "abc"
let text = "klsajksbc"

let index = kmp_search(text: text, pattern: parrern)

print(index)
