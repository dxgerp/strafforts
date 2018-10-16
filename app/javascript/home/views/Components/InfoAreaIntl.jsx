import React from 'react';
import { injectIntl, intlShape } from 'react-intl';

import PropTypes from 'prop-types';

import InfoArea from './material-kit-react/InfoArea/InfoArea.jsx';

const InfoAreaIntl = ({ intl, titleTranslationId, descriptionTranslationId, icon, iconColor }) => {
  const title = intl.formatMessage({ id: titleTranslationId });
  const description = intl.formatMessage({ id: descriptionTranslationId });
  return <InfoArea title={title} description={description} icon={icon} iconColor={iconColor} vertical />;
};

InfoAreaIntl.propTypes = {
  intl: intlShape.isRequired,
  icon: PropTypes.func.isRequired,
  titleTranslationId: PropTypes.string.isRequired,
  descriptionTranslationId: PropTypes.string.isRequired,
  iconColor: PropTypes.oneOf(['primary', 'warning', 'danger', 'success', 'info', 'rose', 'gray']),
};

export default injectIntl(InfoAreaIntl);
