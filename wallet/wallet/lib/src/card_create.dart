import 'package:flutter/material.dart';

import 'widgets/my_app_bar.dart';
import 'widgets/flip_card.dart';
import 'widgets/card_front.dart';
import 'widgets/card_back.dart';
import 'helpers/card_color.dart';
import 'helpers/formatters.dart';
import '../blocs/card_bloc.dart';
import '../blocs/bloc_provider.dart';
import 'models/card_color_model.dart';

class CardCreate extends StatefulWidget {
  @override
  _CardCreateState createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  final GlobalKey<FlipCardState> animatedStateKey = GlobalKey<FlipCardState>();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {
    animatedStateKey.currentState.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    final CardBloc bloc = BlocProvider.of<CardBloc>(context);

    final _creditCard = Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Card(
        color: Colors.grey[100],
        elevation: 0.0,
        margin: EdgeInsets.fromLTRB(15, 2, 15, 0),
        child: FlipCard(
          key: animatedStateKey,
          front: CardFront(
            rotatedTurnValue: 0,
          ),
          back: CardBack(),
        ),
      ),
    );

    final _cardHolderName = StreamBuilder(
      stream: bloc.cardHolderName,
      builder: (context, snapshot) {
        return TextField(
          textCapitalization: TextCapitalization.characters,
          onChanged: bloc.changeCardHolderName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Cardholder Name',
            errorText: snapshot.error,
          ),
        );
      },
    );

    final _cardNumer = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: StreamBuilder(
        stream: bloc.cardNumber,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeCardNumber,
            keyboardType: TextInputType.number,
            maxLength: 19,
            maxLengthEnforced: true,
            inputFormatters: [
              MaskedTextInputFormatter(
                mask: 'xxxx xxxx xxxx xxxx',
                separator: ' ',
              ),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Card Number',
              counterText: '',
              errorText: snapshot.error,
            ),
          );
        },
      ),
    );

    final _cardMonth = StreamBuilder(
      stream: bloc.cardMonth,
      builder: (context, snapshot) {
        return Container(
          width: 85,
          child: TextField(
            onChanged: bloc.changeCardMonth,
            keyboardType: TextInputType.number,
            maxLength: 2,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'MM',
              counterText: '',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );

    final _cardYear = StreamBuilder(
      stream: bloc.cardYear,
      builder: (context, snapshot) {
        return Container(
          width: 120,
          child: TextField(
            onChanged: bloc.changeCardYear,
            keyboardType: TextInputType.number,
            maxLength: 4,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'YYYY',
              counterText: '',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );

    final _cardCvv = StreamBuilder(
      stream: bloc.cardCvv,
      builder: (context, snapshot) {
        return Container(
          width: 85,
          child: TextField(
            focusNode: _focusNode,
            onChanged: bloc.changeCardCvv,
            keyboardType: TextInputType.number,
            maxLength: 3,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'CVV',
              counterText: '',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );

    final _saveCard = StreamBuilder(
      stream: bloc.savecardValid,
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width - 40,
          child: RaisedButton(
            child: Text(
              'Save Card',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            onPressed: snapshot.hasData
                ? () {
                    var blocProviderCardWallet = BlocProvider(
                      bloc: bloc,
                      child: null,//CardWallet(),
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => blocProviderCardWallet));
                  }
                : null,
          ),
        );
      },
    );

    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Create Card',
        leadingIcon: Icons.arrow_back,
        context: context,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        itemExtent: 750,
        padding: EdgeInsets.only(top: 10),
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: _creditCard,
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8.0,),
                      _cardHolderName,
                      _cardNumer,
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _cardMonth,
                          SizedBox(width: 12,),
                          _cardYear,
                          SizedBox(width: 12,),
                          _cardCvv,
                        ],
                      ),
                      SizedBox(height: 20,),
                      cardColors(bloc),
                      SizedBox(height: 20,),
                      _saveCard,
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget cardColors(CardBloc bloc) {
    final dotSize =
        (MediaQuery.of(context).size.width - 220) / CardColor.baseColors.length;

    List<Widget> dotList = List<Widget>();

    for (var i = 0; i < CardColor.baseColors.length; i++) {
      dotList.add(
        StreamBuilder<List<CardColorModel>>(
          stream: bloc.cardColorList,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () => bloc.selectedCardColor(i),
                child: Container(
                  child: snapshot.hasData
                      ? snapshot.data[i].isSelected
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : Container()
                      : Container(),
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: CardColor.baseColors[i],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dotList,
    );
  }
}
