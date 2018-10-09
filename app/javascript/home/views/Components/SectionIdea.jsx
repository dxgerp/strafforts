import React from 'react';

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
            <h2 className={classes.title}>The Idea</h2>
            <h4 className={classes.description}>How many times have you wondered...</h4>
            <h4 className={classes.description}>
              What's my half marathon PB progression like? What're my fastest shoes for a 10K race? How many 5K races do
              I do every year? How often do I set a marathon PB?...
            </h4>
            <h4 className={classes.description}>Wish Strava had all those analysis built-in!</h4>
            <h4 className={classes.description}>
              No worries at all. Strafforts was born to visualize those data in forms of data tables, line charts, pie
              charts etc to help you understand how you perform!
            </h4>
          </GridItem>
        </GridContainer>
      </div>
    );
  }
}

export default withStyles(ideaStyle)(SectionIdea);
