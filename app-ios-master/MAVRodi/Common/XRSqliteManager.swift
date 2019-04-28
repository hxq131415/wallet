//
//  XRSqliteManager.swift
//  FriendOfFish
//
//  Created by rttx on 2018/7/20.
//  Copyright © 2018年 rttx. All rights reserved.
//

/**
 * Sqlite 数据库管理
 * 需要提供数据库版本迁移方案
 */

import UIKit
import Foundation
import FMDB
import ObjectMapper

private let MR_dataBaseFilePath: String = "/MR_autoFeedTask_v1_1.sqlite"
private let MR_feedTaskListTableName: String = "MR_autoFeedTaskList"

class XRSqliteManager: NSObject {
    
//    private var dbQueue: FMDatabaseQueue!
//
//    override init() {
//        super.init()
//
//        if let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
//            let sqliteFilePath = filePath.appending(MR_dataBaseFilePath)
//
//            self.dbQueue = FMDatabaseQueue(path: sqliteFilePath)
//
//            self.dbQueue.inDatabase { (db) in
//                do {
//                    let createTbSql = "create table if not exists \(MR_feedTaskListTableName)" +
//                    "(" +
//                    "p_id integer primary key autoincrement," +
//                    "time_str text," +
//                    "feed_num integer not null," +
//                    "is_open int not null" +
//                    ");"
//                    try db.executeUpdate(createTbSql, values: nil)
//                    Log(message: "数据表创建成功!")
//                    Log(message: "dataBase path--> \(sqliteFilePath)")
//                }
//                catch let err {
//                    TELog(message: "数据表创建失败! error-> \(err)")
//                }
//            }
//
//            dbQueue.close()
//        }
//    }
//
//    static func manager() -> XRSqliteManager {
//        return XRSqliteManager()
//    }
//
//    // MARK: - 数据库操作
//    // MARK: - 增加数据
//    func insertRecordIntoDB(feedTask: AutoFeedTaskInfoModel) {
//
//        self.queryRecordIsExists(feedTask: feedTask) { [weak self](isExists) in
//            if let weakSelf = self {
//                if isExists {
//                    Log(message: "记录已存在!")
//                }
//                else {
//                    let sql = "insert into \(MR_feedTaskListTableName) (time_str, feed_num, is_open) values (?,?,?);"
//
//                    weakSelf.dbQueue.inTransaction { (db, rollBack) in
//                        do {
//                            try db.executeUpdate(sql, values: [feedTask.timeStr ?? "", (feedTask.feedNumber), feedTask.isOpen])
//                            Log(message: "插入记录成功!")
//                        }
//                        catch let err {
//                            rollBack.pointee = true
//                            Log(message: "插入记录失败! error-> \(err.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - 删除数据
//    func deleteRecordFromDB(feedTask: AutoFeedTaskInfoModel) {
//
//        guard let timeStr_ = feedTask.timeStr else {
//            return
//        }
//
//        let sql = "delete from \(MR_feedTaskListTableName) where time_str = '\(timeStr_)';";
//
//        self.dbQueue.inTransaction { (db, rollBack) in
//            do {
//                try db.executeUpdate(sql, values: nil)
//                Log(message: "删除记录成功!")
//            }
//            catch let err {
//                rollBack.pointee = true
//                Log(message: "删除记录失败! error-> \(err.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - 更新数据
//    func updateRecordIntoDB(feedTask: AutoFeedTaskInfoModel) {
//
//        guard let timeStr_ = feedTask.timeStr else {
//            return
//        }
//
//        let sql = "update \(MR_feedTaskListTableName) set feed_num = ?, is_open = ? where time_str = '\(timeStr_)';"
//
//        self.dbQueue.inTransaction { (db, rollBack) in
//            do {
//                try db.executeUpdate(sql, values: [feedTask.feedNumber, feedTask.isOpen])
//                Log(message: "更新记录成功!")
//            }
//            catch let err {
//                rollBack.pointee = true
//                Log(message: "更新记录失败! error-> \(err.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - 查询数据
//    // 查询某条记录是否存在
//    func queryRecordIsExists(feedTask: AutoFeedTaskInfoModel, completeBlock: ((_ isExists: Bool) -> ())) {
//
//        guard let time_str = feedTask.timeStr else {
//            completeBlock(false)
//            return
//        }
//
//        let sql = "select \(1) from \(MR_feedTaskListTableName) where time_str = '\(time_str)' limit \(1);"
//
//        var isExists: Bool = false
//
//        dbQueue.inTransaction { (db, rollBack) in
//            do {
//                let rs = try db.executeQuery(sql, values: nil)
//                if rs.next() {
//                    isExists = true
//                }
//                else {
//                    isExists = false
//                }
//
//                rs.close()
//            }
//            catch let err {
//                Log(message: "查询失败! error-> \(err.localizedDescription)")
//                isExists = false
//            }
//        }
//
//        completeBlock(isExists)
//    }
//
//    // 查询表中所有记录
//    func queryAllRecordListFromDB(completeBlock: ((_ feedTaskList: [AutoFeedTaskInfoModel]) -> Swift.Void)) {
//
//        var recordList: [AutoFeedTaskInfoModel] = []
//
//        let sql = "select * from \(MR_feedTaskListTableName);";
//
//        self.dbQueue.inTransaction { (db, rollBack) in
//            do {
//                let rs = try db.executeQuery(sql, values: nil)
//                while rs.next() {
//                    let timeStr = rs.string(forColumn: "time_str")
//                    let feedNum = rs.int(forColumn: "feed_num")
//                    let isOpen = rs.bool(forColumn: "is_open")
//                    let feedTask = AutoFeedTaskInfoModel()
//                    feedTask.timeStr = timeStr
//                    feedTask.feedNumber = Int(feedNum)
//                    feedTask.isOpen = isOpen
//                    recordList.append(feedTask)
//                }
//
//                rs.close()
//                Log(message: "查询记录成功!")
//            }
//            catch let err {
//                Log(message: "查询记录失败! error-> \(err.localizedDescription)")
//            }
//
//            completeBlock(recordList)
//        }
//    }
//
//    /** 分页查询记录
//     *
//     * @param currentPage 查询的页数
//     * @param pageSize    查询每页的记录条数
//     * @param completeBlock 返回查询记录
//     */
//    func queryRecordListFromDB(currentPage: Int, pageSize: Int = 10, completeBlock: ((_ feedTaskList: [AutoFeedTaskInfoModel]) -> Swift.Void)) {
//
//        var curPage: Int = currentPage
//        if curPage < 1 {
//            curPage = 1
//        }
//
//        var recordList: [AutoFeedTaskInfoModel] = []
//
//        let sql = "select * from \(MR_feedTaskListTableName) order by p_id asc limit ?, ?;";
//
//        self.dbQueue.inTransaction { (db, rollBack) in
//            do {
//                let rs = try db.executeQuery(sql, values: [(currentPage - 1) * pageSize, pageSize])
//                while rs.next() {
//                    let p_id = rs.longLongInt(forColumn: "p_id")
//                    Log(message: "id-> \(p_id)")
//                    let timeStr = rs.string(forColumn: "time_str")
//                    let feedNum = rs.int(forColumn: "feed_num")
//                    let isOpen = rs.bool(forColumn: "is_open")
//                    let feedTask = AutoFeedTaskInfoModel()
//                    feedTask.timeStr = timeStr
//                    feedTask.feedNumber = Int(feedNum)
//                    feedTask.isOpen = isOpen
//                    recordList.append(feedTask)
//                }
//
//                rs.close()
//                Log(message: "查询记录成功!")
//            }
//            catch let err {
//                Log(message: "查询记录失败! error-> \(err.localizedDescription)")
//            }
//
//            completeBlock(recordList)
//        }
//    }
//
//    /** 查询记录
//     *
//     * @param  sql 查询条件
//     * @param  completeBlock 查询结果回调
//     * @note   [T] 数据模型需要遵守Mappable协议
//     *
//     * @return none
//     */
//    func queryRecordListFromTable<T: Mappable>(databaseFilePath: String, sql: String, completeBlock: (([T]) -> Swift.Void)) {
//
//        if sql.isEmpty {
//            completeBlock([])
//            return
//        }
//
//        var objectArr: [T] = []
//
//        self.dbQueue = FMDatabaseQueue(path: databaseFilePath)
//
//        self.dbQueue.inTransaction { (db, rollBack) in
//            do {
//                let rs = try db.executeQuery(sql, values: nil)
//                while rs.next() {
//                    if let dict = rs.resultDictionary as? [String: Any] {
//                        if let object = Mapper<T>().map(JSON: dict) {
//                            objectArr.append(object)
//                        }
//                    }
//                }
//
//                rs.close()
//                Log(message: "查询成功!")
//            }
//            catch let err {
//                Log(message: "查询失败! error-> \(err.localizedDescription)")
//            }
//        }
//
//        completeBlock(objectArr)
//    }
    
}
