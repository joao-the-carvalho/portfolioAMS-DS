import { Text } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import layout from "../../styles/layout";

export default function HomeScreen() {
  return (
    <SafeAreaView style={[layout.container, layout.center]}>
      <Text style={[layout.textMain]}>Essa é a página principal</Text>
    </SafeAreaView>
  );
}
