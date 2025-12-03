# pann-ecological-model
The ecological module of the pann model

## How to install it

To install this model into a fresh Pharo image open the Playground (Ctrl+OP) and execute the following Metacello script (select it and press Do-it all button or Ctrl+D). If you already have Cormas installed, then simly execute the second half of the script.

### Agent-Based Simulation

```st
"Install Cormas"
Metacello new
    repository: 'github://cormas/cormas';
    baseline: 'Cormas';
    load.

"Install this model"
Metacello new
    baseline: 'PannEcolModel';
    repository: 'github://MiaReynaud/pann-ecological-model:main';
    load
```

### Role-Playing Game

```st
"Install the dev version of Cormas"
Metacello new
    repository: 'github://cormas/cormas:dev';
    baseline: 'Cormas';
    load.

"Install the Pann game"
Metacello new
    baseline: 'PannEcolModel';
    repository: 'github://MiaReynaud/pann-ecological-model:game';
    onConflict: [ :e | e useIncoming ];
    onUpgrade: [ :e | e useIncoming ];
    onWarning: [ :e | e load ];
    ignoreImage;
    load
```
