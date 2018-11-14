import 'core-js/es6/map';
import 'core-js/es6/set';

import React from 'react';
import ReactDOM from 'react-dom';
import config from 'react-global-configuration';
import { Route, Router, Switch } from 'react-router-dom';

import './assets/scss/material-kit-react.css?v=1.3.0';

import { createBrowserHistory } from 'history';

import configFile from './config';
import { IntlProvider } from './IntlContext';
import ErrorPage from './views/ErrorPage.jsx';
import HomePage from './views/HomePage.jsx';

var hist = createBrowserHistory();

config.set(configFile);

const errorPage400 = () => <ErrorPage errorCode="400" />;
const errorPage401 = () => <ErrorPage errorCode="401" />;
const errorPage403 = () => <ErrorPage errorCode="403" />;
const errorPage404 = () => <ErrorPage errorCode="404" />;
const errorPage500 = () => <ErrorPage errorCode="500" />;

ReactDOM.render(
  <IntlProvider>
    <Router history={hist}>
      <Switch>
        <Route path="/errors/400" key="ErrorPage400" component={errorPage400} />
        <Route path="/errors/401" key="ErrorPage401" component={errorPage401} />
        <Route path="/errors/403" key="ErrorPage403" component={errorPage403} />
        <Route path="/errors/404" key="ErrorPage404" component={errorPage404} />
        <Route path="/errors/500" key="ErrorPage500" component={errorPage500} />
        <Route path="/" key="HomePage" component={HomePage} />
      </Switch>
    </Router>
  </IntlProvider>,
  document.getElementById('root'),
);
