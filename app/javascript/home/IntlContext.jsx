import React from 'react';
import { addLocaleData, IntlProvider } from 'react-intl';
import localeData_en from 'react-intl/locale-data/en';
import localeData_cs from 'react-intl/locale-data/cs';
import localeData_da from 'react-intl/locale-data/da';
import localeData_de from 'react-intl/locale-data/de';
import localeData_nl from 'react-intl/locale-data/nl';
import localeData_ru from 'react-intl/locale-data/ru';
import localeData_zh from 'react-intl/locale-data/zh';

import translations_en from './translations/en.json';
import translations_cs from './translations/cs.json';
import translations_da from './translations/da.json';
import translations_de from './translations/de.json';
import translations_nl from './translations/nl.json';
import translations_ru from './translations/ru.json';
import translations_zh_CN from './translations/zh_CN.json';

addLocaleData([
  ...localeData_en,
  ...localeData_cs,
  ...localeData_da,
  ...localeData_de,
  ...localeData_nl,
  ...localeData_ru,
  ...localeData_zh
]);

const { Provider, Consumer } = React.createContext();

// https://stackoverflow.com/a/51556636/1177636.
class IntlProviderWrapper extends React.Component {
  constructor(...args) {
    super(...args);

    const translations = {
      en: translations_en,
      cs: translations_cs,
      da: translations_da,
      de: translations_de,
      nl: translations_nl,
      ru: translations_ru,
      zh: translations_zh_CN,
    };

    let language =
      (navigator.languages && navigator.languages[0]) || navigator.language || navigator.userLanguage || 'en';
    let locale = language.split(/[-_]/)[0]; // Language without region code.

    // If there is no translations found for this language,
    // check if the locale is found, otherwise use default 'en'.
    // For example, when 'en-US' doesn't have translations, but 'en' is found, use 'en' instead.
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
