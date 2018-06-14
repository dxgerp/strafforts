/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'bootstrap/dist/css/bootstrap';
import 'font-awesome/css/font-awesome';
import 'admin-lte/plugins/pace/pace.min';
import 'admin-lte/dist/css/AdminLTE.min';
import 'admin-lte/dist/css/skins/skin-black-light.min';
import 'datatables.net-bs/css/dataTables.bootstrap';
import 'toastr/build/toastr';
import '../athletes';
import '../athletes/styles/main';

// Initialize AdminLTE.
var AdminLTEOptions = {
    // Bootstrap.js tooltip.
    enableBSTooltip: true,
    BSTooltipSelector: "[data-toggle='tooltip']",
    enableFastclick: true,
    // Control Sidebar Options.
    enableControlSidebar: true,
    controlSidebarOptions: {
        // Which button should trigger the open/close event.
        toggleBtnSelector: "[data-toggle='control-sidebar']",
        // The sidebar selector.
        selector: '.control-sidebar',
        // Enable slide over content.
        slide: false,
    },
};

Pace.options.ajax.trackWebSockets = false;

// Lazy Loading AddThis plugin.
$('#modal-social-sharing').on('shown.bs.modal', function(e) {
    var script = document.createElement('script');
    script.onload = function() {
        addthis.init();
        $('#modal-social-sharing .loading-icon-panel').remove();
    };
    script.src = '//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-5945b04103f9ff79&domready=1';
    document.head.appendChild(script);
});

// Facebook like button.
(function(d, s, id) {
    var js,
        fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s);
    js.id = id;
    js.src = 'https://connect.facebook.net/en_GB/sdk.js#xfbml=1&version=v2.12';
    fjs.parentNode.insertBefore(js, fjs);
})(document, 'script', 'facebook-jssdk');
