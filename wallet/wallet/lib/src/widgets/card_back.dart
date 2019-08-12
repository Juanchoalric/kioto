import 'package:flutter/material.dart';

import '../helpers/card_color.dart';
import '../../blocs/bloc_provider.dart';
import '../../blocs/card_bloc.dart';

class CardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CardBloc bloc = BlocProvider.of<CardBloc>(context);

    return StreamBuilder(
      stream: bloc.cardColorIndexSelected,
      builder: (context, snapshot){
        return Container(
          decoration: BoxDecoration(
            color: snapshot.hasData
              ? CardColor.baseColors[snapshot.data]
              : CardColor.baseColors[0],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50,),
                Row(
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage('assets/card_band.jpg'),
                        width: 200,
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: 65,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red, width: 3.0),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: StreamBuilder(
                          stream: bloc.cardCvv,
                          builder: (context, snapshot){
                            return Text(
                              snapshot.hasData ? snapshot.data : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage('assets/card_back.jpg'),
                      width: 65,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
      },
    );
  }
}