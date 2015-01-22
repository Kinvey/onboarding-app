# Kinvey Onboarding Demo App

A simple Angular app, embedded in the Console onboarding workflow.

# Getting Started

To install and run the development server...

```
npm install
npm start
```

# Release Procedure

1. Version and push

```
npm version patch | minor | major
git push && git push --tags
```

2. Build the project

```
grunt build min
```

3. Copy contents of `./min/` to the `public/onboarding-app` directory in the
Console, replacing what is currently there. Commit these changes to the Console.