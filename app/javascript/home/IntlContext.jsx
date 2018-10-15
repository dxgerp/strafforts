import React from 'react';
import { addLocaleData, IntlProvider } from 'react-intl';
import localeData_en from 'react-intl/locale-data/en';
import localeData_zh from 'react-intl/locale-data/zh';

import translations_en from './translations/en.json';
import translations_zh_CN from './translations/zh_CN.json';

addLocaleData([...localeData_en, ...localeData_zh]);

const { Provider, Consumer } = React.createContext();

class IntlProviderWrapper extends React.Component {
  constructor(...args) {
    super(...args);

    const translations = {
      en: translations_en,
      zh: translations_zh_CN,
    };

    let language =
      (navigator.languages && navigator.languages[0]) || navigator.language || navigator.userLanguage || 'en';
    let locale = language.split(/[-_]/)[0]; // Language without region code.

    // If there is no translations found for this language,
    // check if the locale is found, otherwise use default 'en'.
    // For example, when 'en-US' doesn't have tranlastions, but 'en' is found, use 'en' instead.
    if (!(language in translations)) {
      if (locale in translations) {
        language = locale;
      } else {
        language = 'en';
        locale = 'en';
      }
    }

    this.switchToEnglish = () => this.setState({ locale: 'en', translations: translations_en });

    this.state = {
      locale: locale,
      translations: translations[language],
      switchToEnglish: this.switchToEnglish,
    };
  }

  render() {
    const { children } = this.props;
    const { locale, translations } = this.state;
    return (
      <Provider value={this.state}>
        <IntlProvider key={locale} locale={locale} messages={translations} defaultLocale="en">
          {children}
        </IntlProvider>
      </Provider>
    );
  }
}

export { IntlProviderWrapper as IntlProvider, Consumer as IntlConsumer };
