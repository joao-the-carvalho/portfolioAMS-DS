import MyDrawer from "../components/Sidebar";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';

export default function RootLayout() {
  return(
  <SafeAreaProvider>
    <SafeAreaView style={{flex: 1, 
    backgroundColor: '#000000'}}>
      return <MyDrawer />;
    </SafeAreaView> 
  </SafeAreaProvider> 
  )
}
