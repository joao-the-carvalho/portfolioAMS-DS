  import { Drawer } from "expo-router/drawer";

import Header from "./Header";

export default function MyDrawer() {
  return (
    <Drawer
      screenOptions={{
        header: () => <Header />,
        drawerStyle: {
          backgroundColor: "#1a1a1a",
        },
        drawerActiveTintColor: "white",
        drawerActiveBackgroundColor: "#2931a289",
      }}
    >
      <Drawer.Screen
        name="telas/index"
        options={{
          drawerLabel: "Home",
          title: "Home",
        }}
      />

      <Drawer.Screen
        name="telas/outra"
        options={{
          drawerLabel: "Outra",
          title: "Outra",
        }}
      />
    </Drawer>
  );
}
