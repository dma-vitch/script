get_bundle_nexus
---------------

The first few lines of this script simply point the script at your Nexus installation. You are supplying the Nexus BASE URL and the paths for the Nexus REST services (Note: uncomment the shopt command if you want debug output).

Lines 11-75: Most of this script is dedicated to command line option parsing. As you can see, we’re using getopts to parse an option string and then we’re checking to see if groupId, artifactId, and version have been supplied. For convenience, we are also defining some defaults – the packaging defaults to jar in this particular script.

Lines 79-85: If the version supplied ends in SNAPSHOT, this script will download the latest SNAPSHOT version from the snapshots repository. If the version supplied does not end in SNAPSHOT, the artifact will be downloaded from the releases directory.

Lines 87-102: This section crafts the request to the Maven artifact redirect service. We create two arrays one is the GET parameters expected by the REST service, and the other is an array of potential values. We loop through these arrays and test for the presence of a particular option to create the properly request URL.

Line 105: Once we have the URL, call curl. Note that this script sends to artifact to STDOUT.

Sure, you can do all of this in Ruby, Perl, Python, or Java, but you couldn’t do it with tools that are going to already be present on all Linux installations. You would also need to train people on whatever scripting language you selected. In this, you use bash to interact with Nexus, you can script your deployment and then hand off responsibility to a sysadmin who doesn’t need to understand the finer points of a scripting language.

Notes / Possibilities for Improvement

Here are some directions you could take this script (since this is a Gist at GitHub you can fork the Gist and improve it):

It would be nice if this script automatically downloaded and verified the SHA1 or MD5 hash for a downloaded artifact. Throwing an error if there is a problem.
Sending the artifact to STDOUT may not always be the desired behavior. Just like curl provides the option to save output to a file, so should this script.


Usage
------

./get_bundle_from_nexus.sh -a ru.mts.sorm:mts-sorm-core:LATEST-SNAPSHOT