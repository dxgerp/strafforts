import { AppHelpers } from '../helpers/appHelpers';
import { ChartCreator } from '../helpers/chartCreators';
import { HtmlHelpers } from '../helpers/htmlHelpers';
import NotFoundView from './404NotFound';
import BaseView from './baseView';
import NavigationSidebar from './navigationSidebar';

export default class PersonalBestsByDistanceView extends BaseView {
    private count: number;

    private distance: string;

    private distanceFormattedForUrl: string;

    constructor(distance: string, count?: string | undefined) {
        super();

        this.count = count ? parseInt(count, 10) : 0;
        this.distance = distance.trim().replace(/_/g, '/');
        this.distanceFormattedForUrl = AppHelpers.formatDistanceForUrl(distance);
    }

    public load(): void {
        super.prepareView('Personal Bests', this.distance);

        this.createViewTemplate();
        this.createView();
    }

    protected createViewTemplate(): void {
        const mainContent = $('#main-content');
        mainContent.empty(); // Empty main content.

        // Create empty tables and charts with loading icon.
        const showLoadingIcon = true;
        const content = `
            <div class="row">
                ${HtmlHelpers.constructChartHtml(
                    'progression-chart',
                    'Progression Chart (Duration)',
                    8,
                )}
                ${HtmlHelpers.constructChartHtml(
                    'year-distribution-pie-chart',
                    'Year Distribution Chart',
                    4,
                )}
            </div>
            <div class="row">
                ${this.constructDataTableHtml()}
            </div>
            <div class="row">
                ${HtmlHelpers.constructChartHtml('gear-count-chart', 'Gear Count Chart', 6)}
                ${HtmlHelpers.constructChartHtml('workout-type-chart', 'Workout Type Chart', 6)}
            </div>
            <div class="row">
                ${HtmlHelpers.constructChartHtml('heart-rates-chart', 'Heart Rates Chart', 6)}
                ${HtmlHelpers.constructChartHtml(
                    'average-hr-zones-chart',
                    'Average HR Zones Distribution Chart',
                    6,
                )}
            </div>
        `;
        mainContent.append(content);
    }

    protected createView(): void {
        $.ajax({
            url: `${AppHelpers.getApiBaseUrl()}/personal-bests/${this.distanceFormattedForUrl}`,
            dataType: 'json',
            success: (data) => {
                const items = Object.keys(data).map((key) => data[key]);

                if (this.count < items.length) {
                    new NavigationSidebar().load();
                }

                // Create table table.
                this.createDataTable(items);

                // Create all charts.
                const chartCreator = new ChartCreator(items);
                chartCreator.createProgressionChart('progression-chart', false);
                chartCreator.createYearDistributionChart('year-distribution-pie-chart');
                chartCreator.createGearCountChart('gear-count-chart');
                chartCreator.createWorkoutTypeChart('workout-type-chart');
                chartCreator.createHeartRatesChart('heart-rates-chart');
                chartCreator.createAverageHrZonesChart('average-hr-zones-chart');
            },
            error: (xhr) => {
                if (xhr.status === 403) {
                    AppHelpers.goToProPlansPage();
                } else if (xhr.status === 404) {
                    new NotFoundView().load();
                }
            },
        });
    }

    protected constructDataTableHtml(): string {
        const dataTable = `
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header with-border>
                        <i class="fa fa-bar-chart-o"></i><h3 class="box-title">Data Table</h3>
                    </div>
                    <div class="box-body dataTable-wrapper">
                        ${HtmlHelpers.getLoadingIcon()}
                    </div>
                </div>
            </div>
        `;
        return dataTable;
    }

    protected createDataTable(items: any[]) {
        const dataTableContainer = $('.dataTable-wrapper');
        dataTableContainer.empty();

        let rows = '';
        items.forEach((item) => {
            rows += HtmlHelpers.createDatatableRowForBestEffortsOrPbs(item);
        });

        const table = `
            <table class="dataTable table table-bordered table-striped">
                ${HtmlHelpers.createDatatableHeaderForBestEffortsOrPbs()}
                <tbody>
                    ${rows}
                </tbody>
            </table>
        `;
        dataTableContainer.append(table);

        ($('.dataTable') as any).DataTable({
            columnDefs: [
                // Disable searching for WorkoutType, Time, Pace and HRs.
                { targets: [1, 3, 4, 6, 7], searchable: false },
                { orderData: [[0, 'desc'], [4, 'asc']] },
            ],
            iDisplayLength: 10,
            order: [[0, 'desc']],
        });
    }
}
