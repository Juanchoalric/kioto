import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../src/models/card_model.dart';
import '../src/helpers/card_color.dart';

class CardListBloc {
  BehaviorSubject<List<CardResults>> _cardsCollection = BehaviorSubject<List<CardResults>>();

  List<CardResults> _cardResults;

  // Retrieve data from Stream
  Stream<List<CardResults>> get cardList => _cardsCollection.stream;

  void addCardList(CardResults newCard) {
    _cardResults.add(newCard);
    _cardsCollection.sink.add(_cardResults);
  }

  void initialData() async {
    var initialData = await rootBundle.loadString('data/initialData.json');
    var decodedJson = jsonDecode(initialData);
    _cardResults = CardModel.fromJson(decodedJson).results;
    print(_cardResults);
    for (var i = 0; i < _cardResults.length; i++){
      _cardResults[i].cardColor = CardColor.baseColors[i];
    }
    _cardsCollection.sink.add(_cardResults);
  }

  CardListBloc(){
    initialData();
  }

  void dispose(){
    _cardsCollection.close();
  }
}

final cardListBloc = CardListBloc();