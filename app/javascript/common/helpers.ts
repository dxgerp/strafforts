import * as _ from 'lodash';

import { RgbColor } from './rgbColor';

export namespace Helpers {
    export function convertToRgbaColors(rgbColors: RgbColor[], alpha: number) {
        const colors: string[] = _.map(rgbColors, (item) => {
            return item.toString(alpha);
        });
        return colors;
    }

    export function getBaseUrl() {
        return `${window.location.protocol}//${window.location.host}`;
    }

    export function getRgbColors(limit?: number) {
        const colors: RgbColor[] = [
            new RgbColor(189, 214, 186),
            new RgbColor(245, 105, 84),
            new RgbColor(0, 166, 90),
            new RgbColor(243, 156, 18),
            new RgbColor(64, 127, 127),
            new RgbColor(212, 154, 106),
            new RgbColor(78, 156, 104),
            new RgbColor(212, 166, 106),
            new RgbColor(245, 105, 84),
            new RgbColor(0, 166, 90),
            new RgbColor(243, 156, 18),
            new RgbColor(64, 127, 127),
            new RgbColor(212, 154, 106),
            new RgbColor(78, 156, 104),
        ];
        return limit ? _.take(colors, limit) : colors;
    }

    export function getRgbColorBasedOnHrZone(heartRateZone: string) {
        // Colors defined in app/assets/stylesheets/athletes.scss.
        switch (heartRateZone) {
            case '1':
                return new RgbColor(189, 214, 186);
            case '2':
                return new RgbColor(0, 166, 90);
            case '3':
                return new RgbColor(243, 156, 18);
            case '4':
                return new RgbColor(200, 35, 0);
            case '5':
                return new RgbColor(17, 17, 17);
            default:
                return new RgbColor(210, 214, 222);
        }
    }

    export function getUrlParameter(name: string) {
        // https://davidwalsh.name/query-string-javascript
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        const results = regex.exec(location.search);
        return _.isNull(results) ? null : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }

    export function isTouchDevice() {
        // https://stackoverflow.com/a/4819886/1177636.
        return (
            'ontouchstart' in window || navigator.maxTouchPoints // works on most browsers.
        ); // works on IE10/11 and Surface.
    }

    export function toHHMMSS(duration: number) {
        const hours = _.floor(duration / 3600);
        const minutes = _.floor((duration - hours * 3600) / 60);
        const seconds = _.toInteger(duration - hours * 3600 - minutes * 60);

        const hoursText = hours < 10 ? `0${hours}` : hours;
        const minutesText = minutes < 10 ? `0${minutes}` : minutes;
        const secondsText = seconds < 10 ? `0${seconds}` : seconds;

        const result = `${hoursText}:${minutesText}:${secondsText}`;
        return result;
    }

    export function toPaceString(duration: number, unit: string) {
        const hours = _.floor(duration / 3600);
        const minutes = _.floor((duration - hours * 3600) / 60);
        const seconds = _.ceil(duration - hours * 3600 - minutes * 60);

        const hoursText = hours === 0 ? '' : hours.toString();
        let minutesText = `${minutes.toString()}:`;
        let secondsText = seconds < 10 ? `0${seconds}` : seconds.toString();

        if (seconds === 60) {
            minutesText = `${(minutes + 1).toString()}:`;
            secondsText = '00';
        }
        const time = `${hoursText}${minutesText}${secondsText}${unit}`;
        return time;
    }

    export function toPaceStringForOrdering(pace: string) {
        const result = pace.indexOf(':') > 0 && pace.split(':')[0].length === 1 ? `0${pace}` : pace;
        return result;
    }

    export function toTitleCase(source: string) {
        return source.replace(/\w\S*/g, (text) => {
            return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
        });
    }
}
