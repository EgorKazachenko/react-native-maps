import PropTypes from 'prop-types';
import React from 'react';

import { ViewPropTypes, View, findNodeHandle, Platform, NativeModules } from 'react-native';

import decorateMapComponent, {
  USES_DEFAULT_IMPLEMENTATION,
  SUPPORTED,
} from './decorateMapComponent';

// if ViewPropTypes is not defined fall back to View.propType (to support RN < 0.44)
const viewPropTypes = ViewPropTypes || View.propTypes;

const propTypes = {
  ...viewPropTypes,

  /**
   * The path template of the local tile source.
   * The patterns {x} {y} {z} will be replaced at runtime,
   * for example, /storage/emulated/0/tiles/{z}/{x}/{y}.png.
   */
  pathTemplate: PropTypes.string.isRequired,

  /**
   * The order in which this tile overlay is drawn with respect to other overlays. An overlay
   * with a larger z-index is drawn over overlays with smaller z-indices. The order of overlays
   * with the same z-index is arbitrary. The default zIndex is -1.
   *
   * @platform android
   */
  zIndex: PropTypes.number,

  /**
   * Size of tile images.
   */
  tileSize: PropTypes.number,
};

class MapLocalTile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      opacity: 1,
    }

    this.forceUpdate = this.forceUpdate.bind(this);
  }
  
  componentDidMount() {
    // const { opacity } = this.props;

    // if (opacity) {
    //   opacity.addListener(({ value }) => this.setState({ opacity: value }));
    // }
  }

  _runCommand(name, args) {
    switch (Platform.OS) {
      case 'android':
        NativeModules.UIManager.dispatchViewManagerCommand(
          this._getHandle(),
          this.getUIManagerCommand(name),
          args
        );
        break;

      case 'ios':
        this.getMapManagerCommand(name)(this._getHandle(), ...args);
        break;

      default:
        break;
    }
  }

  _getHandle() {
    return findNodeHandle(this.tile);
  }

  block = (isBlocked) => {
    this._runCommand('block', [isBlocked]);
  }

  forceUpdate() {
    this._runCommand('forceUpdate', []);
  }
 
  render() {
    const AIRMapLocalTile = this.getAirComponent();
    return <AIRMapLocalTile ref={r => this.tile = r} {...this.props}  />;
  }
}

MapLocalTile.propTypes = propTypes;

export default decorateMapComponent(MapLocalTile, {
  componentType: 'LocalTile',
  providers: {
    google: {
      ios: SUPPORTED,
      android: USES_DEFAULT_IMPLEMENTATION,
    },
  },
});
