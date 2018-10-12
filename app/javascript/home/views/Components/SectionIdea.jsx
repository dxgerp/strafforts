import React from 'react';
import { FormattedMessage } from 'react-intl';

import withStyles from '@material-ui/core/styles/withStyles';

import GridContainer from './material-kit-react/Grid/GridContainer.jsx';
import GridItem from './material-kit-react/Grid/GridItem.jsx';
import { title } from './material-kit-react/Styles/material-kit-react.jsx';

const ideaStyle = {
  section: {
    padding: '20px 0',
  },
  title: {
    ...title,
    marginBottom: '30px',
    marginTop: '30px',
    minHeight: '32px',
    textDecoration: 'none',
    textAlign: 'center',
  },
  description: {
    color: '#3c4858',
    textAlign: 'center',
  },
  textCenter: {
    textAlign: 'center',
  },
  textArea: {
    marginRight: '15px',
    marginLeft: '15px',
  },
};

class SectionIdea extends React.Component {
  render() {
    const { classes } = this.props;
    return (
      <div className={classes.section}>
        <GridContainer justify="center">
          <GridItem cs={12} sm={12} md={8}>
            <h2 id="the-idea" className={classes.title + ' placeholder-header'} />
            <h2 className={classes.title}>
              <FormattedMessage id="home.sectionIdea.title" />
            </h2>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionIdea.paragraph1" />
            </h4>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionIdea.paragraph2" />
            </h4>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionIdea.paragraph3" />
            </h4>
            <h4 className={classes.description}>
              <FormattedMessage id="home.sectionIdea.paragraph4" />
            </h4>
          </GridItem>
        </GridContainer>
      </div>
    );
  }
}

export default withStyles(ideaStyle)(SectionIdea);
