import 'package:flutter/material.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/store/acala/types/loanType.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class LoanChart extends StatelessWidget {
  LoanChart(this.loan);
  final LoanData loan;
  @override
  Widget build(BuildContext context) {
    final Map dic = I18n.of(context).acala;
    double requiredCollateralRatio = double.parse(Fmt.token(
        loan.type.requiredCollateralRatio,
        decimals: acala_token_decimals));
    double liquidationRatio = double.parse(
        Fmt.token(loan.type.liquidationRatio, decimals: acala_token_decimals));

    const double heightTotal = 160;
    final double widthChart = MediaQuery.of(context).size.width / 4;
    double heightBorrowed = 0;
    double heightRequired = 0;
    double heightLiquidation = 0;
    double heightBorrowedAdjusted = 0;
    double heightRequiredAdjusted = 0;
    double heightLiquidationAdjusted = 0;
    if (loan.debitInUSD > BigInt.zero) {
      heightBorrowed = heightTotal * (loan.debitInUSD / loan.collateralInUSD);
      heightRequired = heightTotal / requiredCollateralRatio;
      heightLiquidation = heightTotal / liquidationRatio;

      heightBorrowedAdjusted = heightBorrowed;
      heightRequiredAdjusted = heightRequired;
      heightLiquidationAdjusted = heightLiquidation;

      if (heightTotal - heightLiquidationAdjusted < 20) {
        heightLiquidationAdjusted = heightTotal - 20;
      }
      if (heightLiquidationAdjusted - heightRequiredAdjusted < 20) {
        heightRequiredAdjusted = heightLiquidationAdjusted - 20;
      }
      if (heightRequiredAdjusted - heightBorrowedAdjusted < 20) {
        heightBorrowedAdjusted = heightRequiredAdjusted - 24;
      }
    }

    String collateralInUSD =
        Fmt.priceFloor(loan.collateralInUSD, decimals: acala_token_decimals);
    String debitInUSD =
        Fmt.priceCeil(loan.debitInUSD, decimals: acala_token_decimals);
    const TextStyle textStyle = TextStyle(fontSize: 12);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(24, 8, 0, 8),
          child: _ChartContainer(
            heightBorrowedAdjusted,
            heightRequiredAdjusted,
            heightLiquidationAdjusted,
            collateral: Text('100%'),
            debits: Text(
              Fmt.ratio(loan.collateralRatio),
              style: TextStyle(color: Colors.orange),
            ),
            liquidation: Text(
              Fmt.ratio(liquidationRatio),
              style: TextStyle(color: Colors.red),
            ),
            required: Text(
              Fmt.ratio(requiredCollateralRatio),
              style: TextStyle(color: Colors.blue),
            ),
            alignment: AlignmentDirectional.bottomEnd,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
          padding: EdgeInsets.only(top: 8, right: 8),
          width: widthChart,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Theme.of(context).unselectedWidgetColor),
              bottom:
                  BorderSide(color: Theme.of(context).unselectedWidgetColor),
            ),
          ),
          child: _ChartContainer(
            heightBorrowed,
            heightRequired,
            heightLiquidation,
            liquidation: Divider(color: Colors.red, height: 2, thickness: 2),
            required: Divider(color: Colors.blue, height: 2, thickness: 2),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 24, 8),
            child: _ChartContainer(
              heightBorrowedAdjusted,
              heightRequiredAdjusted,
              heightLiquidationAdjusted,
              collateral: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(dic['loan.collateral']),
                  Text('\$$collateralInUSD',
                      style: Theme.of(context).textTheme.display4),
                ],
              ),
//              debits: Text(
//                dic['liquid.ratio.current'],
//                style: TextStyle(color: Colors.orange),
//              ),
              liquidation: Text(
                dic['liquid.ratio'],
                style: TextStyle(color: Colors.red),
              ),
              required: Text(
                dic['liquid.ratio.require'],
                style: TextStyle(color: Colors.blue),
              ),
              debits: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dic['liquid.ratio.current'],
                    style: TextStyle(color: Colors.orange),
                  ),
                  Expanded(
                    child: Text(
                      '\$$debitInUSD',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
//              liquidation: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    dic['liquid.ratio'],
//                    style: TextStyle(color: Colors.red),
//                  ),
//                  Text(
//                    Fmt.ratio(liquidationRatio),
//                    style: TextStyle(color: Colors.red),
//                  ),
//                ],
//              ),
//              required: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    dic['liquid.ratio.require'],
//                    style: TextStyle(color: Colors.blue),
//                  ),
//                  Text(
//                    Fmt.ratio(requiredCollateralRatio),
//                    style: TextStyle(color: Colors.blue),
//                  ),
//                ],
//              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartContainer extends StatelessWidget {
  _ChartContainer(
    this.heightBorrowed,
    this.heightRequired,
    this.heightLiquidation, {
    this.collateral,
    this.debits,
    this.required,
    this.liquidation,
    this.alignment,
  });

  final double heightBorrowed;
  final double heightRequired;
  final double heightLiquidation;
  final Widget collateral;
  final Widget debits;
  final Widget required;
  final Widget liquidation;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment ?? AlignmentDirectional.bottomStart,
      children: <Widget>[
        // collateral amount
        Container(
          height: 160,

          decoration: collateral == null
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Theme.of(context).dividerColor, width: 2),
                    right: BorderSide(
                        color: Theme.of(context).dividerColor, width: 2),
                  ),
                )
              : null,
//          color: collateral == null
//              ? Theme.of(context).dividerColor
//              : Colors.transparent,
          child: collateral,
        ),
        // borrowed amount
        Container(
          height: heightBorrowed > 30 ? heightBorrowed : 30,
          color: debits == null ? Colors.orangeAccent : Colors.transparent,
          child: debits,
        ),
        // the liquidation line
        Container(
          height: heightLiquidation,
          alignment: Alignment.topLeft,
          child: liquidation,
        ),
        // the required line
        Container(
          height: heightRequired,
          alignment: Alignment.topLeft,
          child: required,
        ),
      ],
    );
  }
}
