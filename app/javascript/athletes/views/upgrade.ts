import { AppHelpers } from '../helpers/appHelpers';
import BaseView from './baseView';

export default class UpgradeView extends BaseView {

    public load(): void {
        super.prepareView('Upgrade');

        this.createViewTemplate();
        this.createView();
    }

    protected createViewTemplate(): void { }

    protected createView(): void {
        const content = `
            <div class="row">
                <div class="col-md-4 col-sm-12">
                    <div class="pricingTable green">
                        <div class="pricingTable-header">
                            <h3 class="title">FREE</h3>
                            <span class="sub-title">Lifetime</span>
                            <span class="year">Free <br>Lifetime</span>
                        </div>
                        <div class="price-value">
                            <div class="value">
                                <span class="currency">$</span>
                                <span class="amount">0</span>
                                <span class="month">/forever</span>
                            </div>
                        </div>
                        <div class="pricing-content-container">
                            <h3 class="pricing-content-header">Views</h3>
                            <ul class="pricing-content">
                                <li>Overview</li>
                                <li>Best Efforts</li>
                                <li class="partial-disable">
                                    <span class="has-tooltip" data-toggle="tooltip"
                                        title="Only for Marathon, Half Marathon, 10k and 5k.">
                                        PBs by Distances<i class="fa fa-question-circle" aria-hidden="true"></i>
                                    </span>
                                </li>
                                <li class="partial-disable">
                                    <span class="has-tooltip" data-toggle="tooltip"
                                        title="Only for Marathon, Half Marathon, 10k and 5k.">
                                        Races by Distances<i class="fa fa-question-circle" aria-hidden="true"></i>
                                    </span>
                                </li>
                                <li class="disable">Races Timeline</li>
                                <li class="disable">Races by Year</li>
                            </ul>

                            <h3 class="pricing-content-header">Processor</h3>
                            <ul class="pricing-content">
                                <li class="partial-disable">Every 12 Hours</li>
                                <li class="disable">On Demand</li>
                            </ul>

                            <h3 class="pricing-content-header">Misc.</h3>
                            <ul class="pricing-content">
                                <li class="disable">Reset Profile</li>
                                <li class="disable">Prompt Support</li>
                            </ul>
                        </div>
                        <button class="pricingTable-signup" disabled>Free</button>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="pricingTable yellow">
                        <div class="pricingTable-header">
                            <h3 class="title">PRO</h3>
                            <span class="sub-title">90-day</span>
                            <span class="year">Pay Now<br>$2.99</span>
                        </div>
                        <div class="price-value">
                            <div class="value">
                                <span class="currency">$</span>
                                <span class="amount">0.<span>99</span></span>
                                <span class="month">/month</span>
                            </div>
                        </div>
                        <div class="pricing-content-container">
                            <h3 class="pricing-content-header">Views</h3>
                            <ul class="pricing-content">
                                <li>Overview</li>
                                <li>Best Efforts</li>
                                <li>PBs by Distances</li>
                                <li>Races by Distances</li>
                                <li>Races Timeline</li>
                                <li>Races by Year</li>
                            </ul>

                            <h3 class="pricing-content-header">Processor</h3>
                            <ul class="pricing-content">
                                <li>Every 4 Hours</li>
                                <li>On Demand</li>
                            </ul>

                            <h3 class="pricing-content-header">Misc.</h3>
                            <ul class="pricing-content">
                                <li>Reset Profile</li>
                                <li class="disable">50% Discount</li>
                            </ul>
                        </div>
                        <button class="pricingTable-signup" disabled>Upgrade</button>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="pricingTable">
                        <div class="pricingTable-header">
                            <h3 class="title">PRO </h3>
                            <span class="sub-title">Annually</span>
                            <span class="year">Only <br>$5.99/year</span>
                        </div>
                        <div class="price-value">
                            <div class="value">
                                <span class="currency">$</span>
                                <span class="amount">0.<span>49</span></span>
                                <span class="month">/month</span>
                            </div>
                        </div>
                        <div class="pricing-content-container">
                            <h3 class="pricing-content-header">Views</h3>
                            <ul class="pricing-content">
                                <li>Overview</li>
                                <li>Best Efforts</li>
                                <li>PBs by Distances</li>
                                <li>Races by Distances</li>
                                <li>Races Timeline</li>
                                <li>Races by Year</li>
                            </ul>

                            <h3 class="pricing-content-header">Processor</h3>
                            <ul class="pricing-content">
                                <li>Every 4 Hours</li>
                                <li>On Demand</li>
                            </ul>

                            <h3 class="pricing-content-header">Misc.</h3>
                            <ul class="pricing-content">
                                <li>Reset Profile</li>
                                <li>50% Discount</li>
                            </ul>
                        </div>
                        <button class="pricingTable-signup" disabled>Upgrade</button>
                    </div>
                </div>
            </div>
        `;

        const mainContent = $('#main-content');
        mainContent.empty();
        mainContent.append(content).hide().fadeIn();

        AppHelpers.enableTooltips();
    }
}
