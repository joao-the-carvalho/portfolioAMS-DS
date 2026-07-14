import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import MyTabs from "../components/BottomBar";

export default function RootLayout() {
  return ( 
    <SafeAreaProvider>
      <SafeAreaView style={{ flex: 1, backgroundColor: "#FFFFFF" }}>
        return <MyTabs />;
      </SafeAreaView>
    </SafeAreaProvider>
    
  );
  
}
