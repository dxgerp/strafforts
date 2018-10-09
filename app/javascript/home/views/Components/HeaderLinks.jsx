import React from 'react';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import withStyles from '@material-ui/core/styles/withStyles';

import Button from './material-kit-react/CustomButtons/Button.jsx';
import headerLinksStyle from './material-kit-react/Styles/components/headerLinksStyle.jsx';

function HeaderLinks({ ...props }) {
  const { classes } = props;
  return (
    <List className={classes.list + ' header-links'}>
      <ListItem className={classes.listItem}>
        <Button color="transparent" href="#the-idea" className={classes.navLink}>
          The Idea
        </Button>
        <Button color="transparent" href="#the-demo" className={classes.navLink}>
          The Demo
        </Button>
        <Button color="transparent" href="#the-gurantees" className={classes.navLink}>
          The Gurantees
        </Button>
        <Button color="transparent" href="#the-team" className={classes.navLink}>
          The Team
        </Button>
      </ListItem>
    </List>
  );
}

export default withStyles(headerLinksStyle)(HeaderLinks);
