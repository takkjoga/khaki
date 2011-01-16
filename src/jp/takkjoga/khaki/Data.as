package jp.takkjoga.khaki
{

import flash.data.*; 
import flash.events.SQLErrorEvent; 
import flash.events.SQLEvent; 
import flash.filesystem.File; 
import flash.errors.*;

public class Data
{
    private static const DATABASE_FILE_NAME:String = "jp.takkjoga.khaki.db";
    
    private var connection:SQLConnection = new SQLConnection(); 

    // インスタンス
    private static var _instance:Data = null;
    // クラス内の呼び出しフラグ
    private static var isInternally:Boolean = false;

    /**
     * Singleton パターン
     */
    public function Data():void
    {
        if (isInternally) {
            // クラス内からの呼び出しならフラグを戻す
            isInternally = false;
            this._createSqlConnection();
        } else {
            // フラグが内部呼出しを示さなければ
            // エラーをthrow
            throw new IllegalOperationError("Use Data.instance to get the instance");
        }
    }

    /**
     * インスタンスを返す
     */
    public static function get instance():Data
    {
        if (Data._instance == null) {
            // クラス内呼び出しを表す
            isInternally = true;
            // インスタンスを生成
            _instance = new Data();
        }
        // 格納されたインスタンスを返す
        return _instance;
    }

    private function _createSqlConnection():void
    {
        var databaseFile:File = File.applicationStorageDirectory.resolvePath(DATABASE_FILE_NAME); 
        try { 
            connection.open(databaseFile); 
            trace("the database was created successfully"); 
            this._createTables();
        } 
        catch (error:SQLError) { 
            trace("Error message:", error.message); 
            trace("Details:", error.details); 
        } 
    }

    private function _createTables():void
    {
        var statement:SQLStatement = new SQLStatement(); 
        statement.sqlConnection = this.connection; 
        var sql:String =  
            "CREATE TABLE IF NOT EXISTS Class (" +  
            "    id INTEGER PRIMARY KEY AUTOINCREMENT, " +  
            "    name TEXT, " +  
            "    x INTEGER, " +  
            "    y INTEGER" +  
            ")"; 
        statement.text = sql; 
        try { 
            statement.execute(); 
            trace("Table created"); 
        } 
        catch (error:SQLError) { 
            trace("Error message:", error.message); 
            trace("Details:", error.details); 
        } 
    }

    public function query(statementString:String, statementParameters:Array):Array
    {
        var statement:SQLStatement = new SQLStatement(); 
        statement.sqlConnection = this.connection; 

        statement.text = statementString;
        for (var i:int = 0; i < statementParameters.length; i ++) {
            statement.parameters[i] = statementParameters[i];
        }
        try { 
            statement.execute(); 
            trace("query completed"); 
            var result:SQLResult = statement.getResult();
            return result.data;
        } 
        catch (error:SQLError) { 
            trace("Error message:", error.message); 
            trace("Details:", error.details); 
        } 
        return [];
    }
}
}
