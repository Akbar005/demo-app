import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoppingapp/constants.dart';

import '../../models/models.dart';

class ItemDetailsSreen extends StatefulWidget {
  final MGrocery item;
  static const routeName = 'item-details-screen/';
  const ItemDetailsSreen({Key key, this.item}) : super(key: key);

  @override
  _ItemDetailsSreenState createState() => _ItemDetailsSreenState();
}

class _ItemDetailsSreenState extends State<ItemDetailsSreen>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              header(widget.item, context),
              details(widget.item),
              const SizedBox(height: 15),
              Divider(color: kBorderColor),
            ],
          ),
        ),
      ),
    );
  }

  details(MGrocery item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: kTitleStyle.copyWith(fontSize: 18),
              ),
              SvgPicture.asset(
                'lib/assets/icons/favorite.svg',
                color: kBlackColor.withOpacity(0.7),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.category,
            style: kDescriptionStyle,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.horizontal_rule,
                color: kBlackColor.withOpacity(0.7),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1',
                  style: kTitleStyle,
                ),
              ),
              Icon(Icons.add, color: kPrimaryColor),
              const Spacer(),
              Text('Rs ${item.price}',
                  style: kTitleStyle.copyWith(fontSize: 18))
            ],
          ),
        ],
      ),
    );
  }

  Widget header(MGrocery item, BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: ClipPath(
        clipper: MyClipper(),
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 15, top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: kSecondaryColor,
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.chevron_left,
                            color: kBlackColor, size: 30),
                      ),
                      SvgPicture.asset('lib/assets/icons/share.svg'),
                    ],
                  ),
                  Hero(
                    tag: item.hashCode,
                    child: Image.asset(
                      item.url,
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxHeight * 0.6,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    throw UnimplementedError();
  }
}
