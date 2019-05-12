import React from 'react';
import config from 'react-global-configuration';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';
import classNames from 'classnames';

import imgBackground from './../assets/img/main-bg.jpg';
import Footer from './Components/HomePage/Footer';
import HeaderLinks from './Components/HomePage/HeaderLinks';
import SectionDemo from './Components/HomePage/SectionDemo';
import SectionGuarantees from './Components/HomePage/SectionGuarantees';
import SectionIdea from './Components/HomePage/SectionIdea';
import SectionTeam from './Components/HomePage/SectionTeam';
import LandingPageStyle from './Components/LandingPageStyle.jsx';
import GridContainer from './Components/material-kit-react/Grid/GridContainer.jsx';
import GridItem from './Components/material-kit-react/Grid/GridItem.jsx';
import Header from './Components/material-kit-react/Header/Header.jsx';
import Parallax from './Components/material-kit-react/Parallax/Parallax.jsx';
import { title } from './Components/material-kit-react/Styles/material-kit-react.jsx';
import ButtonConnectWithStrava from "./Components/ButtonConnectWithStrava";

const dashboardRoutes = [];

class Homepage extends React.Component {
  render() {
    const { classes, ...rest } = this.props;
    const redirectUri = `${location.protocol}//${location.hostname}${location.port ? ':' + location.port : ''}`;
    const authUrl =
      'https://www.strava.com/oauth/authorize?client_id=' +
      config.get('app.stravaApiClientId') +
      '&response_type=code&redirect_uri=' +
      redirectUri +
      config.get('app.redirectUriPath') +
      '&approval_prompt=auto&scope=read,profile:read_all,activity:read';

    return (
      <div>
        <Header
          color="transparent"
          routes={dashboardRoutes}
          brand={config.get('app.name').toUpperCase()}
          rightLinks={<HeaderLinks />}
          fixed
          changeColorOnScroll={{
            height: 160,
            color: 'white',
          }}
          {...rest}
        />
        <Parallax filter image={imgBackground} className="parallax">
          <div className={`${classes.container} headline`}>
            <GridContainer>
              <GridItem className="grid-item" xs={12} sm={12} md={6}>
                <h1 className={classes.title}>
                  <FormattedMessage id="home.parallax.headline" />
                </h1>
                <h4>
                  <FormattedMessage id="home.parallax.descriptionLine1" />
                </h4>
                <h4>
                  <FormattedMessage id="home.parallax.descriptionLine2" />
                </h4>
                <br />
                <ButtonConnectWithStrava />
              </GridItem>
            </GridContainer>
          </div>
        </Parallax>
        <div className={classNames(classes.main, classes.mainRaised)}>
          <div className={classes.container}>
            <SectionIdea />
            <SectionDemo />
            <SectionGuarantees />
            <SectionTeam />
          </div>
        </div>
        <Footer />
      </div>
    );
  }
}

export default withStyles(LandingPageStyle)(Homepage);
