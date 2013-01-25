Installation / Appendix
=======================

Bash >=4.2 (Optional)
---------------------

### MacOsx

Install latest bash release using [homebrew](http://mxcl.github.com/homebrew/): 

`brew install bash` 

and switch current/new bash version (replace in path in snippet) 

`sudo mv /bin/bash /bin/bash-bak && sudo ln -s /bin/bash /usr/local/Cellar/bash/4.2.42/bin/bash`

Growl (Optional)
----------------

Tested with sources tagged [Growl.app 2.0.1](http://code.google.com/p/growl/source/list?name=Growl.app+2.0.1)

### Growl.app

```shell

# set compiler options
export LC_ALL="en_US.UTF-8"

# fetch sources
hg clone https://code.google.com/p/growl/

# fetch tag (see » hg tags | sort)
hg update "Growl.app 2.0.1"
```

Use Keychain Access.app to create the following self-signed code sign certificates:
* '3rd Party Mac Developer Application: The Growl Project, LLC' 
* '3rd Party Mac Developer Application'
* 'Mac Developer'

When doing a rebuild after a complaint about the certificate be sure to clean before running the build again. In extremis; restart xcode.

More infos can be found [here](http://growl.info/documentation/developer/growl-source-install.php), [here](http://code.google.com/p/growl/) and [here](http://growl.info/extras.php#growlnotify)

### GrowlNotify

Project can be found under Extras/. Build and copy resulting product to /usr/local/bin and ensure this directory is contained in your PATH variable.

```
Usage: growlnotify [-hsvuwc] [-i ext] [-I filepath] [--image filepath]
                               [-a appname] [-p priority] [-H host] [-P password]
                               [--port port] [-n name] [-A method] [--progress value]
                               [--html] [-m message] [-t] [title]
            Options:
                -h,--help       Display this help
                -v,--version    Display version number
                -n,--name       Set the name of the application that sends the notification
                                [Default: growlnotify]
                -s,--sticky     Make the notification sticky
                -a,--appIcon    Specify an application name to take the icon from
                -i,--icon       Specify a file type or extension to look up for the notification icon
                -I,--iconpath   Specify a file whose icon will be the notification icon
                   --image      Specify an image file to be used for the notification icon
                -m,--message    Sets the message to be used instead of using stdin
                                Passing - as the argument means read from stdin
                -p,--priority   Specify an int or named key (default is 0)
                -d,--identifier Specify a notification identifier (used for coalescing)
                -H,--host       Specify a hostname to which to send a remote notification.
                -P,--password   Password used for remote notifications.
                -u,--udp        Use UDP instead of DO to send a remote notification.
                   --port       Port number for UDP notifications.
                -A,--auth       Specify digest algorithm for UDP authentication.
                                Either MD5 [Default], SHA256 or NONE.
                -c,--crypt      Encrypt UDP notifications.
                -w,--wait       Wait until the notification has been dismissed.
                   --progress   Set a progress value for this notification.
            
            Display a notification using the title given on the command-line and the
            message given in the standard input.
            
            Priority can be one of the following named keys: Very Low, Moderate, Normal,
            High, Emergency. It can also be an int between -2 and 2.
            
            To be compatible with gNotify the following switch is accepted:
                -t,--title      Does nothing. Any text following will be treated as the
                                title because that's the default argument behaviour

man growlnotify

```

Knowingly supported platforms
-----------------------------
* OSX System Version: OS X 10.8.1 (12B19) / Kernel Version: Darwin 12.1.0
 No newline at end of file
