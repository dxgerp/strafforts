import React from 'react';

import withStyles from '@material-ui/core/styles/withStyles';
import Code from '@material-ui/icons/Code';
import ContactSupport from '@material-ui/icons/ContactSupport';
import VerifiedUser from '@material-ui/icons/VerifiedUser';

import GridContainer from './material-kit-react/Grid/GridContainer.jsx';
import GridItem from './material-kit-react/Grid/GridItem.jsx';
import InfoArea from './material-kit-react/InfoArea/InfoArea.jsx';
import { title } from './material-kit-react/Styles/material-kit-react.jsx';

const guranteesStyle = {
  section: {
    padding: '20px 0',
    textAlign: 'center',
  },
  title: {
    ...title,
    marginBottom: '30px',
    marginTop: '30px',
    minHeight: '32px',
    textDecoration: 'none',
  },
  description: {
    color: '#3c4858',
  },
};

class SectionGurantees extends React.Component {
  render() {
    const { classes } = this.props;
    return (
      <div className={classes.section}>
        <h2 id="the-gurantees" className={classes.title + ' placeholder-header'} />
        <h2 className={classes.title}>The Gurantees</h2>
        <GridContainer justify="center">
          <GridItem xs={12} sm={12} md={8}>
            <h5 className={classes.description}>
              Strafforts uses Strava's OAuth2 authentication protocol and v2 API to fetch your running best efforts,
              personal bests and races data, then visualize them and present back to you.
            </h5>
            <h5 className={classes.description}>
              The process doesn't require to store your Strava password at all and would never store any sensitive
              information. To further give you a peace of mind, you can easily delete all running data on Strafforts
              servers anytime.
            </h5>
          </GridItem>
        </GridContainer>
        <div>
          <GridContainer>
            <GridItem xs={12} sm={12} md={4}>
              <InfoArea
                title="Privacy"
                description="We never modify your Strava data or store sensitive data (Strava password, credit cards, etc.)"
                icon={VerifiedUser}
                iconColor="success"
                vertical
              />
            </GridItem>
            <GridItem xs={12} sm={12} md={4}>
              <InfoArea
                title="Open Source"
                description="We are forever open source and currently licensed under GNU Affero General Public License v3.0"
                icon={Code}
                iconColor="danger"
                vertical
              />
            </GridItem>
            <GridItem xs={12} sm={12} md={4}>
              <InfoArea
                title="Support"
                description="I will try my best to answer any queries via email, Facebook, GitHub or even on my Strava profile"
                icon={ContactSupport}
                iconColor="info"
                vertical
              />
            </GridItem>
          </GridContainer>
        </div>
      </div>
    );
  }
}

export default withStyles(guranteesStyle)(SectionGurantees);
