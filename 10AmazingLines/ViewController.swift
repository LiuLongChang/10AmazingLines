//
//  ViewController.swift
//  10AmazingLines
//
//  Created by langyue on 16/5/3.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit

import AEXML


extension SequenceType{
    
    
    typealias Element = Self.Generator.Element
    func partitionBy(fu: (Element)->Bool) -> ([Element],[Element]) {
        
        var first = [Element]()
        var second = [Element]()
        for el in self {
            
            if fu(el) {
                first.append(el)
            }else{
                second.append(el)
            }
            
        }
        return (first,second)
    }
    
}


extension SequenceType{
    
    func anotherPartitionBy(fu: (Self.Generator.Element)->Bool) -> ([Self.Generator.Element],[Self.Generator.Element]) {
        return (self.filter(fu),self.filter({!fu($0)}))
    }
    
}




extension Array {
    public func pmap(transform: (Element -> Element)) -> [Element] {
        guard !self.isEmpty else {
            return []
        }
        
        var result: [(Int, [Element])] = []
        
        let group = dispatch_group_create()
        let lock = dispatch_queue_create("pmap queue for result", DISPATCH_QUEUE_SERIAL)
        
        let step: Int = max(1, self.count / NSProcessInfo.processInfo().activeProcessorCount) // step can never be 0
        
        
        
        for  stepIndex in 0...self.count {
            
            let capturedStepIndex = stepIndex
            
            var stepResult: [Element] = []
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for i in (capturedStepIndex * step)..<((capturedStepIndex + 1) * step) {
                    if i < self.count {
                        let mappedElement = transform(self[i])
                        stepResult += [mappedElement]
                    }
                }
                
                dispatch_group_async(group, lock) {
                    result += [(capturedStepIndex, stepResult)]
                }
            }
            
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        return result.sort { $0.0 < $1.0 }.flatMap { $0.1 }
    }
    
}






class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //1 数组中的每个元素乘以2
        let n = (1...1024).map{$0 * 2}
        print("(1...1024)每个元素乘以2为:  \(n)")
        
        
        
        
        //2 数组中的元素求和
        let sum = (1...100).reduce(0, combine: +)
        print("1到100求和为:  \(sum)")
        
        
        
        
        //3 验证在字符串中是否存在指定单词
        let words = ["Swift","iOS","cocoa","OSX","tvOS"]
        let tweet = "This is an example tweet larking about Swift"
        let valid =  !words.filter({tweet.containsString($0)}).isEmpty
        
        
        //4 读取文件
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "txt")
        let lines = try? String(contentsOfFile: path!).characters.split{$0 == "\n"}.map(String.init)
        if let lines=lines {
            
            lines[0]
            lines[1]
            lines[2]
            lines[3]
            
        }
        
        
        
        //5 祝你生日快乐！
        let name = "uraimo"
        (1...4).forEach{print("Happy Birthday" + (($0 == 3) ? "dear \(name)":"to You"))}
        
        
        
        
        //6 过滤数组中的数字
        let part = [82,58,76,49,88,90].partitionBy{$0 < 60}
        
        let part2 = [82,58,76,49,88,90].anotherPartitionBy{$0 < 60}
        
        
        
        //7 获取并解析XML服务
        let xmlDoc = try? AEXMLDocument(xmlData: NSData(contentsOfURL: NSURL(string: "https://www.ibiblio.org/xml/examples/shakespeare/hen_v.xml")!)!)
        if let xmlDoc=xmlDoc {
            
            var prologue = xmlDoc.root.children[6]["PROLOGUE"]["SPEECH"]
            prologue.children[1].stringValue
            prologue.children[2].stringValue
            prologue.children[3].stringValue
            prologue.children[4].stringValue
            prologue.children[5].stringValue
            
        }
        
        
        //8 在数组中查找最小和最大值
        //Find the minum of an array of Ints
        [10,-22,753,55,137,-1,-279,1034,77].sort().first
        [10,-22,753,55,137,-1,-279,1034,77].reduce(Int.max, combine: min)
        [10,-22,753,55,137,-1,-279,1034,77].minElement()
        
        
        
        //Find the maximum of an array of Ints
        [10,-22,753,55,137,-1,-279,1034,77].sort().last
        [10,-22,753,55,137,-1,-279,1034,77].reduce(Int.min, combine: max)
        [10,-22,753,55,137,-1,-279,1034,77].maxElement()
        
        
        
        //9 并行处理
        //某些语言允许用一种简单和透明的方式启用数组对功能，例如map和flatMap的并行处理，以加快顺序和独立操作的执行。
        
        //此功能Swift中还不可用，但可以使用GCD构建：http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html
        
        
        
        
        
        //10 埃拉托斯尼特尼筛法   用于查找所有的素数直到给定的上限n。
        var nc = 50
        var sameprimes = Set(2...nc)
        sameprimes.subtractInPlace((2...Int(sqrt(Double(nc))))
            .flatMap{ (2*$0).stride(through:nc, by:$0)})
        sameprimes.sort()
        
        
        
        
        
        
        // 11 通过结构元祖交换
        var a = 1,b = 2
        (a,b) = (b,a)
        
        
        
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

