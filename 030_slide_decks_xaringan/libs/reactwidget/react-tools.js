/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./srcjs/react-tools.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./srcjs/input.js":
/*!************************!*\
  !*** ./srcjs/input.js ***!
  \************************/
/*! exports provided: reactShinyInput */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "reactShinyInput", function() { return reactShinyInput; });
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react */ "react");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react_dom__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react-dom */ "react-dom");
/* harmony import */ var react_dom__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react_dom__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var shiny__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! shiny */ "shiny");
/* harmony import */ var shiny__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(shiny__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var jquery__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! jquery */ "jquery");
/* harmony import */ var jquery__WEBPACK_IMPORTED_MODULE_3___default = /*#__PURE__*/__webpack_require__.n(jquery__WEBPACK_IMPORTED_MODULE_3__);
function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Date.prototype.toString.call(Reflect.construct(Date, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }





/*
 * This default receiveMessage implementation expects data to contain whole
 * configuration and value properties. If either is present, it will be set and
 * the component will be re-rendered. Because receiveMessage is typically used
 * by input authors to perform incremental updates, this default implementation
 * can be overriden by the user with the receiveMessage arguments to
 * reactShinyInput.
 */

function defaultReceiveMessage(el, _ref) {
  var configuration = _ref.configuration,
      value = _ref.value;
  var dirty = false;

  if (configuration !== undefined) {
    this.setInputConfiguration(el, configuration);
    dirty = true;
  }

  if (value !== undefined) {
    this.setInputValue(el, value);
    dirty = true;
  }

  if (dirty) {
    this.getCallback(el)();
    this.render(el);
  }
}

var defaultOptions = {
  receiveMessage: defaultReceiveMessage,
  type: false,
  ratePolicy: null
};
/**
 * Installs a new Shiny input binding based on a React component.
 *
 * @param {string} selector - jQuery selector that should identify the set of
 * container elements within the scope argument of Shiny.InputBinding.find.
 * @param {string} name - A name such as 'acme.FooInput' that should uniquely
 * identify the component.
 * @param {Object} component - React Component, either class or function.
 * @param {Object} options - Additional configuration options. Supported
 * options are:
 * - receiveMessage: Implementation of Shiny.InputBinding to use in place of
 *   the default. Typically overridden as an optimization to perform
 *   incremental value updates.
 * - type: `false`, a string, or a function.
 *     - `false` (the default): denotes that the value produced by this input
 *       should not be intercepted by any handlers registered in R on the
 *       server using shiny::registerInputHandler().
 *     - string: denotes the input's *type* and should correspond to the
 *       type parameter of shiny::registerInputHandler().
 *     - function: A function called with `this` bound to the InputBinding
 *       instance and passed a single argument, the input's containing DOM
 *       element. The function should return either `false` or a string
 *       corresponding to the type parameter of shiny::registerInputHandler().
 * - ratePolicy: A rate policy object as defined in the documentation for
 *     getRatePolicy(): https://shiny.rstudio.com/articles/building-inputs.html
 *     A rate policy object has two members:
 *     - `policy`: Valid values are the strings "direct", "debounce", and
 *       "throttle". "direct" means that all events are sent immediately.
 *     - `delay`: Number indicating the number of milliseconds that should be
 *       used when debouncing or throttling. Has no effect if the policy is
 *       direct.
 *     The specified rate policy is only applied when `true` is passed as the
 *     second argument to the `setValue` function passed as a prop to the
 *     input component.
 *
 */

function reactShinyInput(selector, name, component, options) {
  options = Object.assign({}, defaultOptions, options);
  shiny__WEBPACK_IMPORTED_MODULE_2___default.a.inputBindings.register(new ( /*#__PURE__*/function (_Shiny$InputBinding) {
    _inherits(_class, _Shiny$InputBinding);

    var _super = _createSuper(_class);

    function _class() {
      _classCallCheck(this, _class);

      return _super.apply(this, arguments);
    }

    _createClass(_class, [{
      key: "find",

      /*
       * Methods override those in Shiny.InputBinding
       */
      value: function find(scope) {
        return jquery__WEBPACK_IMPORTED_MODULE_3___default()(scope).find(selector);
      }
    }, {
      key: "getValue",
      value: function getValue(el) {
        return this.getInputValue(el);
      }
    }, {
      key: "setValue",
      value: function setValue(el, value) {
        var rateLimited = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

        /*
         * We have to check whether $(el).data('callback') is undefined here
         * in case shiny::renderUI() is involved. If an input is contained in a
         * shiny::uiOutput(), the following strange thing happens occasionally:
         *
         *   1. setValue() is bound to an el in this.render(), below
         *   2. An event that will call setValue() is enqueued
         *   3. While the event is still enqueued, el is unbound and removed
         *      from the DOM by the JS code associated with shiny::uiOutput()
         *      - That code uses jQuery .html() in output_binding_html.js
         *      - .html() removes el from the DOM and clears ist data and events
         *   4. By the time the setValue() bound to the original el is invoked,
         *      el has been unbound and its data cleared.
         *
         *  Since the original input is gone along with its callback, it
         *  seems to make the most sense to do nothing.
         */
        if (jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('callback') !== undefined) {
          this.setInputValue(el, value);
          this.getCallback(el)(rateLimited);
          this.render(el);
        }
      }
    }, {
      key: "initialize",
      value: function initialize(el) {
        jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('value', JSON.parse(jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).next().text()));
        jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('configuration', JSON.parse(jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).next().next().text()));
      }
    }, {
      key: "subscribe",
      value: function subscribe(el, callback) {
        jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('callback', callback);
        this.render(el);
      }
    }, {
      key: "unsubscribe",
      value: function unsubscribe(el) {
        react_dom__WEBPACK_IMPORTED_MODULE_1___default.a.render(null, el);
      }
    }, {
      key: "receiveMessage",
      value: function receiveMessage(el, data) {
        options.receiveMessage.call(this, el, data);
      }
    }, {
      key: "getType",
      value: function getType(el) {
        if (typeof options.type === 'function') {
          return options.type.call(this, el);
        } else if (options.type === false || typeof options.type === 'string') {
          return options.type;
        } else {
          throw new Error('options.type must be false, a string, or a function');
        }
      }
    }, {
      key: "getRatePolicy",
      value: function getRatePolicy() {
        return options.ratePolicy;
      }
      /*
       * Methods not present in Shiny.InputBinding but accessible to users
       * through `this` in receiveMessage
       */

    }, {
      key: "getInputValue",
      value: function getInputValue(el) {
        return jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('value');
      }
    }, {
      key: "setInputValue",
      value: function setInputValue(el, value) {
        jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('value', value);
      }
    }, {
      key: "getInputConfiguration",
      value: function getInputConfiguration(el) {
        return jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('configuration');
      }
    }, {
      key: "setInputConfiguration",
      value: function setInputConfiguration(el, configuration) {
        jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('configuration', configuration);
      }
    }, {
      key: "getCallback",
      value: function getCallback(el) {
        return jquery__WEBPACK_IMPORTED_MODULE_3___default()(el).data('callback');
      }
    }, {
      key: "render",
      value: function render(el) {
        var element = /*#__PURE__*/react__WEBPACK_IMPORTED_MODULE_0___default.a.createElement(component, {
          configuration: this.getInputConfiguration(el),
          value: this.getValue(el),
          setValue: this.setValue.bind(this, el),
          el: el
        });
        react_dom__WEBPACK_IMPORTED_MODULE_1___default.a.render(element, el);
      }
    }]);

    return _class;
  }(shiny__WEBPACK_IMPORTED_MODULE_2___default.a.InputBinding))(), name);
}

