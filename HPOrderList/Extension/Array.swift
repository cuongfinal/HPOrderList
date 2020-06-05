//
//  Array.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

extension Array where Element: Hashable {
    
    private func diffIterativeBase<T1, T2>(_ first: [T1], _ second: [T2], with compare:(_ first: T1, _ second: T2) -> Bool, with compare2:(T2,T2) -> Bool) -> SequenceDiff<T1, T2> {
        if first.count == 0 {
            return SequenceDiff(inserted: second)
        }
        if second.count == 0 {
            return SequenceDiff(removed: first)
        }
        var common: [(T1, T2)] = []
        var removed: [T1] = []
        var inserted: [T2] = []
        var handledJ: [T2] = []
        outer: for i in first {
            for j in second {
                if compare(i, j) {
                    common.append((i, j))
                    handledJ.append(j)
                    continue outer
                }
            }
            removed.append(i)
        }
        for j in second {
            if handledJ.contains(where: { compare2($0, j)}) {
                continue
            }
            inserted.append(j)
        }
        return SequenceDiff(common: common, removed: removed, inserted: inserted)
    }
    
    public struct SequenceDiff<T1, T2> {
        public let common: [(T1, T2)]
        public let removed: [T1]
        public let inserted: [T2]
        public init(common: [(T1, T2)] = [], removed: [T1] = [], inserted: [T2] = []) {
            self.common = common
            self.removed = removed
            self.inserted = inserted
        }
    }
    
    public func diffIterative<T1, T2: Equatable>(_ first: [T1], _ second: [T2], with compare:(T1,T2) -> Bool) -> SequenceDiff<T1, T2> {
        return diffIterativeBase(first, second, with: compare, with: ==)
    }
    
    public func diffIterative<T1, T2: AnyObject>(_ first: [T1], _ second: [T2], with compare:(T1,T2) -> Bool) -> SequenceDiff<T1, T2> {
        return diffIterativeBase(first, second, with: compare, with: ===)
    }
    
    /*
    The common elements: Elements that are in both arrays.
    The inserted elements: Elements that are not in the first array, but are in the second array.
    The removed elements: Elements that are not in the second array, but are in the first array.
    */
    public func excuteArrayCompareInserted(second: [Element]) -> [Element]{
        return diffIterative(self, second, with: ==).inserted as [Element]
    }
    
    public func excuteArrayCompareRemoved(second: [Element]) -> [Element]{
        return diffIterative(self, second, with: ==).removed as [Element]
    }
    
    public func excuteArrayCompareUpdate(second: [Element]) -> [(Element,Element)]{
        return diffIterative(self, second, with: ==).common as [(Element,Element)]
    }
 
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}
