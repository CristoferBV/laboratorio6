import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding * 3,
                ),
                Image.asset(
                  "assets/logo/logo_icon.png",
                  scale: 5,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text("Smart HR - Application")
              ],
            )),
            DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Posts",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostsScreen()),
                );
              },
            ),
            DrawerListTile(
              title: "Pages",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Categories",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Appearance",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Tools",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        // ignore: deprecated_member_use
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('TarjetaCedula').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Indentificacion'),
              ),
              DataColumn(
                label: Text('Nombre'),
              ),
              DataColumn(
                label: Text('Primer Apellido'),
              ),
              DataColumn(
                label: Text('Segundo Apellido'),
              ),
              DataColumn(
                label: Text('Fecha Nacimiento'),
              ),
              DataColumn(
                label: Text('Lugar de Nacimiento'),
              ),
              DataColumn(
                label: Text('Fecha Vencimiento'),
              ),
            ],
            rows: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(data['identificacion'])),
                  DataCell(Text(data['nombre'])),
                  DataCell(Text(data['primerApellido'])),
                  DataCell(Text(data['segundoApellido'])),
                  DataCell(Text((data['fechaNacimiento'] as Timestamp)
                      .toDate()
                      .toString())),
                  DataCell(Text(data['lugarNacimiento'])),
                  DataCell(Text(
                      (data['vencimiento'] as Timestamp).toDate().toString())),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
