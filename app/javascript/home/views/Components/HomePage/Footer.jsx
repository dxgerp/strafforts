import React from 'react';
import config from 'react-global-configuration';
import { FormattedMessage } from 'react-intl';

import { List, ListItem, withStyles } from '@material-ui/core';
import Favorite from '@material-ui/icons/Favorite';
import classNames from 'classnames';
import PropTypes from 'prop-types';

import footerStyle from './../material-kit-react/Styles/components/footerStyle.jsx';

function Footer({ ...props }) {
  const { classes, whiteFont } = props;
  const footerClasses = classNames({
    [classes.footer]: true,
    [classes.footerWhiteFont]: whiteFont,
  });
  const aClasses = classNames({
    [classes.a]: true,
    [classes.footerWhiteFont]: whiteFont,
  });
  return (
    <footer className={footerClasses}>
      <div className={classes.container}>
        <div className={classes.left}>
          <List className={classes.list}>
            <ListItem className={classes.inlineBlock}>
              <a href={config.get('app.gitHubUrl')} className={classes.block} target="_blank">
                <FormattedMessage id="home.footer.github" />
              </a>
            </ListItem>
            <ListItem className={classes.inlineBlock}>
              <a href={config.get('app.licenseUrl')} className={classes.block} target="_blank">
                <FormattedMessage id="home.footer.license" />
              </a>
            </ListItem>
          </List>
        </div>
        <div className={classes.right}>
          &copy; {1900 + new Date().getYear()}, <FormattedMessage id="home.footer.copyrightMessagePartial" />{' '}
          <Favorite className={classes.icon} /> by{' '}
          <a href={config.get('app.founder.website')} className={aClasses} target="_blank">
            Yi Zeng
          </a>
          .
        </div>
      </div>
    </footer>
  );
}

Footer.propTypes = {
  classes: PropTypes.object.isRequired,
  whiteFont: PropTypes.bool,
};

export default withStyles(footerStyle)(Footer);
