import React from 'react';
import Carousel from 'react-slick';

import withStyles from '@material-ui/core/styles/withStyles';

import imgBestEfforts from './../../assets/img/screenshots/best-efforts.png';
import imgOverview from './../../assets/img/screenshots/overview.png';
import imgPbs from './../../assets/img/screenshots/pbs.png';
import imgRacesByDistances from './../../assets/img/screenshots/races-by-distances.png';
import imgRacesByYear from './../../assets/img/screenshots/races-by-year.png';
import imgRacesTimeline from './../../assets/img/screenshots/races-timeline.png';
import Card from './material-kit-react/Card/Card.jsx';
import Button from './material-kit-react/CustomButtons/Button.jsx';
import GridContainer from './material-kit-react/Grid/GridContainer.jsx';
import GridItem from './material-kit-react/Grid/GridItem.jsx';
import { container, title } from './material-kit-react/Styles/material-kit-react.jsx';

const demoStyle = {
  section: {
    padding: '0 0',
  },
  container,
  marginAuto: {
    marginLeft: 'auto !important',
    marginRight: 'auto !important',
  },
  section: {
    padding: '20px 0',
    textAlign: 'center',
  },
  textCenter: {
    textAlign: 'center',
  },
  title: {
    ...title,
    marginTop: '30px',
    minHeight: '32px',
    textDecoration: 'none',
  },
};

class SectionDemo extends React.Component {
  render() {
    const { classes } = this.props;
    const settings = {
      dots: false,
      lazyLoad: true,
      infinite: true,
      speed: 500,
      slidesToShow: 1,
      slidesToScroll: 1,
      autoplay: true,
    };
    return (
      <div className={classes.section}>
        <h2 id="the-demo" className={classes.title + ' placeholder-header'} />
        <h2 className={classes.title}>The Demo</h2>
        <div className={classes.container}>
          <GridContainer>
            <GridItem xs={12} sm={12} md={8} className={classes.marginAuto}>
              <Card carousel>
                <Carousel {...settings}>
                  <div>
                    <img src={imgOverview} alt="Strafforts Overview" className="slick-image" />
                  </div>
                  <div>
                    <img src={imgBestEfforts} alt="Strafforts Best Efforts" className="slick-image" />
                  </div>
                  <div>
                    <img src={imgPbs} alt="Strafforts PBs" className="slick-image" />
                  </div>
                  <div>
                    <img src={imgRacesByDistances} alt="Strafforts Races By Distances" className="slick-image" />
                  </div>
                  <div>
                    <img src={imgRacesTimeline} alt="Strafforts Races Timeline" className="slick-image" />
                  </div>
                  <div>
                    <img src={imgRacesByYear} alt="Strafforts Races By Year" className="slick-image" />
                  </div>
                </Carousel>
              </Card>
            </GridItem>
          </GridContainer>
          <GridContainer className={classes.textCenter} justify="center">
            <GridItem xs={12} sm={12} md={12}>
              <Button size="lg" href="/athletes/9123806" className="btn-default">
                View App Demo
              </Button>
            </GridItem>
          </GridContainer>
        </div>
      </div>
    );
  }
}

export default withStyles(demoStyle)(SectionDemo);
