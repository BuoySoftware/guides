# Recommended VSCode Configurations

## BuoyRails

This VSCode configuration is designed to help developers maximize productivity by:

1. Provide real time feedback about spelling, styling, linting, testing errors, shorten code / test cycle.
2. Automate as much as possible, such as auto linter fix, formating, auto space/tab style switching.

This will allow the developer to focus on what is important, and leave the less important work to the machine.

### Setup

To use is [VSCode config preset](https://gist.github.com/aq1018/e23670dab88685c628142f7691278f76), simply run the following command in your project directory:

```sh
curl \
  --create-dirs \
  -O https://gist.githubusercontent.com/aq1018/e23670dab88685c628142f7691278f76/raw/extensions.json \
  -O https://gist.githubusercontent.com/aq1018/e23670dab88685c628142f7691278f76/raw/settings.json \
  --output-dir .vscode;

curl \
  -O https://gist.githubusercontent.com/aq1018/e23670dab88685c628142f7691278f76/raw/.editorconfig \
  -O https://gist.githubusercontent.com/aq1018/e23670dab88685c628142f7691278f76/raw/cspell.json
 ```

### Features

#### Spell Checker

Don't wait until your reviewer to point out your spelling errors. Let VSCode help you catch all the spelling errors before they show up on your PR.

![spell-checker](https://user-images.githubusercontent.com/18140/206821720-bd60f35b-f33f-458d-b9b4-6eae18cf0a19.gif)

#### RuboCop Lint Issue Highlighting

Don't wait for 30 minutes and have CI tell you that you didn't pass linting. This plugin points out any rubocop linting issues directly in your code.

<img width="689" alt="Screen Shot 2022-12-07 at 4 53 59 PM" src="https://user-images.githubusercontent.com/18140/206329700-98ee28b5-ce66-4ae4-b5f9-aa0a6e31be93.png">


#### ESLInt Issue Highlighting and Fixing

Unless you like waiting for CI, let the machine help you catch the errors right inside your editor.

<img width="628" alt="Screen Shot 2022-12-07 at 4 56 05 PM" src="https://user-images.githubusercontent.com/18140/206329911-126abc0f-bfa6-443c-b75a-f5dd6cff79ac.png">

#### Auto Fix / Format for Ruby & TypeScript

Just hit save, and your code is formatted according to company guidelines, all fixable errors are auto fixed. You just focus on what important, let the machine worry about boring stuff such as formatting your code.

![auto-fix](https://user-images.githubusercontent.com/18140/206821754-6736c42b-0041-4c95-a2b7-19bc92600090.gif)

#### Integrated Test View

Have all your test cases organized in one place, click a button to run one or all tests.

![test-explorer](https://user-images.githubusercontent.com/18140/206821766-292e637f-80d2-48b9-8ca7-bb3c83ab8561.gif)

#### Apollo Plugin

Syntax highlight and Intellisense for GraphQL. No more guesswork or flipping through docs.

![apollo](https://user-images.githubusercontent.com/18140/206821779-3cb36434-36e4-46e5-8d73-a2fc773941ff.gif)

#### GitLens

Unless you are a git ninja, you will love Inline blame, git history viewer, Git Visualizer.

![gitlens](https://user-images.githubusercontent.com/18140/206821794-e5d506b9-c836-49b2-9517-4bf311320f1a.gif)

### Plugins

- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - Highlights misspelling and suggest words.
- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) - Standardize project specific formatting such as space vs tabs, tab sizes, etc. Supports many many editors.
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - Lots of useful git related features, such as inline blame, etc.
- [Apollo GraphQL](https://marketplace.visualstudio.com/items?itemName=apollographql.vscode-apollo) - Official Apollo GraphQL plugin.
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph) - A Ruby language server featuring code completion, intellisense, and inline documentation.
- [Ruby Test Explorer](https://marketplace.visualstudio.com/items?itemName=connorshea.vscode-ruby-test-adapter) - Run and Export Ruby Specs directly in VSCode.
- [Rubocop](https://marketplace.visualstudio.com/items?itemName=misogi.ruby-rubocop) - Rubocop Linter Integration. Shows linting issues. Auto fix on save.
- [Ruby](https://marketplace.visualstudio.com/items?itemName=wingrunr21.vscode-ruby) - Offical Ruby Plugin.
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) - ESLint plugin. Shows linting issues. Configured to auto fix on save.
- [Jest](https://marketplace.visualstudio.com/items?itemName=Orta.vscode-jest) - Offical Jest Plugin. Run and explore Jest tests inside VSCode.


## DevOps

TL;DR:

Download the [preset](https://gist.github.com/aq1018/89b26864e96305a80821d6aa506394dd):

```sh
curl \
  --create-dirs \
  -O https://gist.githubusercontent.com/aq1018/89b26864e96305a80821d6aa506394dd/raw/extensions.json \
  -O https://gist.githubusercontent.com/aq1018/89b26864e96305a80821d6aa506394dd/raw/settings.json \
  --output-dir .vscode;

curl \
  -O https://gist.githubusercontent.com/aq1018/89b26864e96305a80821d6aa506394dd/raw/.editorconfig \
  -O https://gist.githubusercontent.com/aq1018/89b26864e96305a80821d6aa506394dd/raw/cspell.json
```

### What's included?

* [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) - Official Terraform Plugin, many features, see link for more details.
* [Terraform Format On Save](https://marketplace.visualstudio.com/items?itemName=matheusq94.TFS) - Focus on meaningful work, let the computer do the formatting.
* [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - Highlights misspelling and suggest words.
* [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) - Standardize project specific formatting such as space vs tabs, tab sizes, etc. Supports many many editors.
* [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - Lots of useful git related features, such as inline blame, etc.

