import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:folio/animations/entrance_fader.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/responsive/responsive.dart';
import 'package:folio/utils/project_utils.dart';
import 'package:folio/utils/utils.dart';

import 'package:folio/widget/tech_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProjectDetail extends StatefulWidget {
  final int index;
  void Function() onBackPressed;
  ProjectDetail({Key? key, required this.index, required this.onBackPressed})
      : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  final CarouselSliderController _controller = CarouselSliderController();
  // ignore: unused_field
  int _currentIndex = 0;

  Widget getButton(
      {String? text, required IconData icon, required void Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EntranceFader(
          offset: const Offset(0, -10),
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 250),
          child: MaterialButton(
            padding: Space.z!,
            hoverColor: AppTheme.c!.primary!.withAlpha(150),
            shape: Responsive.isDesktop(context)
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: AppTheme.c!.primary!,
                    ),
                  )
                : null,
            onPressed: onTap,
            child: Padding(
              padding: Space.all(1.25, 0.45),
              child: Row(children: [
                Icon(icon),
                if (text != null) Space.x1!,
                if (text != null)
                  Text(
                    text,
                    style: AppText.l1b,
                  ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget getSlider(double height, bool isDesktop) {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: ProjectUtils.numOfImages[widget.index],
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 01)),
              child: Image.asset(
                ProjectUtils.images[widget.index] +
                    "${itemIndex.toInt() + 1}.png",
                height: height * 0.9,
              ),
            ),
          ),
          options: CarouselOptions(
            height: height * (isDesktop ? 0.9 : 0.6),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: getButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () {
                setState(() {
                  _controller.previousPage();
                });
              }),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: getButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () {
                setState(() {
                  _controller.nextPage();
                });
              }),
        ),
      ],
    );
  }

  Widget getStoreButton() {
    String playUrl = ProjectUtils.appLinks[widget.index].first;
    String appyUrl = ProjectUtils.appLinks[widget.index][1];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (playUrl.isNotEmpty) ...[
          InkWell(
            onTap: () async {
              if (!await launchUrl(Uri.parse(playUrl))) {
                throw Exception('Could not launch $playUrl');
              }
            },
            child: Image.asset(
              StaticUtils.playstore,
              height: AppDimensions.normalize(20),
            ),
          ),
          Space.x1!
        ],
        if (ProjectUtils.appLinks[widget.index][1].isNotEmpty)
          InkWell(
            onTap: () async {
              if (!await launchUrl(Uri.parse(appyUrl))) {
                throw Exception('Could not launch $appyUrl');
              }
            },
            child: Image.asset(
              StaticUtils.appstore,
              height: AppDimensions.normalize(14),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: Space.h,
      child: Column(
        children: [
          Space.y1!,
          if (!Responsive.isDesktop(context)) ...[
            getButton(
                icon: Icons.arrow_back_ios_new_rounded,
                text: "Back",
                onTap: widget.onBackPressed),
            Space.y1!,
            getSlider(height, Responsive.isDesktop(context)),
            Space.y1!,
            getStoreButton(),
          ],
          if (!Responsive.isDesktop(context))
            SizedBox(
              height: height * 0.03,
            ),
          Row(
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  child: Column(children: [
                    getButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        text: "Back",
                        onTap: widget.onBackPressed),
                    Space.y2!,
                    getSlider(height, Responsive.isDesktop(context)),
                    Space.y1!,
                    getStoreButton(),
                  ]),
                ),
              Expanded(
                flex: width < 1230 ? 2 : 1,
                child: Container(
                  padding: EdgeInsets.only(left: width < 1230 ? 25.0 : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProjectUtils.titles[widget.index],
                        style: AppText.b1!.copyWith(
                          color: AppTheme.c!.primary,
                        ),
                      ),
                      Space.y1!,
                      Text(
                        ProjectUtils.headline[widget.index],
                        style: AppText.b1b!.copyWith(
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Space.y!,
                      Text(
                        ProjectUtils.description[widget.index],
                        style: AppText.b2!.copyWith(
                          height: 2,
                          letterSpacing: 1.1,
                          fontFamily: 'Montserrat',
                          fontSize: AppDimensions.normalize(5),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Space.y!,
                      Divider(
                        color: Colors.grey[800],
                        thickness: AppDimensions.normalize(0.5),
                      ),
                      Space.y!,
                      Text(
                        'Tools & Technologies :',
                        style: AppText.l1!.copyWith(
                          color: AppTheme.c!.primary,
                        ),
                      ),
                      Space.y!,
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        children: ProjectUtils.tools[widget.index]
                            .map((e) => ToolTechWidget(techName: e))
                            .toList(),
                      ),
                      Space.y!,
                      Divider(
                        color: Colors.grey[800],
                        thickness: AppDimensions.normalize(0.5),
                      ),
                      Space.y!,
                      Text(
                        'Features & Functionalities :',
                        style: AppText.l1!.copyWith(
                          color: AppTheme.c!.primary,
                        ),
                      ),
                      Space.y!,
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        children: ProjectUtils.features[widget.index]
                            .map((e) => ToolTechWidget(
                                  techName: e[1],
                                  title: e[0],
                                  flex: 1,
                                  bottomPadding: 5,
                                  style: AppText.b2!.copyWith(
                                    height: 1.5,
                                    letterSpacing: 1,
                                    fontFamily: 'Montserrat',
                                    fontSize: AppDimensions.normalize(5),
                                  ),
                                ))
                            .toList(),
                      ),
                      Space.y!,
                      Divider(
                        color: Colors.grey[800],
                        thickness: AppDimensions.normalize(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: width < 1230 ? width * 0.05 : width * 0.1,
              ),
            ],
          ),
          Space.y2!,
          getButton(
              icon: Icons.arrow_back_ios_new_rounded,
              text: "Back",
              onTap: widget.onBackPressed),
        ],
      ),
    );
  }
}
