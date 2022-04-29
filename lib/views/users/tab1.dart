import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';

import '../../models/user.dart';

class Tab1 extends StatefulWidget {
  final OAuth2Helper helper;
  final String login;
  final User user;

  const Tab1({
    Key? key,
    required this.helper,
    required this.login,
    required this.user,
  }) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> with AutomaticKeepAliveClientMixin<Tab1>{
  late final User _user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _level = _user.primaryCursus == null ? 'No cursus' : _user.primaryCursus?.level.toStringAsFixed(2);
    final _pool = () {
      if (_user.poolMonth == 'none' && _user.poolYear == 'none') {
        return "none";
      } else if (_user.poolMonth == 'none' && _user.poolYear != 'none') {
        return _user.poolYear;
      } else if (_user.poolMonth != 'none' && _user.poolYear == 'none') {
        return _user.poolMonth;
      } else {
        return "${_user.poolMonth} ${_user.poolYear}";
      }
    }();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Align to left
      children: <Widget>[
        Image.network(
          _user.imageUrl,
          errorBuilder: (_, __, ___) {
            return Image.network('https://cdn.intra.42.fr/users/default.jpg');
          },
        ),
        userInfo('Full name', _user.usualFullName),
        userInfo('E-mail', _user.email),
        userInfo('Level', _level!),
        userInfo('Location', _user.location),
        userInfo('Pool', _pool),
        if (_user.isStaff) userInfo('Staff', 'yes, panic'),
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