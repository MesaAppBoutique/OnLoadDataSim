import Foundation
import UIKit

print("Start/n")

/*
    This playground simulates the steps for the ReachOut app to pull onLoad data from the back-end database server.

    It needs to pull the list of schools and the grades at each school...
        and also the list of topics to tag user tip submissions, and the code numbers associated with each tag.

    In principle, we're pulling results from the server RDS database in a JSON string.
    Then we parse that data into a dictionary structure used by the app.

    Since there was no back-end server online at the time of writing this code, this playground first defines a simulated database
        consisting of an array of structs.
    Then the playground encodes the struct array into JSON, simulating the response from the RDS server.
    Then the playground parses the JSON back into an array of structs that can be used by the app.

    In theory, most of this code could be transfered into the OnLoadData struct file in the ReachOutAZ Xcode project.

    Patrick Wheeler
    14 June 2022
    pat@ipat.dev
 */


/*
 MARK: 1 - First, I create a simulated database, simulating the RDS database to be hosted on AWS.
*/
// data structs on server RDS -------------------
struct schoolGrade : Codable {
    var schoolGradeID : Int
    var schoolName : String
    var gradeLevel : Int
}
struct issue : Codable {
    var issueID : Int
    var issueName : String
}

// create simulated server RDS ------------------
var schoolDB : [schoolGrade] = [
    schoolGrade(schoolGradeID: 0, schoolName: "Adams" , gradeLevel: 0),
    schoolGrade(schoolGradeID: 1, schoolName: "Adams" , gradeLevel: 1),
    schoolGrade(schoolGradeID: 2, schoolName: "Adams" , gradeLevel: 2),
    schoolGrade(schoolGradeID: 3, schoolName: "Adams" , gradeLevel: 3),
    schoolGrade(schoolGradeID: 4, schoolName: "Adams" , gradeLevel: 4),
    schoolGrade(schoolGradeID: 5, schoolName: "Adams" , gradeLevel: 5),
    schoolGrade(schoolGradeID: 6, schoolName: "Adams" , gradeLevel: 6),
    schoolGrade(schoolGradeID: 7, schoolName: "Brigthon" , gradeLevel: 0)
]

/*
    I can imagine this might not be the most efficient method,
        as it uses extra data for schoolGradeID, which is data
        that will only be thrown away once it reaches the app.
 */

// TODO - I did not yet create an array of issues
//     so none of the following three steps processes the simulated issues response either.


/*
 MARK: 2 - This section simulates the PHP on the backend, which would receive the query and produce a JSON string to send to the app.
*/
// convert to JSON string -----------------------
// this is borrowed from ConcernData struct in the ReachOutAZ app
var encodedData = Data()
do {
//            let jsonEncoder =
    encodedData = try JSONEncoder().encode(schoolDB)
    print(encodedData)
    let jsonString = String(data: encodedData, encoding: .utf8)
    print("Simulated received JSON encoded string: ")
    print(jsonString!)
} catch {
    print("JSON encoding failure.")
//    return false
}

                        // convert dictionary to string array
                        //var returnedArrayOfStrings : [String] = []

                        //schoolDB.count
                        //schoolDB[0].school
                        //schoolDB[0].grade
                        //
                        //schoolDB.forEach { school in
                        //    print(school)
                        //}

                        //for entry in schoolDB {
                        //    print(entry.school)
                        //    print(entry.grade)
                        //    returnedArrayOfStrings.append(entry.school)
                        //    returnedArrayOfStrings.append(entry.grade)
                        //}
                        //print(returnedArrayOfStrings)


/*
    MARK: 3 - Then the app receives the JSON from the backend and parses it into a local array.
 */
// convert 'received' json string back to dictionary in app ---------
// reference:  https://betterprogramming.pub/json-parsing-in-swift-2498099b78f
print("\n Receive and Parse:")
var model = [schoolGrade]()
do {
    let decoder = JSONDecoder()
    model = try decoder.decode([schoolGrade].self, from: encodedData)
    // model is an array of schoolGrades
    print("\nReceived model array:")
    print(model)
} catch let parsingError {
    print("\nError", parsingError)
}


/*
    MARK: 4 - The final step converts the simple array received from the backend and converts it to the dictionary form used by the app UI.
 */
// convert received array into proper dictionary --------------------
// create structure of school:[grades]
var schools = [
    "* Please Select Your School": ["And Your Grade"]
]
//  "Adams": ["Kindergarten", "1st", "2nd", "3rd", "4th", "5th", "6th"],

print("Model contains \(model.count) entries.")
print("Model item 0 is \(model[0].schoolName) grade \(model[0].gradeLevel).")

// iterate through the model
for entry in model {

    // creating a string value for grade from the integer value that the RDS would hold
    var gradeString: String
    switch entry.gradeLevel {
    case 0:  gradeString = "Kindergarten"
    case 1:  gradeString = "1st"
    case 2:  gradeString = "2nd"
    case 3:  gradeString = "3rd"
    case 4:  gradeString = "4th"
    case 5:  gradeString = "5th"
    case 6:  gradeString = "6th"
    case 7:  gradeString = "7th"
    case 8:  gradeString = "8th"
    case 9:  gradeString = "9th/Freshman"
    case 10: gradeString = "10th/Sophomore"
    case 11: gradeString = "11th/Junior"
    case 12: gradeString = "12th/Senior"
    default: gradeString = ""
    }
    print("\nSchool is \(entry.schoolName), grade is \(gradeString).")

    // this either adds a grade to a school already in our list, or adds the school to the list if not already present
    if schools[entry.schoolName] == nil {
        // means school is not in new dictionary, so we add it.
        print(" School \"\(entry.schoolName)\" is NOT currently in the new dictionary. So we add it.")
        schools[entry.schoolName] = [gradeString]
    } else {
        // else we only add a value to the string array for the existing key
        print(" School \(entry.schoolName) is already in the dictionary, so we just add the grade.")
        schools[entry.schoolName]?.append(gradeString)

        // TODO - technically, we should confirm that grade value does not already exist in string array before adding it.
    }
    print(" Dictionary key \"\(entry.schoolName)\" now contains grades \(schools[entry.schoolName]!)")
}


print("\nThe finished unsorted dictionary:")
print(schools)


print("Done.")

// TODO - we need to sort each grade string array for each key before we use it in the app UI.
/*      I believe I demonstrated that the order of the schools in the dictionary is not important,
        as the list of schools is sorted by the app when building the pickerView on the UI.
 */

// TODO - …repeat for topics(issues)

/*
    See the OnLoadData struct in the ReachOutAZ Xcode project for more information on the schools and issues data required by the app UI.
 */
