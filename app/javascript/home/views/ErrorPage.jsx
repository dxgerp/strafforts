import React from 'react';
import config from 'react-global-configuration';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';

import imgBackground from './../assets/img/main-bg.jpg';
import HeaderLinks from './Components/ErrorPage/HeaderLinks';
import LandingPageStyle from './Components/LandingPageStyle.jsx';
import Button from './Components/material-kit-react/CustomButtons/Button.jsx';
import GridContainer from './Components/material-kit-react/Grid/GridContainer.jsx';
import GridItem from './Components/material-kit-react/Grid/GridItem.jsx';
import Header from './Components/material-kit-react/Header/Header.jsx';
import Parallax from './Components/material-kit-react/Parallax/Parallax.jsx';
import ButtonConnectWithStrava from "./Components/ButtonConnectWithStrava";

class ErrorPage extends React.Component {
  render() {
    const { classes, errorCode, ...rest } = this.props;

    let buttons;
    if (errorCode === "401") {
      buttons = <ButtonConnectWithStrava />;
    } else {
      buttons = <div>
        <Button href="/" className="btn-default">
          <FormattedMessage id="errors.goToHomePage" />
          </Button>
        <Button href="mailto:support@strafforts.com" className="btn-default">
          <FormattedMessage id="errors.contactUs" />
        </Button>
      </div>;
    }

    return (
      <div>
        <Header
          color="transparent"
          brand={config.get('app.name').toUpperCase()}
          rightLinks={<HeaderLinks />}
          fixed
          {...rest}
        />
        <Parallax filter image={imgBackground} className="error-page parallax">
          <div className={`${classes.container} headline`}>
            <GridContainer>
              <GridItem className="grid-item" xs={12} sm={12} md={6}>
                <h1 className={classes.title}>
                  <FormattedMessage id={`errors.${errorCode}.headline`} />
                </h1>
                <h4>
                  <FormattedMessage id={`errors.${errorCode}.descriptionLine1`} />
                </h4>
                <h4>
                  <FormattedMessage id={`errors.${errorCode}.descriptionLine2`} />
                </h4>
                <br />
                {buttons}
              </GridItem>
            </GridContainer>
          </div>
        </Parallax>
      </div>
    );
  }
}

export default withStyles(LandingPageStyle)(ErrorPage);
