# Development notes

## Used libraries with caveats

The following libraries needed some adaptions, and therefore should be updated carefully:

### Bootstrap

Bootstrap `5.1.0` is used, where in the js file located in the `vendor/javascript` folder, the line

```js
import "@popperjs/core";
```

is replaced by

```js
import "@popperjs/core";
let t = Popper;
```

This is such that the included popper js file works.

### Popper.js

Used version is `2.11.0`, but the minified version from the CDN and not the version included by `importmap-rails`, as that version does not work.