#!/usr/bin/perl

# i-MSCP preseed.pl template file for installer preseeding feature
#
# See documentation at http://wiki.i-mscp.net/doku.php?id=start:preseeding
#
# Author: Laurent Declercq <l.declercq@nuxwin.com>
# Last update: 2018.08.06

use strict;
use warnings;

%::questions = (
    #
    ## System configuration
    #

    # Server hostname
    # Possible values: A fully qualified hostname name
    SERVER_HOSTNAME                     => '',

    # Server primary IP
    # Possible values: An already configured IPv4, IPv6 or 'None'
    # The 'None' option is more suitable for Cloud computing services such as Scaleway and Amazon EC2.
    # Selecting the 'None' option means that i-MSCP will configures the services to listen on all interfaces.
    BASE_SERVER_IP                      => '',

    # WAN IP (only relevant if your primary IP is in private range)
    # You can force usage of a private IP by putting BASE_SERVER_IP IP value
    # instead of a public IP. You can also leave this parameter empty for
    # automatic detection of your public IP using ipinfo.io Web service.
    # Possible values: Ipv4 or IPv6
    BASE_SERVER_PUBLIC_IP               => '',

    # Timezone
    # Possible values: A valid timezone such as Europe/Paris
    # (see http://php.net/manual/en/timezones.php)
    # Leave this parameter empty for automatic timezone detection.
    TIMEZONE                            => '',

    #
    ## Backup configuration parameters
    #

    # i-MSCP backup feature (database and configuration files)
    # Enable backup for i-MSCP
    # Possible values: yes, no
    BACKUP_IMSCP                        => 'yes',

    # Enable backup feature for customers
    # Possible values: yes, no
    BACKUP_DOMAINS                      => 'yes',

    #
    ## SQL server configuration parameters
    #

    # SQL server vendor/version
    # Please consult the ../autoinstaller/Packages/<distro>-<codename>.xml file
    # for available options, leave empty for default SQL vendor/version.
    SQLD_SERVER                         => '',

    # Database name
    DATABASE_NAME                       => 'imscp',

    #
    ## SQL server configuration
    #

    # Databas hostname
    # Possible values: A valid hostname or IP address
    DATABASE_HOST                       => 'localhost',

    # Database port
    # Note that this port is used only for connections through TCP.
    # Possible values: A valid port
    DATABASE_PORT                       => '3306',

    # SQL root user (mandatory)
    # This SQL user must have full privileges on the SQL server.
    # Note that this user used only while i-MSCP installation/reconfiguration.
    SQL_ROOT_USER                       => 'root',
    # Not required when the (system) SQL root user can connect without password
    # (like in recent Debian versions (case of unix_socket plugin usage).
    # In such case you should leave the password empty.
    SQL_ROOT_PASSWORD                   => '',

    # i-MSCP Master SQL user
    # That is the primary SQL user for i-MSCP. It is used to connect to database
    # and create/delete SQL users for your customers.
    # Note that the debian-sys-maint, imscp_srv_user, mysql.user, root and
    # vlogger_user SQL users are not allowed.
    DATABASE_USER                       => 'imscp_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    DATABASE_PASSWORD                   => '',

    # Database user host (only relevant for remote SQL server)
    # That is the host from which SQL users created by i-MSCP are allowed to
    # connect to the SQL server.
    # Possible values: A valid hostname or IP address
    DATABASE_USER_HOST                  => '',

    # Enable or disable prefix/suffix for customer SQL database names
    # Possible values: behind, infront, none
    MYSQL_PREFIX                        => 'none',

    #
    ## Control panel configuration parameters
    #

    # Control panel hostname
    # This is the hostname from which the control panel will be reachable
    # Possible values: A fully qualified hostname name
    BASE_SERVER_VHOST                   => '',

    # Control panel http port
    # Possible values: A port in range 1025-65535
    BASE_SERVER_VHOST_HTTP_PORT         => '8880',

    # Control panel https port (only relevant if SSL is enabled for the control
    # panel (see below))
    # Possible values: A port in range 1025-65535
    BASE_SERVER_VHOST_HTTPS_PORT        => '8443',

    # PHP version for the control panel
    # Possible value: php5.6, php7.0, php7.1
    PANEL_PHP_VERSION                   => 'php7.1',

    # Web server for the control panel
    # Possible value: nginx
    PANEL_HTTPD_SERVER                  => 'nginx',

    # Enable or disable SSL
    # Possible values: yes, no
    PANEL_SSL_ENABLED                   => 'yes',

    # Whether or not a self-signed SSL cettificate must be used
    # Possible values: yes, no
    PANEL_SSL_SELFSIGNED_CERTIFICATE    => 'yes',

    # SSL private key path (only relevant for trusted SSL certificate)
    PANEL_SSL_PRIVATE_KEY_PATH          => '',

    # SSL private key passphrase (only if the private key is encrypted)
    PANEL_SSL_PRIVATE_KEY_PASSPHRASE    => '',

    # SSL CA Bundle path(only relevant for trusted SSL certificate)
    PANEL_SSL_CA_BUNDLE_PATH            => '',

    # SSL certificate path (only relevant for trusted SSL certificate)
    PANEL_SSL_CERTIFICATE_PATH          => '',

    # Alternative URLs feature for client domains
    # Possible values: yes, no
    CLIENT_DOMAIN_ALT_URLS              => 'no',

    # Control panel default access mode (only relevant if SSL is enabled)
    # Possible values: http://, https://
    BASE_SERVER_VHOST_PREFIX            => 'http://',

    # Master administrator login
    ADMIN_LOGIN_NAME                    => 'admin',
    # Only ASCII alphabet characters and numbers are allowed in password.
    ADMIN_PASSWORD                      => '',

    # Master administrator email address
    # Possible value: A valid email address. Be aware that mails sent to local root user will be forwarded to that email.
    DEFAULT_ADMIN_ADDRESS               => '',

    #
    ## DNS server configuration
    #

    # DNS server implementation
    # Possible values: bind, external_server
    NAMED_SERVER                        => 'bind',

    # DNS server mode
    # Only relevant with 'bind' server implementation
    # Possible values: master, slave
    BIND_MODE                           => 'master',

    # Allow to specify IP addresses of your primary DNS servers - Only relevant if you set BIND_MODE to 'slave'
    # Primary DNS server IP addresses
    # Only relevant with master mode
    # Possible value: 'no' or a list of IPv4/IPv6 each separated by a comma, a
    #                 space or a semicolon
    PRIMARY_DNS                         => 'no',

    # Slave DNS server IP addresses
    # Only relevant with slave mode
    # Possible value: 'no' or a list of IPv4/IPv6 each separated by a comma, a
    #                 space or a semicolon
    SECONDARY_DNS                       => 'no',

    # IPv6 support
    # Only relevant with 'bind' server implementation
    # Possible values: yes, no
    BIND_IPV6                           => 'no',

    # IP addresses policy
    # Whether or not routable IP address must be enforced in the
    # DNS zone files.
    BIND_ENFORCE_ROUTABLE_IPS           => 'yes',

    # Local DNS resolver (only relevant with 'bind' server implementation)
    # Possible values: yes, no
    LOCAL_DNS_RESOLVER                  => 'yes',

    #
    ## HTTTPd server configuration parameters
    #

    # HTTPd server implementation
    # Possible values: apache_itk, apache_fcgid, apache_php_fpm
    HTTPD_SERVER                        => 'apache_php_fpm',

    #
    ## PHP configuration parameters
    #

    # PHP version for customers
    # Popssible values: php5.6, php7.0, php7.1, php7.2
    PHP_SERVER                          => 'php5.6',

    # PHP configuration level
    # Possible values: per_user, per_domain, per_site
    PHP_CONFIG_LEVEL                    => 'per_site',

    # PHP-FPM listen socket type
    # Only relevant with 'apache_php_fpm' sever implementation
    # Possible values: uds, tcp
    PHP_FPM_LISTEN_MODE                 => 'uds',

    #
    ## FTPd server configuration parameters
    #

    # FTPd server implementation
    # Possible values: proftpd, vsftpd
    FTPD_SERVER                         => 'proftpd',

    # FTP SQL user
    # Only ASCII alphabet characters and numbers are allowed in password.
    FTPD_SQL_USER                       => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    FTPD_SQL_PASSWORD                   => '',

    # Passive port range
    # Possible values: A valid port range in range 32768-60999
    # Don't forgot to forward TCP traffic on those ports on your server if you're behind a firewall
    FTPD_PASSIVE_PORT_RANGE             => '32800 33800',

    #
    ## MTA server configuration parameters
    #

    # MTA server implementation
    # Possible values: postfix
    MTA_SERVER                          => 'postfix',

    #
    ## IMAP, POP server configuration parameters
    #

    # POP/IMAP servers implementation
    # Possible values: courier, dovecot
    PO_SERVER                           => 'dovecot',

    # Authdaemon SQL user
    # Only ASCII alphabet characters and numbers are allowed in password.
    AUTHDAEMON_SQL_USER                 => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    AUTHDAEMON_SQL_PASSWORD             => '',

    # Dovecot SQL user
    # Only relevant with 'dovecot' server implementation
    # Only ASCII alphabet characters and numbers are allowed in password.
    DOVECOT_SQL_USER                    => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    DOVECOT_SQL_PASSWORD                => '',

    #
    ## SSL configuration for FTP, IMAP/POP and SMTP services
    #

    # Enable or disable SSL
    # Possible values: yes, no
    SERVICES_SSL_ENABLED                => 'yes',

    # Whether or not a self-signed SSL certificate must be used
    # Only relevant if SSL is enabled
    # Possible values: yes, no
    SERVICES_SSL_SELFSIGNED_CERTIFICATE => 'yes',

    # SSL private key path (only relevant for trusted SSL certificate)
    # Possible values: Path to SSL private key
    SERVICES_SSL_PRIVATE_KEY_PATH       => '',

    # SSL private key passphrase (only if the private key is encrypted)
    # Possible values: SSL private key passphrase
    SERVICES_SSL_PRIVATE_KEY_PASSPHRASE => '',

    # SSL CA Bundle path (only relevant for trusted SSL certificate)
    # Possible values: Path to the SSL CA Bundle
    SERVICES_SSL_CA_BUNDLE_PATH         => '',

    # SSL certificate path (only relevant for trusted SSL certificate)
    # Possible values: Path to SSL certificate
    SERVICES_SSL_CERTIFICATE_PATH       => '',

    #
    ## Packages configuration parameters
    #

    # Webstats packages
    # Possible values: 'no' or a list of packages, each comma separated
    WEBSTATS_PACKAGES                   => 'Awstats',

    # FTP Web file manager packages
    # Possible values: MonstaFTP, Pydio (only if the PHP version for the control panel is < 7.0)
    FILEMANAGER_PACKAGE                 => 'MonstaFTP',

    # SQL user for PhpMyAdmin
    PHPMYADMIN_SQL_USER                 => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    PHPMYADMIN_SQL_PASSWORD             => '',

    # Webmmail packages
    # Possible values: 'none' for no packages, or a list of packages, each comma
    #                  separated
    # Available packages: RainLoop, Roundcube
    WEBMAIL_PACKAGES                    => 'RainLoop,Roundcube',

    # SQL user for Roundcube package (only if you use Roundcube)
    ROUNDCUBE_SQL_USER                  => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    ROUNDCUBE_SQL_PASSWORD              => '',

    # SQL user for Rainloop package (only relevant if you use Rainloop)
    RAINLOOP_SQL_USER                   => 'imscp_srv_user',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    RAINLOOP_SQL_PASSWORD               => '',

    # Anti-rootkits packages
    # Possible values: 'none' for no packages, or a list of packages, each
    #                   separated by a comma.
    # Available packages are: Chkrootkit, Rkhunter
    ANTI_ROOTKITS_PACKAGES              => 'Chkrootkit,Rkhunter',

    # Antispam package
    # Possible values: 'none', 'rspamd'
    ANTISPAM                            => 'rspamd',

    # Antivirus package
    # Possible values: 'none', 'clamav'
    #
    # The ClamAV antivirus is executed in different ways depending on whether
    # you choose `Rspamd` or not as antispam. If you choose `Rspamd` as
    # antispam, `ClamAV` will be executed by the `Rspamd` antivirus module,
    # else it will be executed through
    # `ClamAV milter`.
    ANTIVIRUS                           => 'clamav',

    # Rspamd module to enable (only relevant if you choose Rspamd as antispam)
    # Possible values: 'none' for no modules, or a list of module, each
    #                  separated by a comma or semicolon.
    #
    # Available modules are:
    #
    # - ASN
    # - DKIM
    # - DKIM Signing,
    # - DMARC,
    # - Emails,
    # - Greylisting
    # - Milter Headers
    # - Mime Types
    # - MX Check
    # - RBL
    # - Redis History
    # - SPF
    # - Surbl
    #
    # The Rspamd antivirus module is managed internally and enabled only if you
    # choose ClamAV as antivirus solution.
    RSPAMD_MODULES                      => 'ASN,DKIM,DKIM Signing DMARC,Emails,Greylisting,Milter Headers,Mime Types,MX check,RBL,Redis History,SPF,Surbl',

    # Rspamd Web interface (only relevant if you choose Rspamd as antispam)
    # Whether or not to enable the Rspamd Web interface
    # Possible values: yes, no
    RSPAMD_WEBUI                        => 'yes',
    # Only ASCII alphabet characters and numbers are allowed in password.
    # Leave this parameter empty for automatic password generation.
    RSPAMD_WEBUI_PASSWORD               => '',
);

1;
