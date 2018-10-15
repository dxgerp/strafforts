import React from 'react';
import { FormattedMessage } from 'react-intl';

import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import withStyles from '@material-ui/core/styles/withStyles';
import Tooltip from '@material-ui/core/Tooltip';
import { GTranslate } from '@material-ui/icons';

import { IntlConsumer } from './../../IntlContext';
import Button from './material-kit-react/CustomButtons/Button.jsx';
import headerLinksStyle from './material-kit-react/Styles/components/headerLinksStyle.jsx';

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
        <Button color="transparent" href="#the-gurantees" className={classes.navLink}>
          <FormattedMessage id="home.sectionGurantees.title" />
        </Button>
        <Button color="transparent" href="#the-team" className={classes.navLink}>
          <FormattedMessage id="home.sectionTeam.title" />
        </Button>
      </ListItem>
      <ListItem className={classes.listItem}>
        <IntlConsumer>
          {({ switchToEnglish }) => (
            <React.Fragment>
              <Tooltip
                id="switch-language-tooltip"
                title="Switch to English"
                placement={window.innerWidth > 959 ? 'top' : 'left'}
                classes={{ tooltip: classes.tooltip }}
              >
                <Button color="transparent" onClick={switchToEnglish} className={classes.navLink}>
                  <GTranslate />
                </Button>
              </Tooltip>
            </React.Fragment>
          )}
        </IntlConsumer>
      </ListItem>
    </List>
  );
}

export default withStyles(headerLinksStyle)(HeaderLinks);
