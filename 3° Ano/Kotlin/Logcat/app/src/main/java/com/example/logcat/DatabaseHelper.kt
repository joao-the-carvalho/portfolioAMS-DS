package com.example.logcat

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) :
    SQLiteOpenHelper(context, "users.db", null, 2) {
    companion object {
        @Volatile
        private var instance: DatabaseHelper? = null

        fun getInstance(context: Context): DatabaseHelper {
            return instance ?: synchronized(this) {
                instance ?: DatabaseHelper(context.applicationContext).also {
                    instance = it
                }
            }
        }
    }

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            """
                CREATE TABLE users(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL
            );
            """.trimIndent()
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS users")
        onCreate(db)
    }
    override fun onDowngrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS users")
        onCreate(db)
    }
    fun authenticate(username: String, password: String): Boolean {
        val db = readableDatabase
        val cursor = db.rawQuery(
            "SELECT id FROM users WHERE username=? AND password=?",
            arrayOf(username, password)
        )

        val authenticated = cursor.count > 0
        cursor.close()
        return authenticated
    }
    fun create(username: String, email: String, password: String): Boolean {
        val db = readableDatabase
        val checkCursor = db.rawQuery(
            "SELECT 1 FROM users WHERE username=? OR email=? LIMIT 1",
            arrayOf(username, email)
        )
        val exists = checkCursor.count > 0
        checkCursor.close()

        if (exists) {
            return false
        }
        // metodo do SQLite que serve pra inserir na tabela
        return try {
            val values = ContentValues().apply {
                put("username", username)
                put("email", email)
                put("password", password)
            }

            val writeDb = writableDatabase
            val result = writeDb.insert("users", null, values)
            result != -1L
        } catch (e: SQLiteException) {
            false
        }
    }
}