/***/ }),

/***/ "./srcjs/react-tools.js":
/*!******************************!*\
  !*** ./srcjs/react-tools.js ***!
  \******************************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _widget__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./widget */ "./srcjs/widget.js");
/* harmony import */ var _input__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./input */ "./srcjs/input.js");


window.reactR = {
  reactShinyInput: _input__WEBPACK_IMPORTED_MODULE_1__["reactShinyInput"],
  reactWidget: _widget__WEBPACK_IMPORTED_MODULE_0__["reactWidget"],
  hydrate: _widget__WEBPACK_IMPORTED_MODULE_0__["hydrate"]
};

/***/ }),

/***/ "./srcjs/widget.js":
/*!*************************!*\
  !*** ./srcjs/widget.js ***!
  \*************************/
/*! exports provided: hydrate, defaultOptions, mergeOptions, formatDimension, isTag, reactWidget */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "hydrate", function() { return hydrate; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "defaultOptions", function() { return defaultOptions; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "mergeOptions", function() { return mergeOptions; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "formatDimension", function() { return formatDimension; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "isTag", function() { return isTag; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "reactWidget", function() { return reactWidget; });
function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

/**
 * Recursively transforms tag, a JSON representation of an instance of a
 * React component and its children, into a React element suitable for
 * passing to ReactDOM.render.
 * @param {Object} components
 * @param {Object} tag
 */
function hydrate(components, tag) {
  if (typeof tag === 'string') return tag;

  if (tag.name[0] === tag.name[0].toUpperCase() && !components.hasOwnProperty(tag.name)) {
    throw new Error("Unknown component: " + tag.name);
  }

  var elem = components.hasOwnProperty(tag.name) ? components[tag.name] : tag.name,
      args = [elem, tag.attribs];

  for (var i = 0; i < tag.children.length; i++) {
    args.push(hydrate(components, tag.children[i]));
  }

  return React.createElement.apply(React, args);
}
var defaultOptions = {
  // The name of the property on the root tag to use for the width, if
  // it's updated.
  widthProperty: "width",
  // The name of the property on the root tag to use for the height, if
  // it's updated.
  heightProperty: "height",
  // Whether or not to append the string 'px' to the width and height
  // properties when they change.
  appendPx: false,
  // Whether or not to dynamically update the width and height properties
  // of the last known tag when the computed width and height change in
  // the browser.
  renderOnResize: false
};
function mergeOptions(options) {
  var merged = {};

  for (var k in defaultOptions) {
    merged[k] = defaultOptions[k];
  }

  for (var k in options) {
    if (!defaultOptions.hasOwnProperty(k)) {
      throw new Error("Unrecognized option: " + k);
    }

    merged[k] = options[k];
  }

  return merged;
}
function formatDimension(dim, options) {
  if (options.appendPx) {
    return dim + 'px';
  } else {
    return dim;
  }
}
function isTag(value) {
  return _typeof(value) === 'object' && value.hasOwnProperty('name') && value.hasOwnProperty('attribs') && value.hasOwnProperty('children');
}
/**
 * Creates an HTMLWidget that is updated by rendering a React component.
 * React component constructors are made available by specifying them by
 * name in the components object.
 * @param {string} name
 * @param {string} type
 * @param {Object} components
 * @param {Object} options
 */

function reactWidget(name, type, components, options) {
  var actualOptions = mergeOptions(options);
  window.HTMLWidgets.widget({
    name: name,
    type: type,
    factory: function factory(el, width, height) {
      var lastValue,
          instance = {},
          renderValue = function renderValue(value) {
        if (actualOptions.renderOnResize) {
          // value.tag might be a primitive string, in which
          // case there is no attribs property.
          if (_typeof(value.tag) === 'object') {
            value.tag.attribs[actualOptions["widthProperty"]] = formatDimension(width);
            value.tag.attribs[actualOptions["heightProperty"]] = formatDimension(height);
          }

          lastValue = value;
        } // with functional stateless components this will be null
        // see https://reactjs.org/docs/react-dom.html#render for more details


        this.instance.component = ReactDOM.render(hydrate(components, value.tag), el);
      };

      return {
        instance: instance,
        renderValue: renderValue,
        resize: function resize(newWidth, newHeight) {
          if (actualOptions.renderOnResize) {
            width = newWidth;
            height = newHeight;
            renderValue(lastValue);
          }
        }
      };
    }
  });
}

/***/ }),

/***/ "jquery":
/*!********************************!*\
  !*** external "window.jQuery" ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = window.jQuery;

/***/ }),

/***/ "react":
/*!*******************************!*\
  !*** external "window.React" ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = window.React;

/***/ }),

/***/ "react-dom":
/*!**********************************!*\
  !*** external "window.ReactDOM" ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = window.ReactDOM;

/***/ }),

/***/ "shiny":
/*!*******************************!*\
  !*** external "window.Shiny" ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = window.Shiny;

/***/ })

/******/ });
//# sourceMappingURL=react-tools.js.map