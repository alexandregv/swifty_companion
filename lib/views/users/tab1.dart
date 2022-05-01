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

class _Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin<Tab1>{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _level = widget.user.primaryCursus == null ? 'No cursus' : widget.user.primaryCursus?.level.toStringAsFixed(2);
    final _pool = () {
      if (widget.user.poolMonth == 'none' && widget.user.poolYear == 'none') {
        return "none";
      } else if (widget.user.poolMonth == 'none' && widget.user.poolYear != 'none') {
        return widget.user.poolYear;
      } else if (widget.user.poolMonth != 'none' && widget.user.poolYear == 'none') {
        return widget.user.poolMonth;
      } else {
        return "${widget.user.poolMonth} ${widget.user.poolYear}";
      }
    }();

    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: widget.userImage,
                ),
              ),
            ),
            unnamedUserInfo("${widget.user.usualFirstName} ${widget.user.lastname.toUpperCase()}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (widget.user.title.isNotEmpty) unnamedUserInfo(widget.user.title),
            unnamedUserInfo(widget.user.email),
            unnamedUserInfo(widget.user.location),
            namedUserInfo('Lvl', _level!.toString()),
            namedUserInfo('Wallet', widget.user.wallet.toString(), "₳"),
            namedUserInfo('Evaluation points', widget.user.evaluationPoints.toString()),
            namedUserInfo('Primary cursus', widget.user.primaryCursus?.cursus.name ?? 'No cursus'),
            //userInfo('Pool', _pool),
            if (widget.user.blackholedAt != null) namedUserInfo('Blackholed at', widget.user.blackholedAt!.toLocal().toString()),
            if (widget.user.isStaff) namedUserInfo('Staff?', 'yes, panic'),
          ],
        )
    );
  }

  Padding unnamedUserInfo(String value, {String? suffix = "", TextStyle? style = const TextStyle()}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(value + (suffix != null  && suffix.isNotEmpty ? " $suffix" : ""), style: style),
    );
  }
  Padding namedUserInfo(String key, String value, [String? suffix]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text.rich(
          TextSpan(
              children: <TextSpan>[
                TextSpan(text: key, style: const TextStyle(color: Colors.deepPurple)),
                const TextSpan(text: " "),
                TextSpan(text: value),
                const TextSpan(text: " "),
                TextSpan(text: suffix),
              ]
          )
      ),
    );
  }
}