import Foundation

final class SharedResource {
    
    private var data: [Int] = []
    func add(_ value: Int) {
        data.append(value)
    }
    func removeLast() {
        if !data.isEmpty {
            data.removeLast()
        } else {
            print("No elements to remove")
        }
    }
    func getData() -> [Int] {
        return data
    }
}

let addQueue = DispatchQueue(label: "addQueue", attributes: .concurrent)
let removeQueue = DispatchQueue(label: "removeQueue", attributes: .concurrent)

let group = DispatchGroup()

func perform() {
    let resource = SharedResource()
    for i in 1...1000 {
        group.enter()
        addQueue.sync { [resource] in
            resource.add(i)
            print("adds\(i)")
            group.leave()
        }
        group.enter()
        removeQueue.sync { [resource] in
            resource.removeLast()
            print("removesLast")
            group.leave()
        }
    }
    group.wait()
    print("fianl data: \(resource.getData())")
}

perform()


