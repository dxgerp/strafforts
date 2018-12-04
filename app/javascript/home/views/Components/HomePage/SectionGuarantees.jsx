import React from 'react';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';
import Code from '@material-ui/icons/Code';
import ContactSupport from '@material-ui/icons/ContactSupport';
import VerifiedUser from '@material-ui/icons/VerifiedUser';

import InfoAreaIntl from './InfoAreaIntl';
import GridContainer from './../material-kit-react/Grid/GridContainer.jsx';
import GridItem from './../material-kit-react/Grid/GridItem.jsx';
import { title } from './../material-kit-react/Styles/material-kit-react.jsx';

const guaranteesStyle = {
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
  itemGrid: {
    marginLeft: 'auto',
    marginRight: 'auto',
  },
};

class SectionGuarantees extends React.Component {
  render() {
    const { classes } = this.props;
    return (
      <div className={`${classes.section} content-section`}>
        <h2 id="the-guarantees" className={classes.title + ' placeholder-header'} />
        <h2 className={classes.title}>
          <FormattedMessage id="home.sectionGuarantees.title" />
        </h2>
        <GridContainer justify="center">
          <GridItem className={classes.itemGrid} xs={12} sm={12} md={8}>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionGuarantees.paragraph1" />
            </h4>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionGuarantees.paragraph2" />
            </h4>
          </GridItem>
        </GridContainer>
        <div>
          <GridContainer>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                className="info-area"
                titleTranslationId="home.sectionGuarantees.privacy.title"
                descriptionTranslationId="home.sectionGuarantees.privacy.description"
                icon={VerifiedUser}
                iconColor="success"
              />
            </GridItem>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                className="info-area"
                titleTranslationId="home.sectionGuarantees.openSource.title"
                descriptionTranslationId="home.sectionGuarantees.openSource.description"
                icon={Code}
                iconColor="danger"
              />
            </GridItem>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                titleTranslationId="home.sectionGuarantees.support.title"
                descriptionTranslationId="home.sectionGuarantees.support.description"
                icon={ContactSupport}
                iconColor="info"
              />
            </GridItem>
          </GridContainer>
        </div>
      </div>
    );
  }
}

export default withStyles(guaranteesStyle)(SectionGuarantees);
