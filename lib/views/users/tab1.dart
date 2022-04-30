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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        userInfo('Full name', widget.user.usualFullName),
        userInfo('E-mail', widget.user.email),
        userInfo('Level', _level!),
        userInfo('Location', widget.user.location),
        userInfo('Pool', _pool),
        if (widget.user.blackholedAt != null) userInfo('Blackoled at', widget.user.blackholedAt!.toLocal().toString()),
        if (widget.user.isStaff) userInfo('Staff', 'yes, panic'),
      ],
    );
  }

  Padding userInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text("$key: $value"),
    );
  }
}