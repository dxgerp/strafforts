import { AppHelpers } from '../helpers/appHelpers';
import { ChartCreator } from '../helpers/chartCreators';
import { HtmlHelpers } from '../helpers/htmlHelpers';
import NotFoundView from './404NotFound';
import BaseView from './baseView';

export default class BestEffortsByDistanceView extends BaseView {
    private distance: string;

    private distanceFormattedForUrl: string;

    constructor(distance?: string) {
        super();

        this.distance = distance ? distance.trim().replace(/_/g, '/') : '';
        this.distanceFormattedForUrl = AppHelpers.formatDistanceForUrl(this.distance);
    }

    public load(): void {
        super.prepareView('Top Best Efforts', this.distance);

        this.createFilterButtons();

        if (this.distance) {
            $('.best-efforts-filter-buttons .btn').removeClass('active'); // Reset all currently active filter buttons.
            $(`.best-efforts-filter-buttons .btn[data-race-distance='${this.distance}']`).addClass('active');
            this.createViewTemplate();
            this.createView();
        } else {
            $('.best-efforts-filter-buttons .btn').removeClass('active');
            $('.best-efforts-wrapper').remove();

            if ($('#main-content .best-efforts-filter-buttons .btn').length === 0) {
                $('#main-content').append(HtmlHelpers.getNoDataInfoBox);
            }
        }
    }

    protected createViewTemplate(): void {
        const mainContent = $('#main-content');

        // Create empty tables and charts with loading icon.
        const showLoadingIcon = true;
        const content = `
            <div class="best-efforts-wrapper">
                <div class="row">
                    ${HtmlHelpers.constructChartHtml('progression-by-year-chart', 'Progression Chart (By Year)', 4)}
                    ${HtmlHelpers.constructChartHtml('year-distribution-pie-chart', 'Year Distribution Chart', 4)}
                    ${HtmlHelpers.constructChartHtml('workout-type-chart', 'Workout Type Chart', 4)}
                </div>
                <div class="row">
                    ${this.constructDataTableHtml()}
                </div>
                <div class="row">
                    ${HtmlHelpers.constructChartHtml('gear-count-chart', 'Gear Count Chart', 12)}
                </div>
            </div>
        `;
        $('.best-efforts-wrapper').remove();
        mainContent.append(content);
    }

    protected createView(): void {
        $.ajax({
            url: `${AppHelpers.getApiBaseUrl()}/best-efforts/${this.distanceFormattedForUrl}/top-one-by-year`,
            dataType: 'json',
            success: (data) => {
                const items = Object.keys(data).map((key) => data[key]);
                const result = {};
                items.forEach((item: any) => {
                    const year = item['start_date'].split('-')[0];
                    if (!result[year] || (result[year] && item['elapsed_time'] < result[year]['elapsed_time'])) {
                        result[year] = item;
                    }
                });
                const progressionByYearItems = Object.keys(result).map((key) => result[key]);
                const progressionChartCreator = new ChartCreator(progressionByYearItems);
                progressionChartCreator.createProgressionChart('progression-by-year-chart', false, true);
            },
            error: (xhr) => {
                if (xhr.status === 404) {
                    new NotFoundView().load();
                }
            },
        });

        $.ajax({
            url: `${AppHelpers.getApiBaseUrl()}/best-efforts/${this.distanceFormattedForUrl}`,
            dataType: 'json',
            success: (data) => {
                const items = Object.keys(data).map((key) => data[key]);

                // Create table table.
                this.createDataTable(items);

                // Create all charts.
                const chartCreator = new ChartCreator(items);
                chartCreator.createYearDistributionChart('year-distribution-pie-chart');
                chartCreator.createWorkoutTypeChart('workout-type-chart');
                chartCreator.createGearCountChart('gear-count-chart');
            },
            error: (xhr) => {
                if (xhr.status === 404) {
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
                { targets: [1, 3, 4], searchable: false },
                { orderData: [[4, 'asc'], [3, 'asc'], [0, 'desc']] },
            ],
            iDisplayLength: 10,
            order: [[3, 'asc']],
        });
    }

    private createFilterButtons() {
        if ($('#main-content .best-efforts-filter-buttons .btn').length === 0) {
            // Empty everything first (i.e. Loading Icon).
            const mainContent = $('#main-content');
            mainContent.empty();

            let fileterButtons = '';
            $.ajax({
                url: `${AppHelpers.getApiBaseUrl()}/meta`,
                dataType: 'json',
                async: false,
                success: (data) => {
                    data['best_efforts'].forEach((item: any) => {
                        const bestEffortType = item['name'];
                        if (bestEffortType && item['count'] > 0) {
                            fileterButtons += `
                                <button class="btn btn-md btn-race-distance"
                                    data-race-distance="${bestEffortType.toLowerCase()}">${bestEffortType}</button>
                            `;
                        }
                    });
                },
            });
            $('#main-content').append(`
                <div class="row best-efforts-filter-buttons">
                    <div class="col-xs-12 text-center">
                        ${fileterButtons}
                    </div>
                </div>
            `);
        }
    }
}
