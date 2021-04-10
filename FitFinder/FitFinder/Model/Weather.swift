//
//  Weather.swift
//  FitFinder
//
//  Created by Thunnathorne Synhiranakkrakul on 4/3/21.
//

import Foundation
import SQLite3

class Weather
{

    var temp: Float = 0
    var feels: Float = 0
    var id: Int = 0
    var humid: Float = 0
    var wind: Float = 0
    var time: String = ""
    var code:String = ""

    init(id:Int, temp:Float, feels:Float, humid:Float, wind:Float,code:String, time:String)
    {
        self.id = id
        self.temp = temp
        self.feels = feels
        self.humid = humid
        self.wind = wind
        self.code = code
        self.time = time
    }

}

class Qcount{
    var count:Int = 0
    var result:String = ""
    
    init(count:Int,result:String) {
        self.count = count
        self.result = result
    }
}


class DBweather
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "weatherDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            //print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }

    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS weather(Id INTEGER PRIMARY KEY,temp FLOAT,feels FLOAT,humid FLOAT,wind FLOAT,code TEXT,time TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("weather table created.")
            } else {
                print("weather table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }


    func insert(id:Int,temp:Float,feels:Float,humid:Float, wind:Float,code:String, time:String)
    {
        let weather = readall()
        for w in weather
        {
            if w.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO weather (id,temp,feels,humid,wind,code,time) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_double(insertStatement,2,Double(temp))
            sqlite3_bind_double(insertStatement,3,Double(feels))
            sqlite3_bind_double(insertStatement,4,Double(humid))
            sqlite3_bind_double(insertStatement,5,Double(temp))
            sqlite3_bind_text(insertStatement, 6, (code as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (time as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func query(queryStatementString:String) -> [Weather]{
        var queryStatement: OpaquePointer? = nil
        var psns : [Weather] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let temp = sqlite3_column_double(queryStatement,1)
                let feels = sqlite3_column_double(queryStatement,2)
                let humid = sqlite3_column_double(queryStatement,3)
                let wind = sqlite3_column_double(queryStatement,4)
                let code = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let time = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                
                psns.append(Weather(id: Int(id),temp:Float(temp),feels: Float(feels),humid:Float(humid), wind:Float(wind),code:code, time:time))
                //print("Query Result:")
                //print("\(id) | \(temp) | \(feels)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }

    func readall() -> [Weather] {
        let queryStatementString = "SELECT * FROM weather;"
        return query(queryStatementString: queryStatementString)
    }
    
    func queryfloat(queryStatementString:String) -> Float{
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_step(queryStatement)
            let result = sqlite3_column_double(queryStatement,0)
                return Float(result)
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return 0
    }
    
    func querycount(queryStatementString:String) -> [Qcount]{
        var queryStatement: OpaquePointer? = nil
        var results:[Qcount] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {

            while sqlite3_step(queryStatement) == SQLITE_ROW {
            let count = sqlite3_column_int(queryStatement, 0)
            let result = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                //print(count,result)
                results.append(Qcount(count: Int(count), result: result))
            }
                return results
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return results
    }
    
    func queryString(queryStatementString:String) -> String{
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_step(queryStatement)
            let result = sqlite3_column_double(queryStatement,0)
                return String(result)
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return ""
    }
    
    func queryStringArray(queryStatementString:String) -> [String]{
        var queryStatement: OpaquePointer? = nil
        var results : [String] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_step(queryStatement)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
            let result = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                results.append(result)
            }
                return results
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return results
    }
    
    func readman(Statement:String) -> [Weather]{
        return query(queryStatementString: Statement)
    }

    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM weather WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }

}
