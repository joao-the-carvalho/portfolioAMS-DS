package com.example.appbasickotlin

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import android.database.sqlite.SQLiteOpenHelper

class ProductDatabaseHelper private constructor(context: Context) :
    SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            """
            CREATE TABLE $TABLE_NAME (
                $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COLUMN_NAME TEXT NOT NULL,
                $COLUMN_QUANTITY INTEGER NOT NULL,
                $COLUMN_DESCRIPTION TEXT
            );
            """.trimIndent()
        )
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
        db.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        db.execSQL("DROP TABLE IF EXISTS users")
        onCreate(db)
    }

    @Synchronized
    fun insertProduct(nome: String, quantidade: Int, descricao: String): Boolean {
        val values = ContentValues().apply {
            put(COLUMN_NAME, nome)
            put(COLUMN_QUANTITY, quantidade)
            put(COLUMN_DESCRIPTION, descricao.takeIf { it.isNotBlank() })
        }

        return tryInsert(values)
    }

    companion object {
        private const val DATABASE_NAME = "produtos.db"
        private const val DATABASE_VERSION = 2

        @Volatile
        private var instance: ProductDatabaseHelper? = null

        fun getInstance(context: Context): ProductDatabaseHelper =
            instance ?: synchronized(this) {
                instance ?: ProductDatabaseHelper(context.applicationContext).also {
                    instance = it
                }
            }

        const val TABLE_NAME = "produtos"
        const val COLUMN_ID = "id"
        const val COLUMN_NAME = "nome"
        const val COLUMN_QUANTITY = "quantidade"
        const val COLUMN_DESCRIPTION = "descricao"

    }

    private fun tryInsert(values: ContentValues, retryOnClosedDb: Boolean = true): Boolean {
        return try {
            val result = writableDatabase.insert(TABLE_NAME, null, values)
            result != -1L
        } catch (exception: IllegalStateException) {
            if (retryOnClosedDb && exception.message?.contains("closed", ignoreCase = true) == true) {
                close()
                tryInsert(values, retryOnClosedDb = false)
            } else {
                false
            }
        } catch (exception: SQLiteException) {
            false
        }
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
    fun getAllProducts(): List<Produto> {
        val produtos = mutableListOf<Produto>()
        val db = readableDatabase
        val cursor = db.rawQuery(
            "SELECT $COLUMN_ID, $COLUMN_NAME, $COLUMN_QUANTITY, $COLUMN_DESCRIPTION FROM $TABLE_NAME",
            null
        )

        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getInt(0)
                val nome = cursor.getString(1)
                val quantidade = cursor.getInt(2)
                val descricao = cursor.getString(3) ?: ""

                produtos.add(Produto(id, nome, quantidade, descricao))
            } while (cursor.moveToNext())
        }
        cursor.close()
        return produtos
    }

    fun updateProduct(id: Int, nome: String, quantidade: Int, descricao: String): Boolean {
        return try {
            val values = ContentValues().apply {
                put(COLUMN_NAME, nome)
                put(COLUMN_QUANTITY, quantidade)
                put(COLUMN_DESCRIPTION, descricao.takeIf { it.isNotBlank() })
            }

            val db = writableDatabase
            val rowsAffected = db.update(
                TABLE_NAME,
                values,
                "$COLUMN_ID = ?",
                arrayOf(id.toString())
            )
            rowsAffected > 0
        } catch (e: SQLiteException) {
            false
        }
    }

    fun deleteProduct(id: Int): Boolean {
        return try {
            val db = writableDatabase
            val rowsDeleted = db.delete(
                TABLE_NAME,
                "$COLUMN_ID = ?",
                arrayOf(id.toString())
            )
            rowsDeleted > 0
        } catch (e: SQLiteException) {
            false
        }
    }
}