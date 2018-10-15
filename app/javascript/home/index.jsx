import React from 'react';
import ReactDOM from 'react-dom';
import config from 'react-global-configuration';
import { Route, Router, Switch } from 'react-router-dom';

import './assets/scss/material-kit-react.css?v=1.3.0';

import { createBrowserHistory } from 'history';

import configFile from './config';
import { IntlProvider } from './IntlContext';
import indexRoutes from './routes/index.jsx';

var hist = createBrowserHistory();

config.set(configFile);

ReactDOM.render(
  <IntlProvider>
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
