import React, { Component } from "react";
import { StyleSheet, View, Text, KeyboardAvoidingView  } from "react-native";
import { CreditCardInput } from "react-native-credit-card-input"; 

export default class App extends Component {

  _onChange = (formData) => console.log(JSON.stringify(formData, null, " "));

  render() {
    return (
      <View style={style.container}>
        <Text style={style.Title} >Validador de Cartão </Text>
        <KeyboardAvoidingView behavior="padding">
            <CreditCardInput

              requiresName = {false}
              requiresCVC = {false}
              requiresPostalCode = {false}

              labels = {{ number: "NÚMERO", expiry: "VALIDADE", cvc: "CVC/CCV" }}
              placeholders = {{expiry: "MM/AA"}}

              cardScale={0.7}
              labelStyle={style.label}
              inputStyle={style.input}
              validColor={"black"}
              invalidColor={"red"}
              placeholderColor={"darkgray"} 
              onChange={this._onChange}
              />
        </KeyboardAvoidingView>
      </View>
    );
  }
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'flex-start',    
    backgroundColor: "#F5F5F5",
  },
  Title: {
    alignSelf: "center",
    fontSize: 16,
    marginVertical: 10,
    color: "black"
  },  
  label: {
    color: "black",
    fontSize: 12,
  },
  input: {
    fontSize: 12,
    color: "black",
  }
});