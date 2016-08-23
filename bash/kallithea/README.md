get_last_conf
---------------

The first few lines of this script simply point the script at your Kallitea installation. You are supplying the Kallitea BASE URL and the paths for the Kallitea Login services (Note: uncomment the shopt command if you want debug output).

Lines 29-94: Most of this script is dedicated to command line option parsing. As you can see, we’re using getopts to parse an option string and then we’re checking to see if pathId, nameId, and version have been supplied. For convenience, we are also defining some defaults – the extension defaults to xml in this particular script.

Lines 96-99: If your repository is part of a larger project,the name of the project , together with an additional slash(/) is generated to add for URL

Lines 102: This line get last revision of mercurial on chosen branch by defaults - check branch is default
Lines 121-133: This section crafts the parametrs for cURL (as Authentification and Output)

Line 135-38: Once we have the URL, call curl for loging and download artifacts. Note that this script sends to artifact to STDOUT.

Sure, you can do all of this in Ruby, Perl, Python, or Java, but you couldn’t do it with tools that are going to already be present on all Linux installations. You would also need to train people on whatever scripting language you selected. In this, you use bash to interact with kallithea, you can script your deployment and then hand off responsibility to a sysadmin who doesn’t need to understand the finer points of a scripting language.

Notes / Possibilities for Improvement

Here are some directions you could take this script (since this is a Gist at GitHub you can fork the Gist and improve it):

It would be nice if this script automatically downloaded and verified the SHA1 or MD5 hash for a downloaded artifact. Throwing an error if there is a problem.
Sending the artifact to STDOUT may not always be the desired behavior. Just like curl provides the option to save output to a file, so should this script.


Usage
------
```
./get_bundle_from_nexus.sh -s Project -r project-test -a conf:project-test-config -e conf
```
