import { StyleSheet } from "react-native";

export default StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#121212",
    padding: 20,
  },

  center: {
    justifyContent: "center",
    alignItems: "center",
  },

  textTitle: {
    fontSize: 28,
    color: "#fff",
    fontWeight: "bold",
  },
  textMain:{
    fontSize: 16,
    color: "#fff"
  },

  button: {
    backgroundColor: "#3a5bed",
    color: "#fff",
    padding: 15,
    borderRadius: 10,
  },
  buttonActive: {
    backgroundColor: "#6680f1"
  },

  buttonText: {
    color: "#fff",
    textAlign: "center",
  },
});
