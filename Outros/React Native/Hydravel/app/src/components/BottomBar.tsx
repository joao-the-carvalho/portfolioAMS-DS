import { createBottomTabNavigator } from "expo-router/js-tabs";
import LoginScreen from "../app/telas/auth/login";
import HomeScreen from "../app/telas/index";
import OutraScreen from "../app/telas/outra";

const Tab = createBottomTabNavigator();

export default function MyTabs() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Outra" component={OutraScreen} />
      <Tab.Screen name="Login" component={LoginScreen} />
    </Tab.Navigator>
  );
}
