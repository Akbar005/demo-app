import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoppingapp/constants.dart';
import 'package:shoppingapp/models/models.dart';
import 'package:shoppingapp/screens/item_details_screen/ItemDetailsScreen.dart';

import '../../mq.dart';
import '../loader_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    Key key,
  }) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<MGrocery> _items;
  bool isLoading = false;
  List urlList = [
    'lib/assets/images/apples.png',
    'lib/assets/images/mango1.jpg',
    'lib/assets/images/bananas.png',
    'lib/assets/images/orange.jpg'
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(vsync: this, length: _banners.length);
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    await readJson();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('lib/jsonfile/productList.json');
    Iterable data = await json.decode(response);
    _items = [];
    if (data != null) {
      _items = data.map((e) => MGrocery.fromJson(e)).toList();
    }
    for (int i = 0; i < _items.length; i++) {
      _items[i].url = urlList[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    return SafeArea(
      child: isLoading == true
          ? const LoaderScreen()
          : SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Column(
                  children: [
                    SvgPicture.asset('lib/assets/icons/carrot.svg'),
                    const SizedBox(height: 5),
                    const Text('Grocery App'),
                    const SizedBox(height: 10),
                    searchFeild(),
                    const SizedBox(height: 10),
                    banners(),
                    const SizedBox(height: 10),
                    _buildSectiontitle('Exclusive Offers', () {}),
                    exclusiveOffers(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectiontitle(String title, [Function onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kTitleStyle.copyWith(fontSize: 18),
          ),
          InkWell(
            onTap: onTap ?? () {},
            child: Text(
              'See all',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget exclusiveOffers() {
    return SizedBox(
      height: MQuery.height * 0.3,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (_, i) => groceryItem(_items[i]),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
      ),
    );
  }

  groceryItem(MGrocery item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ItemDetailsSreen(item: item)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: MQuery.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColor, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: item.hashCode,
                  child: Image.asset(
                    item.url,
                    height: constraints.maxHeight * 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(item.name, style: kTitleStyle),
                Text("${item.availability}Kg", style: kDescriptionStyle),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs ${item.price}',
                      style: kTitleStyle.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget searchFeild() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search...',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset('lib/assets/icons/search.svg'),
          ),
        ),
      ),
    );
  }

  Widget banners() {
    return SizedBox(
      height: MQuery.height * 0.2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TabBarView(
            children: _banners,
            controller: _tabController,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_banners.length, (index) {
                  return PageIndicator(
                    index: index,
                    controller: _tabController,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Widget> _banners = List.generate(
    3,
    (index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Image.asset(
        'lib/assets/images/vegs_banner.png',
        fit: BoxFit.fill,
      ),
    ),
  );
}

class PageIndicator extends StatefulWidget {
  final int index;
  final TabController controller;
  const PageIndicator({
    Key key,
    this.index,
    this.controller,
  }) : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.index == widget.controller.index;

    widget.controller.addListener(() {
      setState(() {
        _expanded = widget.index == widget.controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _expanded ? 15 : 5,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: _expanded ? kPrimaryColor : Colors.grey,
      ),
    );
  }
}
