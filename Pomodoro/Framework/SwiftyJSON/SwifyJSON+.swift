import Foundation

extension JSON {
    subscript(dynamicMember member: String) -> Int {
        self[member].intValue
    }
    
    subscript(dynamicMember member: String) -> String {
        self[member].stringValue
    }
    
    subscript(dynamicMember member: String) -> Double {
        self[member].doubleValue
    }
    
    subscript(dynamicMember member: String) -> Array<JSON> {
        self[member].arrayValue
    }
    
    subscript(dynamicMember member: String) -> Dictionary<String, JSON> {
        self[member].dictionaryValue
    }
    
    subscript(dynamicMember member: String) -> NSNumber {
        self[member].numberValue
    }
    
    subscript(dynamicMember member: String) -> Bool {
        self[member].boolValue
    }
    
    subscript(dynamicMember member: String) -> JSON {
        self[member]
    }
}
