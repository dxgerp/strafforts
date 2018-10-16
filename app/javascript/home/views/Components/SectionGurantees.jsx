import React from 'react';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';
import Code from '@material-ui/icons/Code';
import ContactSupport from '@material-ui/icons/ContactSupport';
import VerifiedUser from '@material-ui/icons/VerifiedUser';

import InfoAreaIntl from './InfoAreaIntl';
import GridContainer from './material-kit-react/Grid/GridContainer.jsx';
import GridItem from './material-kit-react/Grid/GridItem.jsx';
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
  itemGrid: {
    marginLeft: 'auto',
    marginRight: 'auto',
  },
};

class SectionGurantees extends React.Component {
  render() {
    const { classes } = this.props;
    return (
      <div className={`${classes.section} content-section`}>
        <h2 id="the-gurantees" className={classes.title + ' placeholder-header'} />
        <h2 className={classes.title}>
          <FormattedMessage id="home.sectionGurantees.title" />
        </h2>
        <GridContainer justify="center">
          <GridItem className={classes.itemGrid} xs={12} sm={12} md={8}>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionGurantees.paragraph1" />
            </h4>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionGurantees.paragraph2" />
            </h4>
          </GridItem>
        </GridContainer>
        <div>
          <GridContainer>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                className="infor-area"
                titleTranslationId="home.sectionGurantees.privacy.title"
                descriptionTranslationId="home.sectionGurantees.privacy.description"
                icon={VerifiedUser}
                iconColor="success"
              />
            </GridItem>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                className="infor-area"
                titleTranslationId="home.sectionGurantees.openSource.title"
                descriptionTranslationId="home.sectionGurantees.openSource.description"
                icon={Code}
                iconColor="danger"
              />
            </GridItem>
            <GridItem className={classes.itemGrid} xs={12} sm={12} md={4}>
              <InfoAreaIntl
                titleTranslationId="home.sectionGurantees.support.title"
                descriptionTranslationId="home.sectionGurantees.support.description"
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

export default withStyles(guranteesStyle)(SectionGurantees);
