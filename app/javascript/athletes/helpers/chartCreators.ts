import * as _ from 'lodash';

import { Helpers } from '../../common/helpers';
import { RgbColor } from '../../common/rgbColor';
import { ChartHelpers, ChartType } from './chartHelper';

export class ChartCreator {
    private items: object[];

    constructor(items: object[]) {
        this.items = items;
    }

    public createProgressionChart(id: string, sortByPace: boolean, yearOnly: boolean = false) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const activityIds: string[] = [];
        const activityNames: string[] = [];
        const dates: string[] = [];
        const runTimes: number[] = [];
        const runTimesFormatted: string[] = [];
        const paces: number[] = [];
        let paceUnit: string;

        this.items.forEach((item) => {
            const activityId = item['activity_id'];
            const activityName = item['activity_name'];
            const runTime = item['elapsed_time'];
            const runTimeFormatted = item['elapsed_time_formatted'];
            const pace = item['pace_in_seconds'];
            paceUnit = item['pace_unit']; // User based, should be the same for all activities.
            activityIds.push(activityId);
            activityNames.push(activityName);
            dates.push(yearOnly ? item['start_date'].split('-')[0] : item['start_date']);
            runTimes.push(runTime);
            runTimesFormatted.push(runTimeFormatted);
            paces.push(pace);
        });

        const chartData: Chart.ChartData = {
            labels: dates,
            datasets: [
                {
                    label: activityNames,
                    activityIds,
                    runTimes,
                    runTimesFormatted,
                    paces,
                    fill: false,
                    lineTension: 0,
                    backgroundColor: 'rgba(75,192,192,0.4)',
                    borderColor: '#FC4C02',
                    borderCapStyle: 'butt',
                    borderDashOffset: 0.0,
                    borderJoinStyle: 'miter',
                    pointBorderColor: '#FC4C02',
                    pointBackgroundColor: '#fff',
                    pointBorderWidth: 1,
                    pointHoverRadius: 5,
                    pointHoverBackgroundColor: '#FC4C02',
                    pointHoverBorderColor: '#E34402',
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    pointHitRadius: 10,
                    pointStyle: 'circle',
                    data: sortByPace ? paces : runTimes,
                    spanGaps: false,
                },
            ],
        };
        const xAxesOptions: object = yearOnly
            ? {
                  gridLines: {
                      display: true,
                  },
              }
            : {
                  gridLines: {
                      display: false,
                  },
                  type: 'time',
                  ticks: {
                      autoSkip: true,
                  },
                  time: {
                      unit: 'month',
                  },
              };
        const customChartOptions: Chart.ChartOptions = {
            scales: {
                xAxes: [xAxesOptions],
                yAxes: [
                    {
                        gridLines: {
                            display: true,
                            offsetGridLines: true,
                        },
                        ticks: {
                            callback: (value: any, index: any, values: any) => {
                                return sortByPace ? Helpers.toPaceString(value, paceUnit) : Helpers.toHHMMSS(value);
                            },
                        },
                    },
                ],
            },
            tooltips: {
                enabled: true,
                mode: 'single',
                callbacks: {
                    title: (tooltipItem: Chart.ChartTooltipItem[], data?: any) => {
                        const index = tooltipItem[0].index;
                        const result = _.isUndefined(index) ? '' : data.datasets[0].label[index];
                        return result;
                    },
                    label: (tooltipItem: Chart.ChartTooltipItem, data?: any) => {
                        const index = tooltipItem.index;
                        if (!_.isUndefined(index)) {
                            const time = data.datasets[0].runTimesFormatted[index];
                            if (tooltipItem.yLabel) {
                                const pace = Helpers.toPaceString(data.datasets[0].paces[index], paceUnit);
                                const date = tooltipItem.xLabel;
                                return `Ran ${time} on ${date} at ${pace}`;
                            }
                        }
                        return '';
                    },
                },
            },
        };

