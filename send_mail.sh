#!/bin/sh

set -x

sender=$1
reciver=$2
subject=$3
email_content_txt=$4
mailserver=$5
smtp_auth_user=`echo -n "$6" | base64`
smtp_auth_pwd=`echo -n "$7" | base64`

if [ "$#" != 7 ]; then
    echo
    echo "Usage: $0 sender@sever.com rec@domain.com subject mail_content_file mailserver user pwd"
    echo
    exit 3
fi

mail_content()
{
    # echo "in mail_content"
cat <<EOF
To:$reciver
From:$sender
Subject: $subject
Date: `date` +0800
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed


EOF
    test -r $email_content_txt && cat $email_content_txt
}

send_mail()
{
    echo "in send_mail"
    (
    sleep 7
    for comm in "helo localhost" "auth login" $smtp_auth_user "$smtp_auth_pwd" "MAIL FROM:<$sender>" "RCPT TO:<$reciver>" "data"
    do
        echo "$comm";sleep 5
    done
    mail_content
    sleep 4; echo "."; echo "q"
    ) | telnet $mailserver 25
}

send_mail 
