/// The package.json template for Flutter projects using semantic-release
const packageJsonTemplate = r'''
{
  "name": "{{APP_NAME}}",
  "version": "1.0.0",
  "description": "Flutter mobile application",
  "private": true,
  "scripts": {
    "release": "semantic-release",
    "release:dry": "semantic-release --dry-run"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/USERNAME/REPO_NAME.git"
  },
  "keywords": [
    "flutter",
    "mobile",
    "app"
  ],
  "author": "",
  "license": "UNLICENSED",
  "devDependencies": {
    "@semantic-release/changelog": "^6.0.3",
    "@semantic-release/commit-analyzer": "^11.1.0",
    "@semantic-release/git": "^10.0.1",
    "@semantic-release/github": "^9.2.6",
    "@semantic-release/release-notes-generator": "^12.1.0",
    "conventional-changelog-conventionalcommits": "^7.0.2",
    "semantic-release": "^23.0.0"
  },
  "release": {
    "branches": [
      "main",
      "master",
      {
        "name": "develop",
        "prerelease": true
      }
    ],
    "plugins": [
      [
        "@semantic-release/commit-analyzer",
        {
          "preset": "conventionalcommits",
          "releaseRules": [
            {
              "type": "feat",
              "release": "minor"
            },
            {
              "type": "fix",
              "release": "patch"
            },
            {
              "type": "perf",
              "release": "patch"
            },
            {
              "type": "refactor",
              "release": "patch"
            },
            {
              "type": "docs",
              "release": false
            },
            {
              "type": "chore",
              "release": false
            },
            {
              "breaking": true,
              "release": "major"
            }
          ]
        }
      ],
      [
        "@semantic-release/release-notes-generator",
        {
          "preset": "conventionalcommits",
          "presetConfig": {
            "types": [
              {
                "type": "feat",
                "section": "Features"
              },
              {
                "type": "fix",
                "section": "Bug Fixes"
              },
              {
                "type": "perf",
                "section": "Performance Improvements"
              },
              {
                "type": "refactor",
                "section": "Code Refactoring"
              },
              {
                "type": "docs",
                "section": "Documentation",
                "hidden": true
              },
              {
                "type": "style",
                "section": "Styles",
                "hidden": true
              },
              {
                "type": "chore",
                "section": "Miscellaneous Chores",
                "hidden": true
              },
              {
                "type": "test",
                "section": "Tests",
                "hidden": true
              },
              {
                "type": "build",
                "section": "Build System",
                "hidden": true
              },
              {
                "type": "ci",
                "section": "Continuous Integration",
                "hidden": true
              }
            ]
          }
        }
      ],
      "@semantic-release/changelog",
      [
        "@semantic-release/git",
        {
          "assets": [
            "CHANGELOG.md",
            "package.json"
          ],
          "message": "chore(release): \${nextRelease.version} [skip ci]\\n\\n\${nextRelease.notes}"
        }
      ],
      "@semantic-release/github"
    ]
  }
}
''';
