import { Text } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import layout from "../../styles/layout";

export default function OutraScreen() {
  return (
    <SafeAreaView style={[layout.container, layout.center]}>
      <Text style={[layout.textTitle]}>Essa é a OUTRA página'</Text>
      <Text style={[layout.textMain]}>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim
        lorem laoreet ligula imperdiet, vel dictum est sollicitudin. Nulla
        facilisi. Vivamus nec lectus ipsum. Vivamus suscipit diam in consequat
        facilisis. Curabitur dictum tellus non dui congue, ac rhoncus ligula
        tincidunt. Aenean ultricies lacus mauris, eu laoreet libero efficitur
        et. Vestibulum ut purus odio. Quisque euismod nec dolor id suscipit.
        Duis auctor, metus non elementum bibendum, nunc purus interdum libero,
        ac pharetra ex justo ut enim. Quisque auctor, nisl sed euismod
        fringilla, lectus dui posuere metus, id lobortis nisl quam in neque.
        Proin quis tempus magna, at facilisis erat. Ut bibendum quam in eros
        pellentesque, vitae gravida erat vulputate. Phasellus ac dui interdum,
        ultrices enim eu, aliquam dui. Fusce dignissim feugiat enim, nec
        tincidunt urna ullamcorper at. Nulla pretium varius purus non volutpat.
      </Text>
    </SafeAreaView>
  );
}