        const chart = ChartHelpers.createLineChart(id, chartData, customChartOptions);
        ChartHelpers.createStravaActivityLink(chart, id);
    }

    public createYearDistributionChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const years: object = {}; // Holds year and its count.
        const workoutTypeRun: object = {}; // Holds year and its count for workout type 'Run'.
        const workoutTypeLongRun: object = {}; // Holds year and its count for workout type 'Long Run'.
        const workoutTypeRace: object = {}; // Holds year and its count for workout type 'Race'.
        const workoutTypeWorkout: object = {}; // Holds year and its count for workout type 'Workout'.

        this.items.forEach((item) => {
            // Calculate how many years need to be included.
            const year = item['start_date'].split('-')[0];
            if (year in years) {
                years[year] += 1;
            } else {
                years[year] = 1;
            }

            // Initialize counter objects.
            if (isNaN(workoutTypeRace[year])) {
                workoutTypeRace[year] = 0;
            }
            if (isNaN(workoutTypeWorkout[year])) {
                workoutTypeWorkout[year] = 0;
            }
            if (isNaN(workoutTypeLongRun[year])) {
                workoutTypeLongRun[year] = 0;
            }
            if (isNaN(workoutTypeRun[year])) {
                workoutTypeRun[year] = 0;
            }

            // Set counters.
            const workoutType = item['workout_type_name'];
            switch (workoutType.toLowerCase()) {
                case 'race':
                    workoutTypeRace[year] += 1;
                    break;
                case 'workout':
                    workoutTypeWorkout[year] += 1;
                    break;
                case 'long run':
                    workoutTypeLongRun[year] += 1;
                    break;
                default:
                    workoutTypeRun[year] += 1;
                    break;
            }
        });

        const datasets = [
            {
                type: 'bar',
                label: 'Run',
                data: _.values(workoutTypeRun),
                backgroundColor: new RgbColor(189, 214, 186).toString(0.6),
                hoverBackgroundColor: new RgbColor(189, 214, 186).toString(1),
            },
            {
                type: 'bar',
                label: 'Long Run',
                data: _.values(workoutTypeLongRun),
                backgroundColor: new RgbColor(0, 166, 90).toString(0.6),
                hoverBackgroundColor: new RgbColor(0, 166, 90).toString(1),
            },
            {
                type: 'bar',
                label: 'Race',
                data: _.values(workoutTypeRace),
                backgroundColor: new RgbColor(245, 105, 84).toString(0.6),
                hoverBackgroundColor: new RgbColor(245, 105, 84).toString(1),
            },
            {
                type: 'bar',
                label: 'Workout',
                data: _.values(workoutTypeWorkout),
                backgroundColor: new RgbColor(243, 156, 18).toString(0.6),
                hoverBackgroundColor: new RgbColor(243, 156, 18).toString(1),
            },
        ];
        const legendLabels = _.keys(years).map((key) => `${key}: (${years[key]})`);

        ChartHelpers.createStackedBarChart(id, _.keys(years), datasets, legendLabels);
    }

    public createWorkoutTypeChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const colors: RgbColor[] = [];
        const counts: number[] = [];
        const workoutTypeLabels: string[] = [];
        const legendLabels: string[] = [];
        const workoutTypes = _.countBy(this.items, (item) => {
            const workoutType = item['workout_type_name'];
            return _.isUndefined(workoutType) ? 'run' : workoutType;
        });

        // Use forEach() to maintain relative order.
        _.forEach(workoutTypes, (value, key) => {
            let color = new RgbColor(189, 214, 186);
            switch (key.toLowerCase()) {
                case 'race':
                    color = new RgbColor(245, 105, 84);
                    break;
                case 'workout':
                    color = new RgbColor(243, 156, 18);
                    break;
                case 'long run':
                    color = new RgbColor(0, 166, 90);
                    break;
            }

            colors.push(color);
            counts.push(value);
            workoutTypeLabels.push(Helpers.toTitleCase(key));
            legendLabels.push(`${Helpers.toTitleCase(key)}: (${workoutTypes[key]})`);
        });

        ChartHelpers.createPieChart(id, counts, workoutTypeLabels, legendLabels, ChartType.Doughnut, colors);
    }

    public createMonthlyDistributionChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const counts: number[] = [];
        const monthLabels: string[] = [];
        const legendLabels: string[] = [];
        const months = _.countBy(this.items, (item) => {
            const startDate = item['start_date'];
            const dateParts = startDate.split('-');
            const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            const month = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]).getMonth();
            const monthName = monthNames[month];
            return monthName;
        });

        // Use forEach() to maintain relative order.
        _.forEach(months, (value, key) => {
            counts.push(value);
            monthLabels.push(key);
            legendLabels.push(`${key}: (${value})`);
        });

        ChartHelpers.createBarChart(id, counts.reverse(), monthLabels.reverse(), legendLabels.reverse());
    }

    public createRaceDistancesChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const counts: number[] = [];
        const raceDistanceNames: string[] = [];
        const legendLabels: string[] = [];
        const raceDistances = _.countBy(this.items, (item) => {
            const raceDistance = item['race_distance'];
            return raceDistance;
        });

        // Use forEach() to maintain relative order.
        _.forEach(raceDistances, (value, key) => {
            let legendLabel = `${key}: (${value})`;
            if (key.toLowerCase() === 'other distances') {
                // Hack to use 'Other' instead 'Other Distances' in distance bar charts.
                legendLabel = `Other: (${value})`;
            } else if (key.toLowerCase() === 'half marathon') {
                legendLabel = `HM: (${value})`;
            }

            counts.push(value);
            raceDistanceNames.push(key);
            legendLabels.push(legendLabel);
        });

        ChartHelpers.createBarChart(id, counts, raceDistanceNames, legendLabels);
    }

    public createGearCountChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const colors = Helpers.getRgbColors();
        const counts: number[] = [];
        const gearNames: string[] = [];
        const gears = _.countBy(this.items, (item) => {
            const gear = item['gear_name'];
            return gear;
        });

        // Use forEach() to maintain relative order.
        _.forEach(gears, (value, key) => {
            counts.push(value);
            gearNames.push(key);
        });

        if (gearNames.length === 1 && gearNames[0].toLowerCase() === 'unspecified') {
            ChartHelpers.createChartWithNotGearMessage(id);
            return;
        }

        const chartData = {
            labels: gearNames,
            datasets: [
                {
                    data: counts,
                    backgroundColor: Helpers.convertToRgbaColors(colors, 0.6),
                    hoverBackgroundColor: Helpers.convertToRgbaColors(colors, 1),
                },
            ],
        };

        ChartHelpers.createHorizontalBarChart(id, chartData);
    }

    public createGearMileageChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        let distanceUnit: string;
        const gearNamesCollection: object = {}; // Holds Gear and its name.
        const gearMileagesCollection: object = {}; // Holds Gear and its mileage.
        this.items.forEach((item) => {
            // Get distance unit only once, which should be the same on all items.
            if (_.isEmpty(distanceUnit)) {
                distanceUnit = item['distance_unit'];
            }

            const distance = item['distance'];
            const gearName = item['gear_name'];
            if (gearName in gearNamesCollection) {
                gearNamesCollection[gearName] += 1;
                gearMileagesCollection[gearName] += distance;
            } else {
                gearNamesCollection[gearName] = 1;
                gearMileagesCollection[gearName] = distance;
            }
        });

        const gearNames = _.keys(gearNamesCollection);
        const counts = _.keys(gearNamesCollection).map((key) => gearNamesCollection[key]);
        const gearMileages = _.keys(gearMileagesCollection).map((key) => gearMileagesCollection[key]);
        const colors = Helpers.getRgbColors();

        if (gearNames.length === 1 && gearNames[0].toLowerCase() === 'unspecified') {
            ChartHelpers.createChartWithNotGearMessage(id);
            return;
        }

        const chartData = {
            labels: gearNames,
            datasets: [
                {
                    counts,
                    data: gearMileages,
                    backgroundColor: Helpers.convertToRgbaColors(colors, 0.6),
                    hoverBackgroundColor: Helpers.convertToRgbaColors(colors, 1),
                },
            ],
        };

        const customChartOptions: Chart.ChartOptions = {
            tooltips: {
                enabled: true,
                mode: 'single',
                callbacks: {
                    label: (tooltipItem: Chart.ChartTooltipItem, data?: any) => {
                        const datasetIndex = tooltipItem.datasetIndex;
                        const index = tooltipItem.index;
                        if (tooltipItem.xLabel && !_.isUndefined(datasetIndex) && !_.isUndefined(index)) {
                            const mileage = parseFloat(tooltipItem.xLabel).toFixed(1);
                            const count = data.datasets[datasetIndex].counts[index];
                            return `Count: ${count} - Total Mileage: ${mileage} ${distanceUnit}`;
                        }
                        return '';
                    },
                },
            },
        };

        ChartHelpers.createHorizontalBarChart(id, chartData, customChartOptions);
    }

    public createHeartRatesChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const boundaryOffset = 5;
        const radius = 10;

        const activityIds: string[] = [];
        const activityNames: string[] = [];
        const averageHeartRates: number[] = [];
        const bubbleColors: RgbColor[] = [];
        const dates: string[] = [];
        const maxHeartRates: number[] = [];
        const points: object[] = [];

        this.items.forEach((item) => {
            const averageHeartRate = item['average_heartrate'];
            const maxHeartRate = item['max_heartrate'];

            if (averageHeartRate > 0 && maxHeartRate > 0) {
                const activityId = item['activity_id'];
                const activityName = item['activity_name'];
                const date = item['start_date'];
                activityIds.push(activityId);
                activityNames.push(activityName);
                dates.push(date);

                const point = {
                    x: averageHeartRate,
                    y: maxHeartRate,
                    r: radius,
                };
                averageHeartRates.push(averageHeartRate);
                maxHeartRates.push(maxHeartRate);
                points.push(point);

                const bubbleColor = Helpers.getRgbColorBasedOnHrZone(item['average_hr_zone']);
                bubbleColors.push(bubbleColor);
            }
        });

        // Not enough items with HR data to generate chart.
        if (points.length < 1) {
            ChartHelpers.createChartWithNotHrMessage(id);
            return;
        }

        const chartData = {
            datasets: [
                {
                    data: points,
                    label: activityNames,
                    activityIds,
                    backgroundColor: Helpers.convertToRgbaColors(bubbleColors, 0.6),
                    hoverBackgroundColor: Helpers.convertToRgbaColors(bubbleColors, 1),
                },
            ],
        };

        const xAxesLinearTickOptions: Chart.LinearTickOptions = {
            min: Math.min(...averageHeartRates) - boundaryOffset,
            max: Math.max(...averageHeartRates) + boundaryOffset,
        };
        const yAxesLinearTickOptions: Chart.LinearTickOptions = {
            min: Math.min(...maxHeartRates) - boundaryOffset,
            max: Math.max(...maxHeartRates) + boundaryOffset,
        };
        const customChartOptions: Chart.ChartOptions = {
            scales: {
                type: 'linear',
                xAxes: [
                    {
                        ticks: xAxesLinearTickOptions,
                        scaleLabel: {
                            display: true,
                            labelString: 'Average Heart Rate',
                        },
                    },
                ],
                yAxes: [
                    {
                        ticks: yAxesLinearTickOptions,
                        scaleLabel: {
                            display: true,
                            labelString: 'Max Heart Rate',
                        },
                    },
                ],
            },
            tooltips: {
                enabled: true,
                mode: 'single',
                callbacks: {
                    title: (tooltipItem: Chart.ChartTooltipItem[], data?: any) => {
                        const index = tooltipItem[0].index;
                        const result = _.isUndefined(index) ? '' : data.datasets[0].label[index];
                        return result;
                    },
                    label: (tooltipItem: Chart.ChartTooltipItem, data?: any) => {
                        const averageHeartRate = tooltipItem.xLabel;
                        const maxHeartRate = tooltipItem.yLabel;
                        return averageHeartRate && maxHeartRate
                            ? `Avg. HR: ${averageHeartRate} - Max. HR: ${maxHeartRate}`
                            : '';
                    },
                },
            },
        };

        const chart = ChartHelpers.createBubbleChart(id, chartData, customChartOptions);
        ChartHelpers.createStravaActivityLink(chart, id);
    }

    public createAverageHrZonesChart(id: string) {
        if (this.items.length <= 1) {
            ChartHelpers.createChartWithNotEnoughDataMessage(id);
            return;
        }

        const averageHrZoneNames: string[] = ['Zone 1', 'Zone 2', 'Zone 3', 'Zone 4', 'Zone 5', 'Zone N/A'];
        const averageHrZones: object = {
            'Zone 1': 0,
            'Zone 2': 0,
            'Zone 3': 0,
            'Zone 4': 0,
            'Zone 5': 0,
            'Zone N/A': 0,
        };
        const barColors: RgbColor[] = [
            Helpers.getRgbColorBasedOnHrZone('1'),
            Helpers.getRgbColorBasedOnHrZone('2'),
            Helpers.getRgbColorBasedOnHrZone('3'),
            Helpers.getRgbColorBasedOnHrZone('4'),
            Helpers.getRgbColorBasedOnHrZone('5'),
            Helpers.getRgbColorBasedOnHrZone('na'),
        ];

        // Get counts of each zone.
        let totalNaCount: number = 0;
        this.items.forEach((item) => {
            switch (item['average_hr_zone']) {
                case '1':
                    averageHrZones['Zone 1'] += 1;
                    break;
                case '2':
                    averageHrZones['Zone 2'] += 1;
                    break;
                case '3':
                    averageHrZones['Zone 3'] += 1;
                    break;
                case '4':
                    averageHrZones['Zone 4'] += 1;
                    break;
                case '5':
                    averageHrZones['Zone 5'] += 1;
                    break;
                default:
                    averageHrZones['Zone N/A'] += 1;
                    totalNaCount += 1;
                    break;
            }
        });

        const counts = _.keys(averageHrZones).map((key) => averageHrZones[key]);
        const legendLabels = _.keys(averageHrZones).map((key) => `${key}: (${averageHrZones[key]})`);
        const totalCount = counts.reduce((a, b) => a + b);

        // Not enough items with HR data to generate chart.
        if (_.parseInt(totalCount) === totalNaCount) {
            ChartHelpers.createChartWithNotHrMessage(id);
            return;
        }

        const chartData = {
            labels: legendLabels,
            datasets: [
                {
                    data: counts,
                    label: averageHrZoneNames,
                    backgroundColor: Helpers.convertToRgbaColors(barColors, 0.6),
                    hoverBackgroundColor: Helpers.convertToRgbaColors(barColors, 1),
                },
            ],
        };
        const customChartOptions: Chart.ChartOptions = {
            tooltips: {
                callbacks: {
                    title: (tooltipItem: Chart.ChartTooltipItem[], data?: any) => {
                        const index = tooltipItem[0].index;
                        const result = _.isUndefined(index) ? '' : data.datasets[0].label[index];
                        return result;
                    },
                    label: (tooltipItem: Chart.ChartTooltipItem, data?: any) => {
                        return tooltipItem.xLabel ? `Count: ${tooltipItem.xLabel}` : '';
                    },
                },
            },
        };
        ChartHelpers.createHorizontalBarChart(id, chartData, customChartOptions);
    }
}
