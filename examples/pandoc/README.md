# ghcjs-commonjs-pandoc
GHCJS CommonJS pandoc example.

## Building
Running:
```
npm install
```

Will install dependencies. To build you can run:
```
npm run build
```

## Running
The generated code should be executable in **Node.js** and the **Browser**, but
only the **Node.js** build has been tested. Usage is:

- Compile with `stack build`
- `node node-main.js`

```javascript
const ghcjsRequire = require('ghcjs-require');
const Main = ghcjsRequire(module, 'ghcjs-commonjs-pandoc');
Main(({ wrapped }) => {
  wrapped.convert('markdown', 'html', '# Hello World')
    .then((res) => console.log(res));
});
```

## Build Time
After 50m I managed to get a runnable on browser output from webpack, by
increasing the maximum heap size to 8GB.
![](/examples/pandoc/screenshot.png)
