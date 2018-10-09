import React from 'react';
import ReactDOM from 'react-dom';
import config from 'react-global-configuration';
import { Route, Router, Switch } from 'react-router-dom';

import './assets/scss/material-kit-react.css?v=1.3.0';

import { createBrowserHistory } from 'history';

import configuration from './configuration';
import indexRoutes from './routes/index.jsx';

var hist = createBrowserHistory();

config.set(configuration);

ReactDOM.render(
  <Router history={hist}>
    <Switch>
      {indexRoutes.map((prop, key) => {
        return <Route path={prop.path} key={key} component={prop.component} />;
      })}
    </Switch>
  </Router>,
  document.getElementById('root'),
);
