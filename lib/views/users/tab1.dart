import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swifty_companion/intra_http_service.dart';

import '../../models/user.dart';

class Tab1 extends StatefulWidget {
  final IntraHttpService intraHttpService;
  final String login;
  final User user;
  final ImageProvider userImage;

  const Tab1({
    Key? key,
    required this.intraHttpService,
    required this.login,
    required this.user,
    required this.userImage,
  }) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin<Tab1> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        userImage(context),
        ...userInfos(),
      ],
    ));
  }

  Container userImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: widget.userImage,
        ),
      ),
    );
  }

  List<Widget> userInfos() {
    final _level = widget.user.primaryCursus == null
        ? 'No cursus'
        : widget.user.primaryCursus?.level.toStringAsFixed(2);
    final _pool = () {
      if (widget.user.poolMonth == 'none' && widget.user.poolYear == 'none') {
        return 'none';
      } else if (widget.user.poolMonth == 'none' && widget.user.poolYear != 'none') {
        return widget.user.poolYear;
      } else if (widget.user.poolMonth != 'none' && widget.user.poolYear == 'none') {
        return widget.user.poolMonth;
      } else {
        return "${widget.user.poolMonth} ${widget.user.poolYear}";
      }
    }();

    Padding unnamedUserInfo(String value, {String? suffix = "", TextStyle? style = const TextStyle()}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
            value + (suffix != null && suffix.isNotEmpty ? " $suffix" : ""),
            style: style),
      );
    }

    Padding namedUserInfo(String key, String value, [String? suffix]) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text.rich(TextSpan(children: <TextSpan>[
          TextSpan(text: key, style: const TextStyle(color: Colors.deepPurple)),
          const TextSpan(text: " "),
          TextSpan(text: value),
          const TextSpan(text: " "),
          TextSpan(text: suffix),
        ])),
      );
    }

    List<Widget> unnamedUserInfos() {
      return [
        unnamedUserInfo(
            "${widget.user.usualFirstName} ${widget.user.lastname.toUpperCase()}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        if (widget.user.title.isNotEmpty) unnamedUserInfo(widget.user.title),
        unnamedUserInfo(widget.user.email),
        unnamedUserInfo(widget.user.location),
        SizedBox(
          height: 16,
          width: MediaQuery.of(context).size.width - 20,
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  child: LinearProgressIndicator(
                    value: _level == 'No cursus'
                        ? 0
                        : double.parse("0.${_level?.split('.')[1]}"),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    backgroundColor: Colors.grey[600],
                    semanticsLabel: "Level",
                    semanticsValue: _level!,
                  ),
                ),
              ),
              Center(
                  child: Text(_level, style: const TextStyle(color: Colors.white),)
              ),
            ],
          ),
        ),
      ];
    }

    List<Widget> namedUserInfos() {
      return [
        Column(
          children: <Widget>[
            namedUserInfo('Wallet', widget.user.wallet.toString(), "₳"),
            namedUserInfo('Evaluation points', widget.user.evaluationPoints.toString()),
          ],
        ),
        Column(
          children: <Widget>[
            namedUserInfo('Primary cursus', widget.user.primaryCursus?.cursus.name ?? 'No cursus'),
            if (_pool != 'none') namedUserInfo('Pool', _pool),
            if (widget.user.isStaff) namedUserInfo('Staff?', 'yes, panic'),
          ],
        ),
      ];
      return [];
    }

    return [
      Column(
        children: unnamedUserInfos(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: namedUserInfos(),
      ),
      Column(
          children: <Widget>[
            if (widget.user.blackholedAt != null) namedUserInfo('Blackholed at', widget.user.blackholedAt!.toLocal().toString()),
          ]
      ),
    ];
  }
}