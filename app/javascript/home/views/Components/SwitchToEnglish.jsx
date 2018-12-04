import React from 'react';

import Tooltip from '@material-ui/core/Tooltip';
import { GTranslate } from '@material-ui/icons';

import { IntlConsumer } from '../../IntlContext';
import Button from './material-kit-react/CustomButtons/Button.jsx';

class SwitchToEnglish extends React.Component {
  render() {
    const { classes } = this.props;
    return (
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
    );
  }
}

export default SwitchToEnglish;
