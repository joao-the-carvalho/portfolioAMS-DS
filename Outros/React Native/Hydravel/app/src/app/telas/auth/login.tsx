import React from "react";
import { Image, Pressable, Text, TextInput } from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import layout from "../../../styles/layout";

export default function LoginScreen() {
  const [email, onChangeEmail] = React.useState("");
  const [password, onChangePassword] = React.useState("");
  return (
    <SafeAreaProvider>
      <SafeAreaView style={layout.container}>
        <SafeAreaView style={layout.center}>
          <Image
            source={require("../../assets/image.png")}
            style={layout.imageLocal}
            resizeMode="contain"
          />
          <Text style={layout.textMain}>Login</Text>
          <TextInput
            style={layout.input}
            onChangeText={onChangeEmail}
            value={email}
            placeholder="email"
          />
          <TextInput
            style={layout.input}
            onChangeText={onChangePassword}
            value={password}
            placeholder="senha"
          />
          <Pressable style={layout.button}>
            <Text>Login</Text>
          </Pressable>
        </SafeAreaView>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}
