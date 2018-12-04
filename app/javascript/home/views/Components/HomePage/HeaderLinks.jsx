import React from 'react';
import { FormattedMessage } from 'react-intl';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import withStyles from '@material-ui/core/styles/withStyles';

import Button from './../material-kit-react/CustomButtons/Button.jsx';
import headerLinksStyle from './../material-kit-react/Styles/components/headerLinksStyle.jsx';
import SwitchToEnglish from './../SwitchToEnglish';

function HeaderLinks({ ...props }) {
  const { classes } = props;
  return (
    <List className={classes.list + ' header-links'}>
      <ListItem className={classes.listItem}>
        <Button color="transparent" href="#the-idea" className={classes.navLink}>
          <FormattedMessage id="home.sectionIdea.title" />
        </Button>
        <Button color="transparent" href="#the-demo" className={classes.navLink}>
          <FormattedMessage id="home.sectionDemo.title" />
        </Button>
        <Button color="transparent" href="#the-guarantees" className={classes.navLink}>
          <FormattedMessage id="home.sectionGuarantees.title" />
        </Button>
        <Button color="transparent" href="#the-team" className={classes.navLink}>
          <FormattedMessage id="home.sectionTeam.title" />
        </Button>
      </ListItem>
      <ListItem className={classes.listItem}>
        <SwitchToEnglish classes={classes} />
      </ListItem>
    </List>
  );
}

export default withStyles(headerLinksStyle)(HeaderLinks);
