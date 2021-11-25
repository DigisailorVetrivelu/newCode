import 'package:flutter/material.dart';
import 'package:iukl_admin/constants/colors.dart';
import 'package:iukl_admin/models/userModel.dart';

class CovidInformation extends StatefulWidget {
  const CovidInformation({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  _CovidInformationState createState() => _CovidInformationState();
}

class _CovidInformationState extends State<CovidInformation> {
  String testmethod = 'swab';
  String typegroupValue = 'symptomatic';
  bool vaccinegroupValue = false;
  bool resultgroupValue = false;
  @override
  void initState() {
    if (widget.user.covidInfo == null) {
      widget.user.covidInfo = CovidInfo(method: 'swab', type: 'symptomatic', result: false, vaccinated: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: TabBar(
              labelColor: kprimaryColor,
              labelStyle: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
              tabs: [Tab(child: Text("Status")), Tab(text: "Assesment")],
              indicatorColor: Colors.red,
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Your Test Now !',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 18.0),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                          child: Text(
                            'Test Method',
                            style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    onChanged: (String? v) {
                                      setState(() {
                                        widget.user.covidInfo!.method = v!;
                                      });
                                    },
                                    value: widget.user.covidInfo!.method,
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'swab',
                                        child: Text('Swab Test'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'nasal',
                                        child: Text('Nasal aspirate'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'rapid',
                                        child: Text('Rapid Test'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                          child: Text(
                            'Test Type',
                            style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile<String>(
                            title: const Text('Symptomatic'),
                            value: 'symptomatic',
                            groupValue: widget.user.covidInfo!.type,
                            onChanged: (String? val) {
                              setState(() {
                                widget.user.covidInfo!.type = val!;
                              });
                            }),
                        RadioListTile<String>(
                            title: const Text('Asymptomatic'),
                            value: 'asymptomatic',
                            groupValue: widget.user.covidInfo!.type,
                            onChanged: (String? val) {
                              setState(() {
                                widget.user.covidInfo!.type = val!;
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                          child: Text(
                            'Test Result',
                            style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile<bool>(
                            title: const Text('Positive'),
                            value: true,
                            groupValue: widget.user.covidInfo!.result,
                            onChanged: (val) {
                              setState(() {
                                widget.user.covidInfo!.result = val!;
                              });
                            }),
                        RadioListTile<bool>(
                            title: const Text('Negative'),
                            value: false,
                            groupValue: widget.user.covidInfo!.result,
                            onChanged: (val) {
                              setState(() {
                                widget.user.covidInfo!.result = val!;
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                          child: Text(
                            'Vaccinated',
                            style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue: widget.user.covidInfo!.vaccinated,
                            onChanged: (val) {
                              setState(() {
                                widget.user.covidInfo!.vaccinated = val!;
                              });
                            }),
                        RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue: widget.user.covidInfo!.vaccinated,
                            onChanged: (val) {
                              setState(() {
                                widget.user.covidInfo!.vaccinated = val!;
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Report Your Test Now !',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                        child: Text(
                          '1. Are you exhibiting 2 or more symptoms as listed below? / Adakah anda mengalami 2 atau lebih \n\n gejala berikut? • Fever / Demam '
                          'Chills/Kesejukan '
                          '• '
                          'Shivering (rigor) / Mergigil\n\n Body ache / Sakit badan • Headache/ Sakit kepala \n\n • Sore throat / Sakit tekak '
                          '• Nausea or vomiting / Loya atau muntah Diarrhea / Cirit birit *Fatigue / Keletihan\n\n'
                          ' • Runny nose or nasal congestion / Selesema atau hidung sumbat',
                          style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile<bool>(
                          title: const Text('Yes'), value: true, groupValue: widget.user.covidInfo!.question1, onChanged: (bool? val) {}),
                      RadioListTile<bool>(
                          title: const Text('No'), value: false, groupValue: widget.user.covidInfo!.question1, onChanged: (bool? val) {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                        child: Text(
                          '2. Besides the above, are you exhibiting any of the symptoms listed below?/Selain yang diatas, adakah anda mengalami gejala '
                          'seperti yang berikut? *\n\n'
                          ' . Cough/Batuk • Difficulty breathing / Sesak Nafas • Loss of smell / Hilang deria bau Loss of taste / Hilang deria rasa',
                          style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile<bool>(title: const Text('Yes'), value: true, groupValue: widget.user.covidInfo!.question2, onChanged: (val) {}),
                      RadioListTile<bool>(title: const Text('No'), value: false, groupValue: widget.user.covidInfo!.question2, onChanged: (val) {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                        child: Text(
                          '3. Have you attended any event / areas associated with known COVID-19 cluster? / Adakah anda mengunjungi lokasi berkaitan kluster COVID-19? *',
                          style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile<bool>(title: const Text('Yes'), value: true, groupValue: widget.user.covidInfo!.question3, onChanged: (val) {}),
                      RadioListTile<bool>(title: const Text('No'), value: false, groupValue: widget.user.covidInfo!.question3, onChanged: (val) {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                        child: Text(
                          '4. Have you travelled to any country outside Malaysia within 14 days before onset of symptoms? / '
                          'Adakah anda berkunjung ke luar negara dalam tempoh 14 hari yang lepas?*',
                          style: TextStyle(color: kprimaryColor, fontSize: 17.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile<bool>(title: const Text('Yes'), value: true, groupValue: widget.user.covidInfo!.question4, onChanged: (val) {}),
                      RadioListTile<bool>(title: const Text('No'), value: false, groupValue: widget.user.covidInfo!.question4, onChanged: (val) {}),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
