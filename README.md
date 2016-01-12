forty-datetime-directive
========================

Simple angular directive to format and validate date and time inputs


Pushing Instructions
====================

Build:
`grunt build`

Bower:

bower version [<newversion> | major | minor | patch]
Run this in a package directory to bump the version and write the new data back to the bower.json file.

The new version argument should be a valid semver string, or a valid second argument to semver.inc (one of “build”, “patch”, “minor”, or “major”). In the second case, the existing version will be incremented by 1 in the specified field.

If run in a git repo, it will also create a version commit and tag, and fail if the repo is not clean.

version options

-m, --message: Custom git commit and tag message
If supplied with --message (shorthand: -m) config option, bower will use it as a commit message when creating a version commit. If the message config contains %s then that will be replaced with the resulting version number. For example:

$ bower version patch -m "Upgrade to %s for reasons"


Push:
`git push`


Check:
`bower info forty-datetime-directive`
