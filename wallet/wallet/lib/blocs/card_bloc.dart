import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:wallet/src/models/card_model.dart';

import '../src/models/card_color_model.dart';
import '../src/helpers/card_color.dart';
import 'validators.dart';
import 'bloc_provider.dart';
import 'card_list_bloc.dart';

class CardBloc with Validator implements BlocBase{

  BehaviorSubject<String> _cardHolderName = BehaviorSubject<String>();
  BehaviorSubject<String> _cardNumber = BehaviorSubject<String>();
  BehaviorSubject<String> _cardMonth = BehaviorSubject<String>();
  BehaviorSubject<String> _cardYear = BehaviorSubject<String>();
  BehaviorSubject<String> _cardCvv = BehaviorSubject<String>();
  BehaviorSubject<String> _cardType = BehaviorSubject<String>();
  BehaviorSubject<int> _cardColorIndexSelected = BehaviorSubject<int>.seeded(1);
  

  final _cardColors = BehaviorSubject<List<CardColorModel>>();

  //Add data Stream
  Function(String) get selectCardType => _cardType.sink.add;
  Function(String) get changeCardNumber => _cardNumber.sink.add;
  Function(String) get changeCardMonth => _cardMonth.sink.add;
  Function(String) get changeCardYear => _cardYear.sink.add;
  Function(String) get changeCardCvv => _cardCvv.sink.add;
  Function(String) get changeCardHolderName => _cardHolderName.sink.add;


  // Retrieve data from Stream
  Observable<String> get cardType => _cardType.stream;
  Observable<String> get cardHolderName => _cardHolderName.stream.transform(validateCardHolderName);
  Observable<String> get cardNumber => _cardNumber.stream.transform(validateCardNumber);
  Observable<String> get cardMonth => _cardMonth.stream.transform(validateCardMonth);
  Observable<String> get cardYear => _cardYear.stream.transform(validateCardYear);
  Observable<String> get cardCvv => _cardCvv.stream.transform(validateCardCvv);
  Observable<int> get cardColorIndexSelected => _cardColorIndexSelected.stream;
  Observable<List<CardColorModel>> get cardColorList => _cardColors.stream;
  Observable<bool> get savecardValid => Observable.combineLatest5(
    cardNumber, cardNumber, cardMonth, cardYear, cardCvv, (ch, cn, cm, cy, cv) => true);

  
  void saveCard() {
    final newCard = CardResults(
      cardHolderName: _cardHolderName.value,
      cardNumber: _cardNumber.value.replaceAll(RegExp(r'\s+\b|\b\s'), ''),
      cardMonth: _cardMonth.value,
      cardYear: _cardYear.value,
      cardCvv: _cardCvv.value,
      cardColor: CardColor.baseColors[_cardColorIndexSelected.value],
      cardType: _cardType.value
    );
    cardListBloc.addCardList(newCard);
  }

  void selectedCardColor(int colorIndex) {
    CardColor.cardColors.forEach((element)=> element.isSelected = false);
    CardColor.cardColors[colorIndex].isSelected = true;
    _cardColors.sink.add(CardColor.cardColors);
    _cardColorIndexSelected.sink.add(colorIndex);
  }

  void dispose(){
    _cardHolderName.close();
    _cardNumber.close();
    _cardMonth.close();
    _cardYear.close();
    _cardCvv.close();
    _cardType.close();
    _cardColorIndexSelected.close();
    _cardColors.close();
  }
}