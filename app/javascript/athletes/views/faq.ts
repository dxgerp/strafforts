import { HtmlHelpers } from '../helpers/htmlHelpers';
import { Helpers } from './../../common/helpers';
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
        const fullUrl = `${Helpers.getBaseUrl()}/api/faqs/index`;
        $.ajax({
            url: fullUrl,
            dataType: 'json',
            success: (data) => {
                const categories: string[] = [];
                const faqs: object[] = [];
                $.each(data, (key, value) => {
                    const faq: object = {
                        title: value['title'],
                        content: value['content'],
                        category: value['category'],
                    };
                    faqs.push(faq);
                    if ($.inArray(value['category'], categories) === -1) {
                        categories.push(value['category']);
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
                });
                categories.forEach((category: string, index: number) => {
                    let tabItems = '';
                    faqs.forEach((faq: object) => {
                        if (faq['category'] === category) {
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
