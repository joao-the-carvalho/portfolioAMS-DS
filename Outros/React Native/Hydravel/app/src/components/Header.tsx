import { DrawerActions, useNavigation } from "expo-router/react-navigation";
import { Pressable, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import layout from "../styles/layout";

export default function Header() {
  const navigation = useNavigation();
  return (
    <SafeAreaView
      edges={["top"]}
      style={{
        backgroundColor: "#000000",
      }}
    >
      <View
        style={{
          height: 70,
          backgroundColor: "#000000",
          paddingHorizontal: 20,
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <Pressable
          style={({ pressed }) => [
            layout.button,
            pressed && layout.buttonActive,
          ]}
          onPress={() => navigation.dispatch(DrawerActions.openDrawer())}
        >
          <Text style={{ color: "#fff", fontSize: 20 }}>☰</Text>
        </Pressable>
        <Text
          style={{
            paddingLeft: 15,
            color: "#fff",
            fontSize: 24,
            fontWeight: "bold",
          }}
        >
          Hydravel
        </Text>
      </View>
    </SafeAreaView>
  );
}
