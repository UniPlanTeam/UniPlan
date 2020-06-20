import 'package:flutter/material.dart';

class DaysCheckbox extends StatefulWidget {
  @override
  _DaysCheckboxState createState() => _DaysCheckboxState();
}

class _DaysCheckboxState extends State<DaysCheckbox> {

  List<bool> _data = [false, false, false, false, false, false, false];
  List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  Widget build(BuildContext context) {
    return _buildCheckBoxes();
  }

  List<int> getIntList()
  {
    List<int> days = List();
      for(int i = 0; i < _data.length; i++)
        {
          if(_data[i])
            {
              if(i == 0)
                {
                  days[6] = 6;
                }
              else{
                days[i - 1] = i;
              }
            }
        }
  }

  Widget _buildCheckBoxes() {
    List<Widget> list = new List();
    Widget cb;

    for(int i = 0; i < _data.length; i++)
      {
        cb = Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child:  Text(
                  _days[i],
                  style: Theme.of(context).primaryTextTheme.subtitle2,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: _data[i],
                onChanged: (bool value) {
                  setState(() {
                    _data[i] = value;
                  });
                },
              ),
            )
          ],
        );
        list.add(cb);
      }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
     children: list,
    );
  }

}
