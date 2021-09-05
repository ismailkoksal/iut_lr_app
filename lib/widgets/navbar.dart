import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/stores/date_store.dart';
import 'package:iut_lr_app/themes/theme.dart';
import 'package:iut_lr_app/user.dart';
import 'package:iut_lr_app/widgets/list/week_page_view.dart';
import 'package:provider/provider.dart';

import '../apis/string_apis.dart';
import '../settings_store.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key key,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Future<String> _studentName;

  bool isSelected(DateTime date) {
    final selectedDate = context.watch<DateStore>().selectedDate.value;
    return DateFormat.yMd().format(date) ==
        DateFormat.yMd().format(selectedDate);
  }

  @override
  void initState() {
    super.initState();
    _studentName = User.studentName;
  }

  @override
  Widget build(BuildContext context) {
    final dateStore = context.watch<DateStore>();
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.wb_sunny),
                  onPressed: () => SettingsStore.of(context).updateTheme(
                      SettingsStore.of(context).theme.value ==
                              appThemeData[AppTheme.Dark]
                          ? AppTheme.Light
                          : AppTheme.Dark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                      child: FutureBuilder<String>(
                        future: _studentName,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Text(
                                  'Salut, ${snapshot.data.toTitleCase()}!',
                                  style: Theme.of(context).textTheme.headline6,
                                )
                              : _buildPageTitle(context);
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Observer(
                          builder: (context) {
                            final month = DateFormat.MMM()
                                .format(dateStore.selectedDate.value)
                                .toTitleCase();
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).appBarTheme.color,
                                      Theme.of(context)
                                          .appBarTheme
                                          .color
                                          .withOpacity(0.8),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.2, 0.9]),
                              ),
                              child: Text(
                                month,
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          height: 70.0,
                          child: WeekPageView(),
                        ),
                      ],
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

  Widget _buildPageTitle(BuildContext context) {
    return Text(
      'Emploi du temps',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
