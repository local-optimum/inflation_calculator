//BASIC THEMING
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaru/yaru.dart';

//FOR CREATING HYPERLINKS
import 'package:url_launcher/url_launcher.dart';

//IMPORT API SHEET
import 'inflation_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var theme = yaruDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: MyHomePage(title: 'The Inflation Tax Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //NEW VARIABLES INITIALIZED HERE
  double startvalue = 1000;
  DateTime startdate = DateTime.now().subtract(Duration(days: 3650));
  DateTime enddate = DateTime.now();
  String enddateformatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String startdateformatted = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 3650)));
  var _endvalue;
  var _endinflation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountinput = TextEditingController(
      text: '1000'); //INITIALIZE THE INPUT FIELD WITH 1000

  TextEditingController startdateinput = TextEditingController(
      text: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 3650))));
  TextEditingController enddateinput = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  //text editing controller for text field

  void initStartDate() {
    startdateinput.text = DateFormat('yyyy-MM-dd')
        .format(startdate); //set the initial value of text field
    super.initState();
  }

  void initEndDate() {
    enddateinput.text = DateFormat('yyyy-MM-dd')
        .format(enddate); //set the initial value of text field
    super.initState();
  }

  //NEW FUNCTION TO CALL THE API WITH CURRENT VALUES
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await InflationData()
          .getInflationData(startdate, enddate, startvalue);
      isWaiting = false;
      setState(() {
        _endvalue = data;
      });
    } catch (e) {
      print(e);
    }
    try {
      var data = await InflationRate().getInflationRate(startdate, enddate);
      isWaiting = false;
      setState(() {
        _endinflation = data;
      });
    } catch (e) {
      print(e);
    }
    enddateformatted = DateFormat('yyyy-MM-dd').format(enddate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              //FREIDMAN QUOTE
              Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  CircleAvatar(
                    radius: 100.0,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage('images/friedman.png'),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    '"Inflation is taxation without legislation."',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Text(
                    'Milton Friedman',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 300.0,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ],
              ),

              //INTRO TEXT
              SizedBox(
                width: 700,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                      leading: Icon(Icons.trending_down_sharp),
                      title: Text(
                        'Cash is not a store of value.\n',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        """The money supply is increasing at a historic rate.
                        \nWe are all becoming poorer as a result.
                        \nUse this tool to visualise the impact of inflation\non your purchasing power.\n""",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                ),
              ),

              //DIVIDER
              SizedBox(
                height: 40.0,
                width: 300.0,
                child: Divider(
                  thickness: 2,
                ),
              ),

              //USER INPUTS
              SizedBox(
                width: 550,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(
                            child: Text(
                              'Complete the form to generate results.\n',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        //START AMOUNT UPDATER
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: amountinput,
                                decoration: InputDecoration(
                                  labelText: 'Initial Amount in USD',
                                  hintText: 'e.g. 100000',
                                  icon: Icon(Icons.attach_money),
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (String? value) {
                                  startvalue = double.parse(value!);
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty ||
                                      double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                                onChanged: (value) =>
                                    startvalue = double.parse(value),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              //START DATE UPDATER
                              TextFormField(
                                controller:
                                    startdateinput, //editing controller of this TextField
                                decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText: "Start Date",
                                  //label text of field
                                ),
                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now()
                                          .subtract(Duration(days: 3650)),
                                      firstDate: DateTime(
                                          1914), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      startdate = pickedDate;
                                      startdateinput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),

                              SizedBox(
                                height: 30.0,
                              ),

                              //END DATE UPDATER

                              TextFormField(
                                controller:
                                    enddateinput, //editing controller of this TextField
                                decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText: "End Date",
                                  //label text of field
                                ),
                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(
                                          1914), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement

                                    setState(() {
                                      enddate = pickedDate;
                                      enddateinput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {
                                    print("Date is not selected");
                                  }
                                },
                              ),

                              //SUBMIT BUTTON
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate())
                                      getData();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //DIVIDER
              SizedBox(
                height: 40.0,
                width: 300.0,
                child: Divider(
                  thickness: 2,
                ),
              ),

              //RESULTS BOX
              if (_endvalue != null) ...[
                Card(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'To have the same purchasing power in $enddateformatted you would need:',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          '$_endvalue',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'The inflation rate over this period was:',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          '$_endinflation%',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                  width: 300.0,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
              ],
              //DIVIDER

              //PADDING SO THAT THE PAGE SCROLLS CLEAR OF THE BOTTOM BAR
              SizedBox(
                height: 100.0,
              ),
            ],
          ),
        ),
      ),

      //BOTTOM SHEET TO ADD CONTACT DETAILS - ADD STATISTA LINK
      bottomSheet: Container(
        height: 75.0,
        color: Colors.black26,
        child: Center(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Created by Local Optimum   //'),
                TextButton(
                  onPressed: () {
                    launch(
                        'https://github.com/local-optimum/inflation_calculator');
                  },
                  child: Text(
                    'Github',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('data from'),
                TextButton(
                  onPressed: () {
                    launch('https://www.statbureau.org/');
                  },
                  child: Text(
                    'statbureau.org',
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
