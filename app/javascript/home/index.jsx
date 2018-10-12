import React from 'react';
import ReactDOM from 'react-dom';
import config from 'react-global-configuration';
import { addLocaleData, IntlProvider } from 'react-intl';
import localeData_en from 'react-intl/locale-data/en';
import localeData_zh from 'react-intl/locale-data/zh';
import { Route, Router, Switch } from 'react-router-dom';

import './assets/scss/material-kit-react.css?v=1.3.0';

import { createBrowserHistory } from 'history';

import configFile from './config';
import indexRoutes from './routes/index.jsx';
import translations_en from './translations/en.json';
import translations_zh_CN from './translations/zh_CN.json';

var hist = createBrowserHistory();

config.set(configFile);

addLocaleData([...localeData_en, ...localeData_zh]);

const translations = {
  en: translations_en,
  zh: translations_zh_CN,
};

let language = (navigator.languages && navigator.languages[0]) || navigator.language || navigator.userLanguage || 'en';
const locale = language.split(/[-_]/)[0]; // Language without region code.
// If there is no translations found for this language,
// check if the locale is found, otherwise use default 'en'.
// For example, when 'en-US' doesn't have tranlastions, but 'en' is found, use 'en' instead.
if (!(language in translations)) {
  language = locale in translations ? locale : 'en';
}

ReactDOM.render(
  <IntlProvider locale={locale} messages={translations[language]}>
    <Router history={hist}>
      <Switch>
        {indexRoutes.map((prop, key) => {
          return <Route path={prop.path} key={key} component={prop.component} />;
        })}
      </Switch>
    </Router>
  </IntlProvider>,
  document.getElementById('root'),
);
