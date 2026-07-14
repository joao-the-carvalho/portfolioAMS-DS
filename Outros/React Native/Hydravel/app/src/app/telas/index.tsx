import { Text, Platform } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import layout from "../../styles/layout";
const getBaseUrl = () => {
  if (Platform.OS === 'ios') {
    return 'http://localhost:3000'; 
  } else {
    return 'http://192.168.0.10:3000'; 
  }
};
const response = fetch(`${getBaseUrl()}/`).then((response) => response.text());
export default function HomeScreen() {
  return (
    <SafeAreaView style={[layout.container, layout.center]}>
      <Text style={[layout.textMain]}>Essa é a página principal</Text>
      <Text>{response}</Text>
    </SafeAreaView>
  );
}
