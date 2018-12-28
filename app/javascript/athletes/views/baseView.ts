import { Helpers } from '../../common/helpers';
import { AppHelpers } from '../helpers/appHelpers';

abstract class BaseView {
    protected prepareView(viewType: string, itemName?: string) {
        const viewName = itemName ? `${viewType} - ${Helpers.toTitleCase(itemName)}` : viewType;

        AppHelpers.setContentHeader(viewName);
        AppHelpers.appendToPageTitle(` |  ${viewName}`);
        AppHelpers.resetNavigationItems();
        AppHelpers.setActiveNavigationItem();
    }

    protected abstract load(relativeUrl: string): void;

    protected abstract createViewTemplate(): void;

    protected abstract createView(): void;
}

export default BaseView;
