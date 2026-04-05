package com.example.logcat

import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.logcat.R
import com.example.logcat.ui.theme.LogcatTheme
import com.example.logcat.ui.theme.debugButtonColors
import com.example.logcat.ui.theme.errorButtonColors
import com.example.logcat.ui.theme.infoButtonColors
import com.example.logcat.ui.theme.warningButtonColors

@Composable
fun HomeScreen(
    userName: String = "Usuário",
    onLogout: () -> Unit
) {
    var nome by remember { mutableStateOf("") }
    Surface (
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ){
        Column(
            verticalArrangement = Arrangement.SpaceEvenly,
            horizontalAlignment = Alignment.CenterHorizontally
        ){
            val image = painterResource(R.drawable.eteclogo)
            Image(
                painter = image,
                contentDescription = null,
                contentScale = ContentScale.Crop, modifier = Modifier
                    .width(150.dp)
                    .height(100.dp)
            )
            Greeting("PAM 2")
            Row(
                Modifier
                    .fillMaxWidth(),
                Arrangement.Center

            ) {
                TextField(
                    value = nome, onValueChange = { novoValor -> nome = novoValor },
                    label = { Text("Digite seu nome:") },
                )
            }
            ActionButton(
                text = "I",
                buttonColors = errorButtonColors(),
                modifier = Modifier.fillMaxWidth(0.5f)
            ) {
                Log.e(TAG, "App: $nome Nota I")
            }
            ActionButton(
                text = "R",
                buttonColors = warningButtonColors(),
                modifier = Modifier.fillMaxWidth(0.5f)
            ) {
                Log.w(TAG, "App: $nome Nota R")
            }
            ActionButton(
                text = "B",
                buttonColors = debugButtonColors(),
                modifier = Modifier.fillMaxWidth(0.5f)
            ) {
                Log.d(TAG, "App: $nome Nota B")
            }
            ActionButton(
                text = "MB",
                buttonColors = infoButtonColors(),
                modifier = Modifier.fillMaxWidth(0.5f)
            ) {
                Log.i(TAG, "App: $nome Nota MB")
            }

        }
    }
}

@Composable
fun ActionButton(
    text: String,
    buttonColors: ButtonColors = ButtonDefaults.buttonColors(),
    modifier: Modifier = Modifier,
    block: () -> Unit
){
    ElevatedButton(
        onClick = block,
        shape = RoundedCornerShape(5.dp),
        colors = buttonColors,
        modifier = modifier
    ) {
        Text(text = text)
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier){
    Text(
        text = "ATIVIDADE DE $name",
        style = MaterialTheme.typography.bodyLarge.copy(
            fontWeight = FontWeight.Bold
        ),
        color = MaterialTheme.colorScheme.secondary
    )
}

@Preview(showBackground = true, widthDp = 120)
@Composable
fun ActionButtonPreview(){
    ActionButton(text = "Cadastrar") {
    }
}

@Preview (showBackground = true)
@Composable
fun GreetingPreview(){
    LogcatTheme {
        Greeting("PAM 2")
    }
}