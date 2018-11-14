import React from 'react';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import withStyles from '@material-ui/core/styles/withStyles';

import headerLinksStyle from './../material-kit-react/Styles/components/headerLinksStyle.jsx';
import SwitchToEnglish from './../SwitchToEnglish';

function HeaderLinks({ ...props }) {
  const { classes } = props;
  return (
    <List className={classes.list + ' header-links'}>
      <ListItem className={classes.listItem}>
        <SwitchToEnglish classes={classes} />
      </ListItem>
    </List>
  );
}

export default withStyles(headerLinksStyle)(HeaderLinks);
