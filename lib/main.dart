import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: const MyApp(),
    ),
  );
}

class TimerProvider extends ChangeNotifier {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int initialHours = 0;
  int initialMinutes = 0;
  bool cryo = false;
  bool tens = false;
  Timer? _timer;

  void setTime(int h, int m) {
    hours = h;
    minutes = m;
    seconds = 0;
    initialHours = h;
    initialMinutes = m;
    _startTimer();
    notifyListeners();
  }

  void setCryo(bool value) {
    cryo = value;
    notifyListeners();
  }

  void setTens(bool value) {
    tens = value;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else if (hours > 0) {
        hours--;
        minutes = 59;
        seconds = 59;
      } else {
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: MaterialApp(
        title: 'Therapy Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.lightBlue[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[700],
            elevation: 4,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
        home: const TherapyScheduleScreen(),
      ),
    );
  }
}

class TherapyScheduleScreen extends StatefulWidget {
  const TherapyScheduleScreen({super.key});

  @override
  TherapyScheduleScreenState createState() => TherapyScheduleScreenState();
}

class TherapyScheduleScreenState extends State<TherapyScheduleScreen> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  void _setTime() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.setTime(
      int.tryParse(_hoursController.text) ?? 0,
      int.tryParse(_minutesController.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Home':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapyScheduleScreen(),
                          ),
                        );
                        break;
                      case 'Status':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatusPage(),
                          ),
                        );
                        break;
                      case 'Schedule':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulePage(),
                          ),
                        );
                        break;
                      case 'Help':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpPage(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Home',
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Home'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Status',
                        child: ListTile(
                          leading: Icon(Icons.flash_on),
                          title: Text('Status'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Schedule',
                        child: ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('Schedule'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Help',
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Help'),
                        ),
                      ),
                    ];
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${timerProvider.hours.toString().padLeft(2, '0')}:${timerProvider.minutes.toString().padLeft(2, '0')}:${timerProvider.seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Text(
              'Kickstart Knee Brace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'How long will you be using therapy?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha((0.2 * 255).toInt()),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Hours',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _minutesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Minutes',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _setTime,
                      child: const Text(
                        'Set Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Cryotherapy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: timerProvider.cryo,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) {
                              timerProvider.setCryo(value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Electrical Stimulation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: timerProvider.tens,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) {
                              timerProvider.setTens(value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  Timer? _blockTimer;
  int _blockSecondsLeft = 0;
  int _currentBlockIndex = 0;

  @override
  void dispose() {
    _blockTimer?.cancel();
    super.dispose();
  }

  bool _isTimePassed(
    TimerProvider timerProvider,
    int duration,
    int usedMinutes,
  ) {
    int totalSeconds =
        (timerProvider.initialHours * 3600) +
        (timerProvider.initialMinutes * 60);
    int remainingSeconds =
        (timerProvider.hours * 3600) +
        (timerProvider.minutes * 60) +
        timerProvider.seconds;
    return (usedMinutes * 60) + (duration * 60) <=
        totalSeconds - remainingSeconds;
  }

  void _startBlockTimer(int duration) {
    _blockSecondsLeft = duration * 60;
    _blockTimer?.cancel();
    _blockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_blockSecondsLeft > 0) {
        setState(() {
          _blockSecondsLeft--;
        });
      } else {
        _blockTimer?.cancel();
        _currentBlockIndex++;
      }
    });
  }

  Widget _buildBlock(
    TimerProvider timerProvider,
    String therapy,
    int duration,
    int usedMinutes,
    int index,
  ) {
    bool isPassed = _isTimePassed(timerProvider, duration, usedMinutes);
    Color blockColor;
    if (therapy == 'Electrical Stimulation') {
      blockColor = Colors.yellow[100]!;
    } else if (therapy == 'Break') {
      blockColor = Colors.grey[300]!;
    } else {
      blockColor = Colors.blue[100]!;
    }

    int blockSeconds = duration * 60;
    int totalSecondsPassed =
        (timerProvider.initialHours * 3600) +
        (timerProvider.initialMinutes * 60) -
        ((timerProvider.hours * 3600) +
            (timerProvider.minutes * 60) +
            timerProvider.seconds);
    int blockStartSeconds = usedMinutes * 60;
    int blockEndSeconds = blockStartSeconds + blockSeconds;
    bool isActiveBlock =
        totalSecondsPassed >= blockStartSeconds &&
        totalSecondsPassed < blockEndSeconds;

    if (isActiveBlock && _currentBlockIndex == index) {
      _startBlockTimer(duration);
    }

    int secondsLeftInBlock = blockEndSeconds - totalSecondsPassed;
    if (secondsLeftInBlock < 0) {
      secondsLeftInBlock = 0;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      height: 80.0, // Set all blocks to the same height
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.circular(10),
        border:
            isActiveBlock
                ? Border.all(color: Colors.grey[700]!, width: 2.0)
                : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                therapy,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  decoration: isPassed ? TextDecoration.lineThrough : null,
                ),
              ),
              if (isPassed) const SizedBox(width: 8),
              if (isPassed) const Icon(Icons.check, color: Colors.blue),
            ],
          ),
          Text(
            isActiveBlock
                ? '${(secondsLeftInBlock ~/ 60).toString().padLeft(2, '0')}:${(secondsLeftInBlock % 60).toString().padLeft(2, '0')}'
                : '$duration min',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              decoration: isPassed ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScheduleBlocks(TimerProvider timerProvider) {
    List<Widget> blocks = [];
    int totalMinutes =
        (timerProvider.initialHours * 60) + timerProvider.initialMinutes;
    int usedMinutes = 0;
    int index = 0;

    void addBlock(String therapy, int duration) {
      if (usedMinutes + duration <= totalMinutes) {
        blocks.add(
          _buildBlock(timerProvider, therapy, duration, usedMinutes, index),
        );
        usedMinutes += duration;
        index++;
      } else {
        blocks.add(
          _buildBlock(
            timerProvider,
            therapy,
            totalMinutes - usedMinutes,
            usedMinutes,
            index,
          ),
        );
        usedMinutes = totalMinutes;
        index++;
      }
    }

    if (timerProvider.cryo && timerProvider.tens) {
      while (usedMinutes < totalMinutes) {
        addBlock('Cryotherapy', 20);
        if (usedMinutes < totalMinutes) addBlock('Electrical Stimulation', 20);
        if (usedMinutes < totalMinutes) addBlock('Break', 10);
      }
    } else if (timerProvider.cryo) {
      while (usedMinutes < totalMinutes) {
        addBlock('Cryotherapy', 30);
        if (usedMinutes < totalMinutes) addBlock('Break', 20);
      }
    } else if (timerProvider.tens) {
      while (usedMinutes < totalMinutes) {
        addBlock('Electrical Stimulation', 2);
        if (usedMinutes < totalMinutes) addBlock('Break', 2);
      }
    }

    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    String scheduledTime = '';
    if (timerProvider.initialHours > 0) {
      scheduledTime +=
          '${timerProvider.initialHours} hour${timerProvider.initialHours > 1 ? 's' : ''}';
    }
    if (timerProvider.initialMinutes > 0) {
      if (scheduledTime.isNotEmpty) {
        scheduledTime += ' and ';
      }
      scheduledTime +=
          '${timerProvider.initialMinutes} minute${timerProvider.initialMinutes > 1 ? 's' : ''}';
    }

    double totalSeconds =
        (timerProvider.initialHours * 3600).toDouble() +
        (timerProvider.initialMinutes * 60).toDouble();
    double remainingSeconds =
        (timerProvider.hours * 3600).toDouble() +
        (timerProvider.minutes * 60).toDouble() +
        timerProvider.seconds.toDouble();
    double fillPercentage = remainingSeconds / totalSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Home':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapyScheduleScreen(),
                          ),
                        );
                        break;
                      case 'Status':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatusPage(),
                          ),
                        );
                        break;
                      case 'Schedule':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulePage(),
                          ),
                        );
                        break;
                      case 'Help':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpPage(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Home',
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Home'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Status',
                        child: ListTile(
                          leading: Icon(Icons.flash_on),
                          title: Text('Status'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Schedule',
                        child: ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('Schedule'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Help',
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Help'),
                        ),
                      ),
                    ];
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${timerProvider.hours.toString().padLeft(2, '0')}:${timerProvider.minutes.toString().padLeft(2, '0')}:${timerProvider.seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Text(
              'Kickstart Knee Brace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Scheduled for $scheduledTime of therapy',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Cryotherapy ',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: timerProvider.cryo ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 20),
                const Text(
                  'Electrical Stimulation ',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: timerProvider.tens ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              heightFactor:
                                  fillPercentage >= 0.0 ? fillPercentage : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (index) {
                                int totalMinutes =
                                    (timerProvider.initialHours * 60) +
                                    timerProvider.initialMinutes;
                                int incrementMinutes = totalMinutes ~/ 4;
                                int displayMinutes = incrementMinutes * index;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$displayMinutes min',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListView(
                      children: _buildScheduleBlocks(timerProvider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Home':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapyScheduleScreen(),
                          ),
                        );
                        break;
                      case 'Status':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatusPage(),
                          ),
                        );
                        break;
                      case 'Schedule':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulePage(),
                          ),
                        );
                        break;
                      case 'Help':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpPage(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Home',
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Home'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Status',
                        child: ListTile(
                          leading: Icon(Icons.flash_on),
                          title: Text('Status'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Schedule',
                        child: ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('Schedule'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Help',
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Help'),
                        ),
                      ),
                    ];
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${timerProvider.hours.toString().padLeft(2, '0')}:${timerProvider.minutes.toString().padLeft(2, '0')}:${timerProvider.seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Text(
              'Kickstart Knee Brace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Help Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'There are four screens within the app',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TherapyScheduleScreen(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: '1. ',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' - this is where you enter the amount of time you will be using therapy and choose which therapies you will be using. This information is used to create your personalized schedule for the therapy session.\n\n',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const StatusPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: '2. ',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' - this screen lists what therapy should currently be in use. If you ever forget what therapy you should be using, reference this page.\n\n',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SchedulePage(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: '3. ',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Schedule',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' - this screen displays your personalized therapy schedule according to the time and therapies entered on the Home screen.\n\n',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Text.rich(
                TextSpan(
                  text: '4. ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Help',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' - Instructions for the use of the app, where you currently are.',
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    bool isCryoActive = false;
    bool isTensActive = false;

    // Determine if cryotherapy or electrical stimulation is active
    int totalSecondsPassed =
        (timerProvider.initialHours * 3600) +
        (timerProvider.initialMinutes * 60) -
        ((timerProvider.hours * 3600) +
            (timerProvider.minutes * 60) +
            timerProvider.seconds);

    int usedMinutes = 0;
    List<Map<String, dynamic>> schedule = [];

    if (timerProvider.cryo && timerProvider.tens) {
      while (usedMinutes <
          (timerProvider.initialHours * 60 + timerProvider.initialMinutes)) {
        schedule.add({'therapy': 'Cryotherapy', 'duration': 20});
        usedMinutes += 20;
        if (usedMinutes >=
            (timerProvider.initialHours * 60 + timerProvider.initialMinutes))
          break;
        schedule.add({'therapy': 'Electrical Stimulation', 'duration': 20});
        usedMinutes += 20;
        if (usedMinutes >=
            (timerProvider.initialHours * 60 + timerProvider.initialMinutes))
          break;
        schedule.add({'therapy': 'Break', 'duration': 10});
        usedMinutes += 10;
      }
    } else if (timerProvider.cryo) {
      while (usedMinutes <
          (timerProvider.initialHours * 60 + timerProvider.initialMinutes)) {
        schedule.add({'therapy': 'Cryotherapy', 'duration': 30});
        usedMinutes += 30;
        if (usedMinutes >=
            (timerProvider.initialHours * 60 + timerProvider.initialMinutes))
          break;
        schedule.add({'therapy': 'Break', 'duration': 20});
        usedMinutes += 20;
      }
    } else if (timerProvider.tens) {
      while (usedMinutes <
          (timerProvider.initialHours * 60 + timerProvider.initialMinutes)) {
        schedule.add({'therapy': 'Electrical Stimulation', 'duration': 2});
        usedMinutes += 2;
        if (usedMinutes >=
            (timerProvider.initialHours * 60 + timerProvider.initialMinutes))
          break;
        schedule.add({'therapy': 'Break', 'duration': 2});
        usedMinutes += 2;
      }
    }

    int elapsedMinutes = totalSecondsPassed ~/ 60;
    for (var block in schedule) {
      if (elapsedMinutes < block['duration']) {
        if (block['therapy'] == 'Cryotherapy') {
          isCryoActive = true;
        } else if (block['therapy'] == 'Electrical Stimulation') {
          isTensActive = true;
        }
        break;
      }
      elapsedMinutes -= block['duration'] as int;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Home':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TherapyScheduleScreen(),
                          ),
                        );
                        break;
                      case 'Status':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StatusPage(),
                          ),
                        );
                        break;
                      case 'Schedule':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulePage(),
                          ),
                        );
                        break;
                      case 'Help':
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpPage(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Home',
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Home'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Status',
                        child: ListTile(
                          leading: Icon(Icons.flash_on),
                          title: Text('Status'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Schedule',
                        child: ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('Schedule'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Help',
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Help'),
                        ),
                      ),
                    ];
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${timerProvider.hours.toString().padLeft(2, '0')}:${timerProvider.minutes.toString().padLeft(2, '0')}:${timerProvider.seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Text(
              'Kickstart Knee Brace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.flash_on,
              size: 150,
              color: isTensActive ? Colors.yellow : Colors.grey,
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: Icon(
              Icons.ac_unit,
              size: 150,
              color: isCryoActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
