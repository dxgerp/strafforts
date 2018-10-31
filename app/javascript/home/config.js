const configuration = {
  app: {
    name: 'Strafforts',
    demoAthleteId: '9123806',
    gitHubUrl: 'https://github.com/yizeng/strafforts',
    licenseUrl: 'https://github.com/yizeng/strafforts/blob/master/LICENSE',
    founder: {
      stravaId: '9123806',
      website: 'https://yizeng.me',
    },
    redirectUriPath: '/auth/exchange-token',
    stravaApiClientId: process.env.STRAVA_API_CLIENT_ID,
  },
};

export default configuration;
