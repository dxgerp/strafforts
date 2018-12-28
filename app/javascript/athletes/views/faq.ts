import * as _ from 'lodash';

import { Helpers } from '../../common/helpers';
import { HtmlHelpers } from '../helpers/htmlHelpers';
import BaseView from './baseView';

export default class FaqView extends BaseView {
    public load(): void {
        super.prepareView('Frequently Asked Questions');

        this.createViewTemplate();
        this.createView();
    }

    protected createViewTemplate(): void {
        const mainContent = $('#main-content');
        mainContent.empty(); // Empty main content.

        const content = `<div class="pane-faq">${HtmlHelpers.getLoadingIcon()}</div>`;
        mainContent
            .append(content)
            .hide()
            .fadeIn();
    }

    protected createView(): void {
        $.ajax({
            url: `${Helpers.getBaseUrl()}/api/faqs/index`,
            dataType: 'json',
            success: (data) => {
                const categories: string[] = [];
                const faqs: object[] = [];
                const items = _.keys(data).map((key) => data[key]);
                items.forEach((item) => {
                    const faq: object = {
                        title: item['title'],
                        content: item['content'],
                        category: item['category'],
                    };
                    faqs.push(faq);

                    if (_.indexOf(categories, item['category']) === -1) {
                        categories.push(item['category']);
                    }
                });

                const pane = $('#main-content .pane-faq');
                pane.empty();

                let tabHeaders = '';
                let tabContent = '';
                categories.forEach((category: string, index: number) => {
                    tabHeaders += `
                        <li ${index === 0 ? 'class="active"' : ''}>
                            <a href="#${category}" data-toggle="tab">
                                ${Helpers.toTitleCase(category.replace(/-/g, ' '))}
                            </a>
                        </li>
                    `;

                    let tabItems = '';
                    faqs.forEach((faq: object) => {
                        if (_.isEqual(faq['category'], category)) {
                            tabItems += `
                                <div class="box box-default">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">${faq['title']}</h3>
                                    </div>
                                    <div class="box-body">
                                        <div class="box box-solid">
                                            <div class="box-body">
                                                ${faq['content']}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        }
                    });
                    tabContent += `
                        <div class="tab-pane ${index === 0 ? 'active' : ''}" id="${category}">
                            ${tabItems}
                        </div>
                    `;
                });

                const content = `
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            ${tabHeaders}
                        </ul>
                        <div class="tab-content">
                            ${tabContent}
                        </div>
                    </div>
                `;
                pane.append(content)
                    .hide()
                    .fadeIn();
            },
        });
    }
}
