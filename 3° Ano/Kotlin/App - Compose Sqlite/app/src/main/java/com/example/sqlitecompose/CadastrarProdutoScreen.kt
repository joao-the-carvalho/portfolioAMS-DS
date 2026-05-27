package com.example.sqlitecompose

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.sqlitecompose.UserDatabaseHelper

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CadastrarProdutoScreen(
    onRegisterComplete: () -> Unit,
    onBack: () -> Unit,
    dbHelper: UserDatabaseHelper
) {
    val context = LocalContext.current

    var produto by rememberSaveable { mutableStateOf("") }
    var quantidade by rememberSaveable { mutableStateOf("") }
    var descricao by rememberSaveable { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }

    // Erros de validação por campo
    var erroproduto by remember { mutableStateOf<String?>(null) }
    var erroQuantidade by remember { mutableStateOf<String?>(null) }

    val gradient = Brush.verticalGradient(
        colors = listOf(
            MaterialTheme.colorScheme.primary,
            MaterialTheme.colorScheme.primaryContainer
        )
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Cadastrar Produto") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "Voltar")
                    }
                }
            )
        }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(brush = gradient)
                .padding(innerPadding),
            contentAlignment = Alignment.Center
        ) {
            Card(
                modifier = Modifier
                    .padding(16.dp)
                    .fillMaxWidth(0.9f)
                    .wrapContentHeight(),
                shape = RoundedCornerShape(24.dp),
                elevation = CardDefaults.cardElevation(12.dp)
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier
                        .padding(24.dp)
                        .verticalScroll(rememberScrollState())
                ) {
                    Image(
                        painter = painterResource(id = R.drawable.asd),
                        contentDescription = "Logo",
                        modifier = Modifier
                            .height(80.dp)
                            .padding(bottom = 16.dp)
                    )

                    Text(
                        text = "Novo Produto",
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.primary
                    )

                    Spacer(modifier = Modifier.height(20.dp))

                    OutlinedTextField(
                        value = produto,
                        onValueChange = {
                            produto = it
                            erroproduto = null
                        },
                        label = { Text("Nome do produto") },
                        leadingIcon = {
                            Icon(Icons.Filled.ShoppingCart, contentDescription = null)
                        },
                        isError = erroproduto != null,
                        supportingText = erroproduto?.let { { Text(it) } },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = quantidade,
                        onValueChange = {
                            quantidade = it
                            erroQuantidade = null
                        },
                        label = { Text("Quantidade") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        leadingIcon = {
                            Icon(Icons.Filled.List, contentDescription = null)
                        },
                        isError = erroQuantidade != null,
                        supportingText = erroQuantidade?.let { { Text(it) } },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = descricao,
                        onValueChange = { descricao = it },
                        label = { Text("Descrição (opcional)") },
                        leadingIcon = {
                            Icon(Icons.Filled.Info, contentDescription = null)
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(100.dp),
                        maxLines = 4
                    )

                    Spacer(modifier = Modifier.height(24.dp))

                    Button(
                        onClick = {
                            var valido = true
                            if (produto.isBlank()) {
                                erroproduto = "Informe o nome do produto"
                                valido = false
                            }
                            val qnt = quantidade.toIntOrNull()
                            if (quantidade.isBlank()) {
                                erroQuantidade = "Informe a quantidade"
                                valido = false
                            } else if (qnt == null || qnt <= 0) {
                                erroQuantidade = "Digite uma quantidade válida"
                                valido = false
                            }
                            if (!valido) return@Button

                            isLoading = true
                            val sucesso = try {
                                dbHelper.insertItens(produto.trim(), qnt!!, descricao.trim())
                            } catch (e: Exception) {
                                false
                            } finally {
                                isLoading = false
                            }

                            if (sucesso) {
                                Toast.makeText(context, "Produto cadastrado!", Toast.LENGTH_SHORT).show()
                                onRegisterComplete()
                            } else {
                                Toast.makeText(context, "Erro ao cadastrar produto", Toast.LENGTH_SHORT).show()
                            }
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp),
                        shape = RoundedCornerShape(12.dp),
                        enabled = !isLoading
                    ) {
                        if (isLoading) {
                            CircularProgressIndicator(
                                modifier = Modifier.size(20.dp),
                                color = MaterialTheme.colorScheme.onPrimary,
                                strokeWidth = 2.dp
                            )
                        } else {
                            Text("Cadastrar", fontSize = 16.sp)
                        }
                    }
                }
            }
        }
    }
}