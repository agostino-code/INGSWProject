
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controllers/stats_controller.dart';

class StatisticsView extends StatelessWidget {
  StatisticsView({super.key});

  final StatisticsController controller = StatisticsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 32),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset('images/home.svg',),
                        onPressed: () {
                          Navigator.pushNamed(context, '/menu',arguments: false);
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: SvgPicture.asset('images/users.svg'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/users');
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: SvgPicture.asset('images/stats.svg',color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: SvgPicture.asset('images/profile.svg'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile',arguments: false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 300,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SfDateRangePicker(
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                controller.selectedWaiter = null;
                                controller.selectedColor = null;
                                controller.startDate = args.value.startDate;
                                controller.endDate = args.value.endDate;
                              },
                              selectionMode: DateRangePickerSelectionMode.range,
                              maxDate: DateTime.now(),
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller.endDateNotifier,
                        builder: (BuildContext context, DateTime? value,
                            Widget? child) {
                          if (value == null) {
                            return Container();
                          }
                          return FutureBuilder(
                            future: controller.getNumberOfOrdersByWaiter(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<OrdersData>> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!
                                    .every((element) => element.orders == 0)) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      width: 300,
                                      height: 300,
                                      child: Center(
                                        child: Text(
                                          'Nessun ordine in questo periodo!',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ));
                                }
                                return Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SfCircularChart(
                                          title: ChartTitle(
                                            text: 'Ordini per cameriere',
                                            textStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          legend: Legend(
                                            isVisible: true,
                                            position: LegendPosition.bottom,
                                            overflowMode:
                                                LegendItemOverflowMode.wrap,
                                            textStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          series: <CircularSeries>[
                                            // Render pie chart
                                            PieSeries<OrdersData, String>(
                                              startAngle: 90,
                                              endAngle: 90,
                                              dataSource: snapshot.data,
                                              onPointTap:
                                                  (ChartPointDetails args) {
                                                controller.selectedWaiter =
                                                    args.pointIndex!;
                                                controller.selectedColor = args
                                                    .dataPoints![
                                                        args.pointIndex!]
                                                    .color!;
                                              },
                                              pointColorMapper:
                                                  (OrdersData data, _) =>
                              controller.listColors[snapshot.data!.indexOf(data)],
                                              xValueMapper:
                                                  (OrdersData data, _) =>
                                                      data.fullname,
                                              yValueMapper:
                                                  (OrdersData data, _) =>
                                                      data.orders,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                isVisible: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside,
                                                textStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable:
                                          controller.selectedWaiterNotifier,
                                      builder: (BuildContext context,
                                          int? value, Widget? child) {
                                        if (value == null) {
                                          return Container();
                                        }
                                          return FutureBuilder(
                                            future: controller.getTotalforDay(
                                                snapshot.data![value].id),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<TimeData>>
                                                    snapshot1) {
                                              if (snapshot1.hasData) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 50),
                                                  child: Container(
                                                    width: 600,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: SfCartesianChart(
                                                        plotAreaBorderWidth: 0,

                                                        /// X axis as category axis placed here.
                                                        primaryXAxis:
                                                            CategoryAxis(
                                                          majorGridLines:
                                                              const MajorGridLines(
                                                                  width: 0),
                                                          labelStyle: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                          //extend the axis to the edge of the chart
                                                          edgeLabelPlacement:
                                                              EdgeLabelPlacement
                                                                  .shift,
                                                        ),
                                                        primaryYAxis:
                                                            NumericAxis(
                                                                isVisible:
                                                                    false,
                                                                labelFormat:
                                                                    '{value}€'),
                                                        title: ChartTitle(
                                                            text:
                                                                'Comulativo ordini per giorno',
                                                            textStyle:
                                                                TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                              fontSize: 15,
                                                            )),
                                                        series: <ChartSeries>[
                                                          // Render line chart
                                                          LineSeries<TimeData,
                                                              String>(
                                                            dataSource:
                                                                snapshot1.data!,
                                                            xValueMapper:
                                                                (TimeData data,
                                                                        _) =>
                                                                    data.date,
                                                            yValueMapper:
                                                                (TimeData data,
                                                                        _) =>
                                                                    data.total,
                                                            color: controller
                                                                .selectedColor,
                                                            dataLabelSettings:
                                                                DataLabelSettings(
                                                              isVisible: true,
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
