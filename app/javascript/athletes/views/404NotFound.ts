import BaseView from './baseView';

export default class NotFoundView extends BaseView {
    public load(): void {
        super.prepareView('404 Not Found');

        this.createViewTemplate();
        this.createView();
    }

    protected createViewTemplate(): void {
        // No need to create a template.
    }

    protected createView(): void {
        const content = `
            <div class="error-page">
                <h2 class="headline text-yellow"> 404</h2>

                <div class="error-content">
                    <h3><i class="fa fa-warning text-yellow"></i> Oops! Page not found.</h3>

                    <p>
                        We could not find the page you were looking for.
                        Meanwhile, you may <a href="/">return to homepage</a>.
                    </p>
                </div>
            </div>
        `;

        const mainContent = $('#main-content');
        mainContent.empty();
        mainContent
            .append(content)
            .hide()
            .fadeIn();
    }
}
