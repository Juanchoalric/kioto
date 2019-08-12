import 'package:flutter/material.dart';

import '../helpers/card_color.dart';
import '../widgets/card_chip.dart';
import '../../blocs/card_bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../helpers/formatters.dart';

class CardFront extends StatelessWidget {
  final int rotatedTurnValue;

  CardFront({this.rotatedTurnValue});

  @override
  Widget build(BuildContext context) {
    final CardBloc bloc = BlocProvider.of(context);

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<String>(
            stream: bloc.cardNumber,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? _formatCardNumber(snapshot.data)
                  : _formatCardNumber('0000000000000000');
            },
          ),
        ],
      ),
    );

    final _cardLastNumber = Padding(
      padding: const EdgeInsets.only(top: 1.0, left: 44.0),
      child: StreamBuilder<String>(
        stream: bloc.cardNumber,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Text(
            snapshot.hasData
              ? snapshot.data
                .replaceAll(RegExp(r'\s+\b|\b\s'), '')
                .substring(12)
              : '0000',
            style: TextStyle(color: Colors.white, fontSize: 8.0),
          );
        },
      ),
    );

    final _cardValidThru = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Valid', style: TextStyle(color: Colors.white, fontSize: 8.0),),
              Text('thru', style: TextStyle(color: Colors.white, fontSize: 8.0),)
            ],
          ),
          SizedBox(width: 5.0,),
          StreamBuilder(
            stream: bloc.cardMonth,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              return Text(
                snapshot.hasData
                  ? snapshot.data
                  : '00'
              );
            },
          ),
          StreamBuilder(
            stream: bloc.cardYear,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              return Text(
                snapshot.hasData && snapshot.data.length > 2
                  ? '/${snapshot.data.substring(2)}'
                  : '/00'
              );
            },
          ),
        ],
      ),
    );

    final _cardOwner = Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 44.0),
      child: StreamBuilder(
        stream: bloc.cardHolderName,
        builder: (context, snapshot) => Text(
              snapshot?.data ?? 'CARDHOLDER NAME',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
      ),
    );

    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 25, right: 45),
          child: Image(
            image: AssetImage('assets/visa.png'),
            width: 65,
            height: 32,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 45),
          child: StreamBuilder(
            stream: bloc.cardType,
            builder: (context, snapshot){
              return Text(
                snapshot.hasData ? snapshot.data : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ),
      ],
    );

    return StreamBuilder<int>(
      stream: bloc.cardColorIndexSelected,
      initialData: 0,
      builder: (context, snapshot){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: CardColor.baseColors[snapshot.data],
          ),
          child: RotatedBox(
            quarterTurns: rotatedTurnValue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _cardLogo,
                CardChip(),
                _cardNumber,
                _cardLastNumber,
                _cardValidThru,
                _cardOwner,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _formatCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    List<Widget> numberList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < cardNumber.length; i++){
      counter++;
      numberList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            cardNumber[i],
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
      );
      if (counter == 4){
        counter = 0;
        numberList.add(SizedBox(width: 26.0));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numberList,
    );
  }
}
