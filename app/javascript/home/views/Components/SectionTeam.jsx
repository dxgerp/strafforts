import React from 'react';
import config from 'react-global-configuration';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';
import classNames from 'classnames';

import teamMember1 from './../../assets/img/faces/yizeng.jpg';
import Card from './material-kit-react/Card/Card.jsx';
import CardBody from './material-kit-react/Card/CardBody.jsx';
import CardFooter from './material-kit-react/Card/CardFooter.jsx';
import Button from './material-kit-react/CustomButtons/Button.jsx';
import GridContainer from './material-kit-react/Grid/GridContainer.jsx';
import GridItem from './material-kit-react/Grid/GridItem.jsx';
import imagesStyle from './material-kit-react/Styles/imagesStyles.jsx';
import { cardTitle, title } from './material-kit-react/Styles/material-kit-react.jsx';

const teamStyle = {
  section: {
    padding: '20px 0',
    textAlign: 'center',
  },
  title: {
    ...title,
    marginTop: '30px',
    minHeight: '32px',
    textDecoration: 'none',
  },
  ...imagesStyle,
  itemGrid: {
    marginLeft: 'auto',
    marginRight: 'auto',
  },
  cardTitle,
  smallTitle: {
    color: '#6c757d',
  },
  description: {
    color: '#3c4858',
  },
  justifyCenter: {
    justifyContent: 'center !important',
  },
  socials: {
    marginTop: '0',
    width: '100%',
    transform: 'none',
    left: '0',
    top: '0',
    height: '100%',
    lineHeight: '41px',
    fontSize: '20px',
    color: '#3c4858',
  },
  margin5: {
    margin: '5px',
  },
};

class SectionTeam extends React.Component {
  render() {
    const { classes } = this.props;
    const imageClasses = classNames(classes.imgRaised, classes.imgRoundedCircle, classes.imgFluid);
    return (
      <div className={`${classes.section} content-section`}>
        <h2 id="the-team" className={classes.title + ' placeholder-header'} />
        <h2 className={classes.title}>
          <FormattedMessage id="home.sectionTeam.title" />
        </h2>
        <div>
          <GridContainer>
            <GridItem xs={12} sm={12} md={4} className={classes.itemGrid}>
              <Card plain>
                <GridItem xs={6} sm={4} md={6} className={classes.itemGrid}>
                  <img src={teamMember1} alt="Creator of Strafforts" className={imageClasses} />
                </GridItem>
                <h4 className={classes.cardTitle}>
                  Yi Zeng
                  <br />
                  <small className={classes.smallTitle}>
                    <FormattedMessage id="home.sectionTeam.founder" />
                  </small>
                </h4>
                <CardBody>
                  <p className={classes.description}>
                    <FormattedMessage id="home.sectionTeam.founderDescription" />
                  </p>
                </CardBody>
                <CardFooter className={classes.justifyCenter}>
                  <Button
                    justIcon
                    color="transparent"
                    className={classes.margin5}
                    href={config.get('app.founder.website')}
                    target="_blank"
                  >
                    <i className={classes.socials + ' fas fa-home'} />
                  </Button>
                  <Button
                    justIcon
                    color="transparent"
                    className={classes.margin5}
                    href={'https://www.strava.com/athletes/' + config.get('app.founder.stravaId')}
                    target="_blank"
                  >
                    <i className={classes.socials + ' fab fa-strava'} />
                  </Button>
                </CardFooter>
              </Card>
            </GridItem>
          </GridContainer>
        </div>
      </div>
    );
  }
}

export default withStyles(teamStyle)(SectionTeam);
